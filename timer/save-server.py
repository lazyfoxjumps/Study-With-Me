#!/usr/bin/env python3
"""
Tiny local-only HTTP server that writes theme changes from the timer
popup back into config.json. Started in the background by render-timer.sh.

Security:
  - Binds to 127.0.0.1 only (never reachable from another host).
  - Authenticates each request with a per-session random token in the URL path.
  - Validates theme payload against a strict schema (5 known keys, hex strings).

Lifecycle:
  - Self-terminates after IDLE_TIMEOUT seconds with no requests (default 4 hours).
  - Also enforces HARD_TIMEOUT seconds since boot (default 8 hours) as a safety stop.

Usage:
  save-server.py <config-path> <token> <port>
"""

import json, os, re, sys, threading, time
from http.server import BaseHTTPRequestHandler, HTTPServer

if len(sys.argv) != 4:
    print("usage: save-server.py <config-path> <token> <port>", file=sys.stderr)
    sys.exit(2)

CONFIG_PATH = sys.argv[1]
TOKEN = sys.argv[2]
PORT = int(sys.argv[3])

IDLE_TIMEOUT = 4 * 60 * 60
HARD_TIMEOUT = 8 * 60 * 60
HEX_RE = re.compile(r"^#[0-9a-fA-F]{6}$")
VALID_KEYS = {"accent", "background", "warn", "break", "done"}

last_request = time.time()
boot_time = time.time()
lock = threading.Lock()


class Handler(BaseHTTPRequestHandler):
    def log_message(self, fmt, *args):
        return  # silent

    def _cors(self):
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "POST, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "content-type")
        # Chrome 109+ Private Network Access: file:// (public) -> 127.0.0.1 (loopback)
        # requires this header on the preflight, or the actual POST is blocked.
        self.send_header("Access-Control-Allow-Private-Network", "true")

    def do_OPTIONS(self):
        self.send_response(204)
        self._cors()
        self.end_headers()

    def do_POST(self):
        global last_request
        last_request = time.time()

        parts = self.path.strip("/").split("/")
        if len(parts) != 2 or parts[0] != "save-theme" or parts[1] != TOKEN:
            self._error(403, "forbidden")
            return

        try:
            length = int(self.headers.get("Content-Length", 0))
            body = json.loads(self.rfile.read(length).decode("utf-8"))
            if not isinstance(body, dict):
                raise ValueError("payload must be an object")
            for k, v in body.items():
                if k not in VALID_KEYS:
                    raise ValueError(f"unknown key: {k}")
                if not isinstance(v, str) or not HEX_RE.match(v):
                    raise ValueError(f"invalid hex for {k}: {v!r}")

            with lock:
                with open(CONFIG_PATH, "r") as f:
                    cfg = json.load(f)
                cfg.setdefault("timer_ui", {}).setdefault("theme", {}).update(body)
                with open(CONFIG_PATH, "w") as f:
                    json.dump(cfg, f, indent=2)
                    f.write("\n")

            self.send_response(200)
            self._cors()
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            self.wfile.write(b'{"ok": true}')
        except Exception as e:
            self._error(400, str(e))

    def _error(self, code, msg):
        self.send_response(code)
        self._cors()
        self.send_header("Content-Type", "application/json")
        self.end_headers()
        self.wfile.write(json.dumps({"ok": False, "error": msg}).encode())


def watchdog():
    while True:
        time.sleep(60)
        now = time.time()
        if now - last_request > IDLE_TIMEOUT or now - boot_time > HARD_TIMEOUT:
            os._exit(0)


def main():
    threading.Thread(target=watchdog, daemon=True).start()
    server = HTTPServer(("127.0.0.1", PORT), Handler)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass


if __name__ == "__main__":
    main()
