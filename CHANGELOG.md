# Changelog

All notable changes to this skill are documented here.

The format is loosely based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this skill follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-05-25

mid-session controls and theme picker. the timer is now yours to tweak, live.

### Added

- **Mid-session controls** on the timer popup:
  - **⏮ Rewind** adds `timer_ui.rewind_seconds` (default 60) back onto the clock
  - **⏸ / ▶ Pause/Play** freezes and resumes the countdown
  - **⏭ Skip** ends the current block immediately and fires the completion chime
  - Keyboard shortcuts: Space (pause/play), ← (rewind), → (skip)
- **Theme picker** via a gear icon (top right). Five color rows (accent, background, last-minute warning, break, complete), each with a native color picker plus a hex text input. Live preview as you tweak. Working theme persists in `localStorage` across reloads.
- **Save as default** button writes the theme back to `config.json` via the File System Access API on Chromium. Fallback for other browsers: downloads `theme.json` to your Downloads folder with a one-line copy instruction.
- **In-browser chime** synthesized via Web Audio API. Soft 2 or 3-note tones at halfway, last minute, and complete. Always synced to the visual timer, including after pause / rewind / skip. No audio file dependency.
- New config flag `timer_ui.native_bells` (default `true`). Set to `false` to skip native OS bells entirely and rely on the in-browser chime, which always stays in sync with the visual timer.
- New config field `timer_ui.theme` with five hex codes (accent, background, warn, break, done) and `timer_ui.rewind_seconds` (default 60).

### Changed

- `timer/render-timer.sh` now accepts five color args (`--accent`, `--bg`, `--warn`, `--break-color`, `--done-color`) plus `--rewind-seconds`. All optional. When omitted, defaults are read from `config.json` via Python 3 (no `jq` dependency).
- `timer/timer-template.html` rewritten with a small state machine (running / paused / complete) instead of pure derived-from-timestamp rendering. Existing visual style preserved.
- The popup window is slightly taller (520px) to comfortably fit the controls.

### Known limitations

- Native OS bells are scheduled at session start via wall-clock offsets. If the user pauses, rewinds, or skips via the timer controls, native bells will still fire at the originally scheduled times and may drift from the visual timer. Set `timer_ui.native_bells: false` to avoid this and rely on the in-browser chime, which always stays in sync.
- "Save as default" requires the File System Access API (Chromium / Edge / Brave / Arc). Safari and Firefox fall back to a download.

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
