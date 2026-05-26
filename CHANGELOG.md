# Changelog

All notable changes to this skill are documented here.

The format is loosely based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this skill follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-05-25

first public release. the cozy ritual of a Study With Me stream, now a Claude Code skill.

### Added

- `/study-with-me` slash command with full session workflow
- four-question intake via `AskUserQuestion` (goal, length, done-looks-like, energy)
- opt-in environment ritual (Do Not Disturb, app close/open, focus playlist)
- HTML popup timer that opens as a Chromium `--app=` window
  - self-updating countdown via JS (background-tab throttling safe)
  - four visual states: focus, last-minute warning, break, complete
  - configurable accent color and font
- bell notifications at halfway, last minute, and block complete
- break check-in with one-question accountability prompt
- wrap-up flow with delivered/next-step/energy/reflection capture
- markdown session logs written to `~/Documents/study-log/YYYY/MM/`
- weekly and monthly rollups (`/study-with-me review week|month`) with:
  - total focused hours, session count, streak
  - goal-vs-delivered ratio
  - energy patterns and drift extraction
  - 2 or 3 data-grounded suggestions
- flags: `--quick`, `--with <skill-name>`, `--resume`
- cross-platform adapter layer (macOS, Windows, Linux) with common interface:
  `dnd_on`, `dnd_off`, `close_apps`, `open_apps`, `play_focus_music`,
  `stop_focus_music`, `notify`
- crash recovery: orphaned `active-session.json` is auto-archived on next invocation
- friendly README in the voice of a Study With Me YouTuber

### Platform support

| feature              | macOS              | Windows         | Linux           |
| -------------------- | ------------------ | --------------- | --------------- |
| Do Not Disturb       | Shortcuts          | TODO            | GNOME           |
| close / open apps    | osascript          | Stop/Start-Process | pkill / xdg-open |
| focus playlist       | Spotify, Music, URL | URL             | URL             |
| pause music          | Spotify, Music     | TODO            | playerctl       |
| bell notification    | osascript          | NotifyIcon      | notify-send     |
| HTML timer popup     | Chrome / Edge / Brave / Arc | Chrome / Edge | Chromium / Chrome |

Anything marked TODO falls back gracefully. Sessions never break because a
platform feature is missing.

### Known limitations

- YouTube focus playlists cannot be paused automatically at session end
  (browser tab stays open and music keeps playing).
- Windows Do Not Disturb adapter is a stub.
- Linux Do Not Disturb only covered for GNOME so far.
