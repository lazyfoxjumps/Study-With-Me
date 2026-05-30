#!/usr/bin/env bash
# Loft Hours — Linux adapter (stub)
# Interface: dnd_on | dnd_off | close_apps <list> | open_apps <list> | play_focus_music <uri> | stop_focus_music | notify <title> <message>
#
# Status: STUB. Fill in for your specific desktop environment.
# Tested patterns to start from:
#   GNOME DnD:    gsettings set org.gnome.desktop.notifications show-banners false
#   KDE DnD:      qdbus org.kde.plasmashell /org/kde/osdService showText "DnD on"  (varies)
#   Music:        playerctl pause / playerctl play
#   Apps:         pkill <name> / xdg-open <name>

set -e

cmd="${1:-}"
shift || true

dnd_on() {
  if command -v gsettings >/dev/null 2>&1; then
    gsettings set org.gnome.desktop.notifications show-banners false 2>/dev/null \
      && echo "dnd_on: ok (gnome)" && return 0
  fi
  echo "not supported on this platform"
}

dnd_off() {
  if command -v gsettings >/dev/null 2>&1; then
    gsettings set org.gnome.desktop.notifications show-banners true 2>/dev/null \
      && echo "dnd_off: ok (gnome)" && return 0
  fi
  echo "not supported on this platform"
}

close_apps() {
  for app in "$@"; do
    pkill -i "$app" 2>/dev/null \
      && echo "closed: $app" \
      || echo "skip: $app (not running)"
  done
}

open_apps() {
  for app in "$@"; do
    if command -v "$app" >/dev/null 2>&1; then
      ("$app" >/dev/null 2>&1 &)
      echo "opened: $app"
    else
      xdg-open "$app" 2>/dev/null && echo "opened: $app" || echo "skip: $app (not found)"
    fi
  done
}

play_focus_music() {
  uri="${1:-}"
  if [ -z "$uri" ]; then
    echo "play_focus_music: no uri configured, skipping"
    return 0
  fi
  if command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$uri" >/dev/null 2>&1 && echo "play_focus_music: ok ($uri)" && return 0
  fi
  echo "not supported on this platform"
}

stop_focus_music() {
  if command -v playerctl >/dev/null 2>&1; then
    playerctl pause 2>/dev/null && echo "stop_focus_music: paused via playerctl" && return 0
  fi
  echo "not supported on this platform"
}

notify() {
  title="${1:-Loft Hours}"
  message="${2:-}"
  if command -v notify-send >/dev/null 2>&1; then
    notify-send "$title" "$message" 2>/dev/null && echo "notify: ok" && return 0
  fi
  echo "not supported on this platform"
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
