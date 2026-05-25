#!/usr/bin/env bash
# render-timer.sh — substitute session data into the HTML template, open in a popup window
#
# Usage:
#   render-timer.sh --goal "..." --label "Block 1 of 2 - Focus" \
#                   --duration-min 50 --mode focus \
#                   [--accent "#a78bfa"] [--font "system-ui"] [--open-in-window true]
#
# Modes: focus | break
# Cross-platform: macOS, Windows (Git Bash / WSL), Linux

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE="$SCRIPT_DIR/timer-template.html"
OUT="${TMPDIR:-/tmp}/study-with-me-timer.html"

GOAL=""
LABEL=""
DURATION_MIN=25
MODE="focus"
ACCENT="#a78bfa"
FONT="system-ui"
OPEN_IN_WINDOW="true"

while [ $# -gt 0 ]; do
  case "$1" in
    --goal)            GOAL="$2"; shift 2 ;;
    --label)           LABEL="$2"; shift 2 ;;
    --duration-min)    DURATION_MIN="$2"; shift 2 ;;
    --mode)            MODE="$2"; shift 2 ;;
    --accent)          ACCENT="$2"; shift 2 ;;
    --font)            FONT="$2"; shift 2 ;;
    --open-in-window)  OPEN_IN_WINDOW="$2"; shift 2 ;;
    *) echo "unknown arg: $1" >&2; exit 1 ;;
  esac
done

if [ ! -f "$TEMPLATE" ]; then
  echo "render-timer: template not found at $TEMPLATE" >&2
  exit 1
fi

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
  -e "s/__FONT__/$(esc "$FONT")/g" \
  -e "s/__START_TS__/$START_TS/g" \
  -e "s/__END_TS__/$END_TS/g" \
  -e "s/__START_HHMM__/$(esc "$START_HHMM")/g" \
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
      "$browser" --app="$url" --window-size=560,420 >/dev/null 2>&1 &
      ;;
    Linux)
      "$browser" --app="$url" --window-size=560,420 >/dev/null 2>&1 &
      ;;
    MINGW*|MSYS*|CYGWIN*)
      "$browser" --app="$url" --window-size=560,420 >/dev/null 2>&1 &
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
