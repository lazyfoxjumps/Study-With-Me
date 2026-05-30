#!/usr/bin/env bash
# render-timer.sh — substitute session data into the HTML template, open in a popup window
#
# Usage:
#   render-timer.sh --goal "..." --label "Block 1 of 2 - Focus" \
#                   --duration-min 50 --mode focus \
#                   [--accent "#a78bfa"] [--bg "#0f172a"] [--warn "#f59e0b"] \
#                   [--break-color "#22c55e"] [--done-color "#22c55e"] \
#                   [--font "system-ui"] [--rewind-seconds 60] \
#                   [--open-in-window true]
#
# Modes: focus | break
# Cross-platform: macOS, Windows (Git Bash / WSL), Linux
#
# If color args are omitted, defaults are pulled from
# ~/.claude/skills/study-with-me/config.json (timer_ui.theme).

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE="$SCRIPT_DIR/timer-template.html"
OUT="${TMPDIR:-/tmp}/study-with-me-timer.html"
CONFIG_FILE="${HOME}/.claude/skills/study-with-me/config.json"

GOAL=""
LABEL=""
DURATION_MIN=25
MODE="focus"
FONT=""
ACCENT=""
BG=""
WARN=""
BREAK_COLOR=""
DONE_COLOR=""
REWIND_SECONDS=""
OPEN_IN_WINDOW="true"

while [ $# -gt 0 ]; do
  case "$1" in
    --goal)            GOAL="$2"; shift 2 ;;
    --label)           LABEL="$2"; shift 2 ;;
    --duration-min)    DURATION_MIN="$2"; shift 2 ;;
    --mode)            MODE="$2"; shift 2 ;;
    --accent)          ACCENT="$2"; shift 2 ;;
    --bg)              BG="$2"; shift 2 ;;
    --warn)            WARN="$2"; shift 2 ;;
    --break-color)     BREAK_COLOR="$2"; shift 2 ;;
    --done-color)      DONE_COLOR="$2"; shift 2 ;;
    --font)            FONT="$2"; shift 2 ;;
    --rewind-seconds)  REWIND_SECONDS="$2"; shift 2 ;;
    --open-in-window)  OPEN_IN_WINDOW="$2"; shift 2 ;;
    *) echo "unknown arg: $1" >&2; exit 1 ;;
  esac
done

if [ ! -f "$TEMPLATE" ]; then
  echo "render-timer: template not found at $TEMPLATE" >&2
  exit 1
fi

# Pull defaults from config.json for any unspecified args.
# Python 3 is more universally present than jq (macOS, most Linux, Windows Git Bash).
config_get() {
  # usage: config_get <python-expr> <fallback>
  local expr="$1"
  local fallback="$2"
  if [ -f "$CONFIG_FILE" ] && command -v python3 >/dev/null 2>&1; then
    python3 -c "
import json, sys
try:
    with open('$CONFIG_FILE') as f:
        cfg = json.load(f)
    val = $expr
    print(val if val is not None else '$fallback')
except Exception:
    print('$fallback')
" 2>/dev/null
  else
    echo "$fallback"
  fi
}

[ -z "$ACCENT" ]         && ACCENT=$(config_get       "cfg.get('timer_ui', {}).get('theme', {}).get('accent')"     "#a78bfa")
[ -z "$BG" ]             && BG=$(config_get           "cfg.get('timer_ui', {}).get('theme', {}).get('background')" "#0f172a")
[ -z "$WARN" ]           && WARN=$(config_get         "cfg.get('timer_ui', {}).get('theme', {}).get('warn')"       "#f59e0b")
[ -z "$BREAK_COLOR" ]    && BREAK_COLOR=$(config_get  "cfg.get('timer_ui', {}).get('theme', {}).get('break')"      "#22c55e")
[ -z "$DONE_COLOR" ]     && DONE_COLOR=$(config_get   "cfg.get('timer_ui', {}).get('theme', {}).get('done')"       "#22c55e")
[ -z "$FONT" ]           && FONT=$(config_get         "cfg.get('timer_ui', {}).get('font')"                        "system-ui")
[ -z "$REWIND_SECONDS" ] && REWIND_SECONDS=$(config_get "cfg.get('timer_ui', {}).get('rewind_seconds')"            "60")

START_TS=$(($(date +%s) * 1000))
END_TS=$((START_TS + DURATION_MIN * 60 * 1000))
START_HHMM=$(date +"%H:%M")

# Escape forward-slashes and ampersands for sed safety
esc() { printf '%s' "$1" | sed -e 's/[\/&]/\\&/g'; }

sed \
  -e "s/__GOAL__/$(esc "$GOAL")/g" \
  -e "s/__LABEL__/$(esc "$LABEL")/g" \
  -e "s/__MODE__/$(esc "$MODE")/g" \
  -e "s/__ACCENT__/$(esc "$ACCENT")/g" \
  -e "s/__BG__/$(esc "$BG")/g" \
  -e "s/__WARN__/$(esc "$WARN")/g" \
  -e "s/__BREAK__/$(esc "$BREAK_COLOR")/g" \
  -e "s/__DONE__/$(esc "$DONE_COLOR")/g" \
  -e "s/__FONT__/$(esc "$FONT")/g" \
  -e "s/__START_TS__/$START_TS/g" \
  -e "s/__END_TS__/$END_TS/g" \
  -e "s/__START_HHMM__/$(esc "$START_HHMM")/g" \
  -e "s/__REWIND_SECONDS__/$REWIND_SECONDS/g" \
  "$TEMPLATE" > "$OUT"

# Detect platform
UNAME="$(uname -s 2>/dev/null || echo Unknown)"

# Find a Chromium-family browser for --app= window mode (no chrome, popup-like)
find_chromium() {
  case "$UNAME" in
    Darwin)
      for b in \
        "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
        "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge" \
        "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser" \
        "/Applications/Chromium.app/Contents/MacOS/Chromium" \
        "/Applications/Arc.app/Contents/MacOS/Arc"; do
        [ -x "$b" ] && { echo "$b"; return 0; }
      done
      ;;
    Linux)
      for b in google-chrome google-chrome-stable chromium chromium-browser microsoft-edge brave-browser; do
        command -v "$b" >/dev/null 2>&1 && { command -v "$b"; return 0; }
      done
      ;;
    MINGW*|MSYS*|CYGWIN*)
      for b in \
        "/c/Program Files/Google/Chrome/Application/chrome.exe" \
        "/c/Program Files (x86)/Google/Chrome/Application/chrome.exe" \
        "/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe" \
        "/c/Program Files/BraveSoftware/Brave-Browser/Application/brave.exe"; do
        [ -x "$b" ] && { echo "$b"; return 0; }
      done
      ;;
  esac
  return 1
}

open_in_window_mode() {
  local browser url
  browser="$(find_chromium 2>/dev/null || true)"
  url="file://$OUT"
  if [ -z "$browser" ]; then
    return 1
  fi
  case "$UNAME" in
    Darwin)
      "$browser" --app="$url" --window-size=560,520 >/dev/null 2>&1 &
      ;;
    Linux)
      "$browser" --app="$url" --window-size=560,520 >/dev/null 2>&1 &
      ;;
    MINGW*|MSYS*|CYGWIN*)
      "$browser" --app="$url" --window-size=560,520 >/dev/null 2>&1 &
      ;;
  esac
  return 0
}

open_in_tab() {
  case "$UNAME" in
    Darwin)             open "$OUT" ;;
    Linux)              xdg-open "$OUT" >/dev/null 2>&1 || true ;;
    MINGW*|MSYS*|CYGWIN*) start "" "$OUT" ;;
    *)                  echo "render-timer: unknown platform, file is at $OUT" ;;
  esac
}

if [ "$OPEN_IN_WINDOW" = "true" ]; then
  if ! open_in_window_mode; then
    echo "render-timer: no Chromium-family browser found, falling back to default browser tab"
    open_in_tab
  fi
else
  open_in_tab
fi

echo "render-timer: ok ($OUT)"
