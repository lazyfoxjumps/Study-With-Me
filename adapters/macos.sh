#!/usr/bin/env bash
# Study With Me — macOS adapter
# Interface: dnd_on | dnd_off | close_apps <list> | open_apps <list> | play_focus_music <uri> | stop_focus_music | notify <title> <message>

set -e

cmd="${1:-}"
shift || true

dnd_on() {
  # Toggle Do Not Disturb / Focus via shortcuts.app (most reliable on modern macOS)
  if shortcuts list 2>/dev/null | grep -qi "^Turn On Do Not Disturb$"; then
    shortcuts run "Turn On Do Not Disturb"
    echo "dnd_on: ok"
  else
    osascript -e 'tell application "System Events" to keystroke "d" using {control down, option down, command down}' 2>/dev/null \
      && echo "dnd_on: ok (keystroke fallback, configure a shortcut named 'Turn On Do Not Disturb' for reliability)" \
      || echo "not supported on this platform"
  fi
}

dnd_off() {
  if shortcuts list 2>/dev/null | grep -qi "^Turn Off Do Not Disturb$"; then
    shortcuts run "Turn Off Do Not Disturb"
    echo "dnd_off: ok"
  else
    osascript -e 'tell application "System Events" to keystroke "d" using {control down, option down, command down}' 2>/dev/null \
      && echo "dnd_off: ok (keystroke fallback)" \
      || echo "not supported on this platform"
  fi
}

close_apps() {
  for app in "$@"; do
    osascript -e "tell application \"$app\" to quit" 2>/dev/null \
      && echo "closed: $app" \
      || echo "skip: $app (not running or not closable)"
  done
}

open_apps() {
  for app in "$@"; do
    open -a "$app" 2>/dev/null \
      && echo "opened: $app" \
      || echo "skip: $app (not found)"
  done
}

play_focus_music() {
  uri="${1:-}"
  if [ -z "$uri" ]; then
    echo "play_focus_music: no uri configured, skipping"
    return 0
  fi
  open "$uri" 2>/dev/null \
    && echo "play_focus_music: ok ($uri)" \
    || echo "play_focus_music: failed to open uri"
}

stop_focus_music() {
  osascript -e 'tell application "Spotify" to pause' 2>/dev/null && echo "stop_focus_music: Spotify paused" && return 0
  osascript -e 'tell application "Music" to pause' 2>/dev/null && echo "stop_focus_music: Music paused" && return 0
  echo "stop_focus_music: no player running"
}

notify() {
  title="${1:-Study With Me}"
  message="${2:-}"
  osascript -e "display notification \"$message\" with title \"$title\" sound name \"Tink\"" 2>/dev/null \
    && echo "notify: ok" \
    || echo "notify: failed"
}

case "$cmd" in
  dnd_on)             dnd_on ;;
  dnd_off)            dnd_off ;;
  close_apps)         close_apps "$@" ;;
  open_apps)          open_apps "$@" ;;
  play_focus_music)   play_focus_music "$@" ;;
  stop_focus_music)   stop_focus_music ;;
  notify)             notify "$@" ;;
  *)                  echo "not supported on this platform" ; exit 0 ;;
esac
