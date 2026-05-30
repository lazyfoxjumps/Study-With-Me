# Changelog

All notable changes to this skill are documented here.

The format is loosely based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this skill follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.4.0] - 2026-05-30

the skill talks like a person now, not a productivity app.

### Changed

- **Break check-in** softened from "you said you'd X. where are you?" to **"hey, what's the update, buddy? you said you'd X."** Same accountability, warmer landing.
- **Intake questions** rephrased to feel conversational: "hey, what are you working on today?", "and what does done look like for this session?", "how's your energy right now?" The vague-goal pushback is still there, just kinder: "let's get a little more specific, what's the thing that'll feel finished?"
- **Wrap-up questions** are now curious instead of clinical: "so, what did you actually get done?", "what's the next move? one concrete thing for tomorrow.", "how's the energy now, vs. when we started?", "anything you want to jot down before you log off?"
- **Environment ritual** prompt: "want me to set the room for you? full ritual, quick ritual, or skip?"
- **Mid-block interruption** answers stay terse but warmer at the end: "quick answer, use `useMemo` here. okay, back to the intro section, you've got this."
- **Break reminders** phrased like a friend, not a wellness app: "drink some water, friend", "stand up, give the legs a stretch", "look 20 feet away for 20 seconds, the eyes will thank you."
- **Close-out ritual** prompt: "want your apps back, or leave the room quiet?"
- New voice rules in `SKILL.md`: lowercase-when-natural, vary endearments so they don't read like a tic, never toxic positivity, never shame, never lecture.

## [1.3.2] - 2026-05-30

### Fixed

- **"Save server unreachable" error in Chrome 109+ on real save attempts.** The save server's CORS preflight response was missing `Access-Control-Allow-Private-Network: true`, which Chrome's Private Network Access enforcement requires for any request from a `file://` origin to `127.0.0.1`. Chrome was returning the preflight as a success but then silently blocking the actual POST. Server now sends the header, the POST goes through, the config writes silently.
- The earlier `curl`-based end-to-end test was insufficient because `curl` does not enforce CORS or PNA. Browsers do. Added a browser-style preflight check to the verification script.

### Changed

- The "Save server unreachable, trying file picker..." message in the theme panel now appends the actual fetch error, so future failures are easier to diagnose.

## [1.3.1] - 2026-05-25

a tiny "X" so you can close the theme panel without hunting for the gear.

### Added

- Close button (✕) in the top-right corner of the theme settings panel. Click to dismiss the panel and go back to just the timer.
- Press `Esc` while the panel is open to close it (keyboard shortcut, doesn't conflict with the existing Space / ← / → controls).

### Changed

- The gear icon (top-right of the timer page) still toggles the panel open and shut, same as before. The new X is just a clearer dismissal for users who don't realize the gear doubles as a close button.

## [1.3.0] - 2026-05-25

"save as default" is now truly silent. no pickers, no prompts, every time.

### Added

- New file `timer/save-server.py`: a tiny local-only HTTP server (Python 3 stdlib, no dependencies) that accepts theme-save POSTs and writes them straight to `config.json`.
- `timer/render-timer.sh` now starts the save server in the background at session boot, picks a free TCP port, generates a per-session random token, and injects the resulting `http://127.0.0.1:<port>/save-theme/<token>` URL into the timer page.
- The timer's **Save as default** button now POSTs the theme to that server. Server validates the token, validates the payload against a strict schema (5 known keys, hex strings only), and rewrites `config.json` atomically. Returns in milliseconds, no UI surface beyond a "Saved." confirmation.

### Changed

- The File System Access + IndexedDB picker flow from v1.2.1 is now a **fallback**, not the primary path. The picker only appears if Python 3 isn't installed, the server fails to bind, or the page can't reach the server. Otherwise users never see a picker again.

### Security

- The save server binds to `127.0.0.1` only and is never reachable from another host on the network.
- Every request must include a per-session random token (`secrets.token_urlsafe(16)`, ~22 chars of entropy) in the URL path. Wrong token → 403.
- Server enforces a strict payload schema. Unknown keys or non-hex values → 400.
- Self-terminates after 4 hours idle or 8 hours hard timeout.

### Known limitations

- Requires Python 3 (already a soft dependency for `render-timer.sh` config reading; no new install needed on macOS, most Linux, or Windows with Python).
- If Python 3 isn't found, the timer gracefully falls back to the v1.2.1 picker flow. Save still works, just with one prompt.

## [1.2.1] - 2026-05-25

"save as default" stops asking you to pick a file location every single time.

### Changed

- The first time you hit **Save as default**, the timer asks you once to point at your `~/.claude/skills/study-with-me/config.json`. The file handle is then persisted in IndexedDB. Every save after that is silent (no picker, no prompt, just writes).
- If the saved location ever goes stale (file moved or deleted), the timer detects it, forgets the stored handle, and prompts you to re-pick. No manual intervention.
- The browser's File System Access permission model means we cannot skip the very first picker (security sandbox). The post-save message now makes this expectation explicit.

### Known limitations

- Stored handle is per-browser-profile. If you run the timer in Chrome `--app` mode but later open the file in a different browser, that browser will need its own first-time pick.

## [1.2.0] - 2026-05-25

five academia-flavored color presets, plus proper light-theme support so the timer doesn't break when the background goes cream.

### Added

- **Five color presets** at the top of the theme panel:
  - **Dark Academia**, oxblood + aged oak, Oxford library energy
  - **Light Academia**, sepia ink + parchment cream, sunlit study room
  - **Forest Cottagecore**, moss + bark, herb garden at dusk
  - **Candlelit Nocturne**, warm gold + midnight navy, single candle on dark wood
  - **Linen & Latte**, espresso + warm cream, cozy cafe corner
- Each preset shows as a horizontal pill with name and 5-swatch preview. Click to apply instantly. Tweak individual slots afterward, then "Save as default" if you want to keep it.
- **Light-theme support.** Foreground text, muted text, surface overlays (control buttons, gear, panel inputs), and the "block complete" backdrop are now auto-derived from background luminance using the W3C relative-luminance formula. Light themes render with dark text on warm overlays; dark themes keep the original look.
- A tiny pre-paint script in `<head>` sets the luminance-derived variables before the first paint, so light themes never flash dark on load.

### Changed

- `timer/timer-template.html`: hardcoded `rgba(255, 255, 255, ...)` and `rgba(15, 23, 42, ...)` values across `.bar-wrap`, `.ctrl`, `.gear`, `.panel`, `.color-row` inputs, and `.panel-actions button` are now driven by theme-aware CSS variables (`--surface-bg`, `--surface-border`).
- `body.done` background switched from hardcoded `#0a0a0a` to a theme-derived `--done-bg` so light themes get a warm dim instead of a stark black.
- Panel background switched from hardcoded dark navy to `var(--bg)` plus a soft drop shadow, so the panel always matches the active theme.

### Known limitations

- The five presets are baked into the template, not user-editable as a list. Build your own by applying a preset, tweaking, and hitting "Save as default."

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
