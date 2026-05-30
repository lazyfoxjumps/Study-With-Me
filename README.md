# Study With Me

> **new in v1.1**, the timer popup now has live controls (rewind, pause/play, skip) and a 5-color theme picker that saves back to your config. tap the gear icon to vibe-match the timer to your mood. see [CHANGELOG.md](CHANGELOG.md) for details.

hey, glad you're here.

if you've ever opened YouTube at 9pm, typed "study with me", and felt your shoulders drop a little just because some stranger lit a candle and started working in silence next to you, this skill is built for the same feeling. except now it lives in your terminal. and it remembers what you did.

think of it less like a productivity app and more like a quiet study buddy who shows up, sets the table, sits down with you, and writes down what you got done before they leave.

## what it actually does

you type `/study-with-me` and it walks you through a full focus session:

1. asks you four short questions (what, how long, what does done look like, how are you feeling)
2. (optionally) sets the room: turns on Do Not Disturb, closes the distracting apps, opens the ones you need, starts your focus playlist
3. opens a beautiful full-window timer in your browser
4. pings you with a soft bell at halfway, last minute, and complete
5. then stays out of your way for the whole block. no nagging, no "you got this!", no productivity guilt
6. when the timer rings, asks one honest question: "you said you'd [thing]. where are you?"
7. gives you a break
8. wraps up by capturing what you did, what's next, and how you're feeling
9. quietly writes the whole session to a markdown log so future-you can see the patterns

## the philosophy (the why behind it)

the Study With Me genre works because of three things: someone else is there, there's a ritual, and you can see your progress later. this skill borrows all three.

- **presence**, a quiet timer window sits in the corner of your screen so the session feels held, not just timed
- **ritual**, the environment setup turns "starting work" into something physical, lights dimmed, distractions gone, music on, before your brain has time to argue
- **proof of progress**, every session writes a markdown log to your folder. after a week you can scroll back and see real evidence that you showed up

the skill never interrupts you during a focus block. ever. the only signals are the visual timer in your browser and a gentle bell at three moments. that's it. you get to disappear into the work.

## getting started

if you're reading this, the skill is probably already installed. type any of these into Claude and you're off:

- `/study-with-me`
- "let's do a focus session"
- "I need to focus for 50 minutes"
- "body double me"
- "help me focus"

first time? open `config.json` and drop in your focus playlist (Spotify URI, Apple Music URL, YouTube playlist, your call). you can change everything else later.

## the four-question intake

every session starts with four quick questions:

1. **what are you working on**, one line, the more specific the better
2. **session length**, 25, 50, 90 min, or custom
3. **what does done look like**, this is the magic one. vague answers ("work on the doc") get gently pushed back. concrete answers ("finish the intro section and outline section 4") set up everything else
4. **energy level**, low, medium, or high. tracked over time so you can see when you're actually sharp

the answers get saved immediately so even if your laptop dies mid-session, your goal isn't lost.

## the environment ritual (optional)

before the timer starts, the skill offers to set up your space:

- **Do Not Disturb on**, no pings, no banners, no Slack guilt
- **close the distracting apps**, configurable list, default kills Slack / Messages / Discord / Mail
- **open the apps you need**, based on whether you're writing, coding, or studying
- **start your focus playlist**, Spotify / Apple Music / YouTube / anything that has a URL
- **(advanced) Chrome tab triage**, close every tab that isn't on the allowlist
- **(advanced) window snapping**, arrange your workspace into a saved layout

three flavors: **full ritual** (everything), **quick ritual** (just DnD and music), or **skip** if you're already locked in.

if you ever want to skip it entirely, run `/study-with-me --quick` and go straight to the timer.

## the timer

this is the part that makes it feel like a Study With Me video.

a clean, dark, full-window timer opens in its own popup. big numbers, gentle progress bar, your goal at the top so you don't forget what you're here for. it auto-updates every second and stays accurate even if you tab away.

three states:
- **focus**, calm purple accent, gentle pulse, "you're working"
- **last minute**, amber warning glow, "wrap up your thought"
- **break**, soft green, "rest now"
- **complete**, dark and quiet, "you did it"

bells fire at three moments via macOS notifications (or notify-send on Linux, NotifyIcon on Windows):
- halfway through
- final minute
- block complete

a soft in-browser chime fires at the same three moments, synced to the visual timer (so it stays correct even if you pause, rewind, or skip).

you can turn any of these off in `config.json` under `timer_ui`. set `native_bells: false` if you only want the in-browser chime (always synced to the visual timer, no drift after manual control).

### controls (new in v1.1)

three buttons sit just below the progress bar:

- **⏮ rewind** adds 60 seconds back onto the clock (configurable in `config.json` as `rewind_seconds`)
- **⏸ / ▶ pause/play** freezes and resumes the countdown
- **⏭ skip** ends the block immediately and plays the completion chime

keyboard shortcuts work too: space pauses, ← rewinds, → skips.

### theme picker (new in v1.1)

click the gear icon (top right) to open a settings panel with five color rows:

- **accent**, the time text and progress bar
- **background**, the whole page
- **warn**, the last-minute glow
- **break**, the rest state
- **done**, block complete

each row has a native color picker plus a hex input. changes apply live. hit **"save as default"** to write the theme back to your `config.json` (Chromium pops a permission prompt). non-Chromium browsers fall back to downloading a `theme.json` snippet.

## the break check-in

when the bell rings, one question:

> "you said you'd [your goal]. where are you?"

answer in one line. you get one line back. on track? short acknowledgement and you're off to the break. drifting? the skill names it gently, no shame, just the truth so you can recalibrate.

then a real break, 5 min after a 25 min block, 10 min after 50 or 90. with optional reminders if you turned them on:
- drink water
- stand up
- 20-20-20 eye rest (look 20 feet away for 20 seconds, every 20 minutes)

## the wrap-up

end of session, four quick things:

1. what did you actually finish (one line)
2. what's the next concrete step (becomes tomorrow's `--resume` goal)
3. energy now vs. start
4. one-line reflection (optional, skip it if you're tired)

then it turns Do Not Disturb off, pauses the music, and asks if you want your apps back.

## the log (the part that compounds)

every session writes a markdown file to `~/Documents/study-log/YYYY/MM/YYYY-MM-DD-HHMM.md`. each one looks like this:

```markdown
---
date: 2026-05-25
start: 14:30
end: 16:15
duration_min: 105
blocks: 2
goal: finish draft of Q2 planning doc
delivered: finished sections 1 through 3, section 4 outlined
energy_start: medium
energy_end: low
next_step: write section 4 prose, around 45 min
---

## Notes
got distracted around the 60min mark when I opened email.

## Reflection
worth blocking email harder next time.
```

these are just markdown. you can open them in Obsidian, grep them, feed them to Claude, whatever. they're yours.

## weekly and monthly rollups

once you've done a few sessions, ask for a review:

- `/study-with-me review week`
- `/study-with-me review month`

the skill reads your log folder and writes you a report:

- total focused hours
- session count
- streak (consecutive days with at least one session)
- goal-vs-delivered ratio (how often you finished what you said you would)
- energy patterns (when you're sharpest in the day or week)
- drift patterns from your reflections
- 2 or 3 specific suggestions grounded in the data, no horoscope-style fluff

this is the part that turns the skill from "fancy timer" into "personal operating system". after a month you'll know things about your focus you didn't know before.

## flags

- `--quick`, skip the environment setup, straight to the timer
- `--with <skill-name>`, pre-load another skill so you can invoke it mid-session. example: `/study-with-me --with natal-chart-reader`. just announces, doesn't auto-fire
- `--resume`, use yesterday's "next step" as today's goal. perfect for "what was I working on?" mornings

## composability

the skill plays well with others. you can invoke any other skill inside a session and the log captures that you did. studying for a test? run `/study-with-me`, then mid-session ask Claude for a quick natal chart, or have it review your code, or whatever. the timer keeps ticking. the session log notes what came up.

## cross-platform

works on macOS, Windows, and Linux. each platform has its own adapter for the ritual features:

| feature | macOS | Windows | Linux |
|---|---|---|---|
| Do Not Disturb | ✅ via Shortcuts | TODO | ✅ on GNOME |
| close / open apps | ✅ | ✅ | ✅ |
| focus playlist | ✅ Spotify / Music / any URL | ✅ any URL | ✅ any URL |
| pause music at end | ✅ Spotify, Apple Music | TODO | ✅ playerctl |
| bell notification | ✅ native banner | ✅ balloon tip | ✅ notify-send |
| HTML timer popup | ✅ Chrome / Edge / Brave / Arc | ✅ Chrome / Edge | ✅ Chromium / Chrome |

anything marked TODO falls back gracefully. the session never breaks because one ritual step is missing on your OS. you just see "not supported on this platform" and the timer keeps running.

## file structure

```
~/.claude/skills/study-with-me/
├── SKILL.md              the brain
├── README.md             this file
├── config.json           your settings
├── adapters/
│   ├── macos.sh
│   ├── windows.ps1
│   └── linux.sh
└── timer/
    ├── timer-template.html
    └── render-timer.sh
```

session logs live separately at `~/Documents/study-log/` (configurable).

## config

open `~/.claude/skills/study-with-me/config.json` and tune to taste:

```json
{
  "focus_playlist": "spotify:playlist:your-uri-here",
  "always_close": ["Slack", "Messages", "Discord", "Mail"],
  "work_modes": {
    "writing": ["Obsidian", "Safari"],
    "code": ["Visual Studio Code", "Terminal"],
    "study": ["Preview", "Notes"]
  },
  "log_dir": "~/Documents/study-log",
  "reminders": { "water": true, "eyes": true, "stand": true },
  "timer_ui": {
    "enabled": true,
    "font": "system-ui",
    "open_in_window": true,
    "notify_halfway": true,
    "notify_last_minute": true,
    "notify_complete": true,
    "native_bells": true,
    "rewind_seconds": 60,
    "theme": {
      "accent":     "#a78bfa",
      "background": "#0f172a",
      "warn":       "#f59e0b",
      "break":      "#22c55e",
      "done":       "#22c55e"
    }
  }
}
```

change the accent color to whatever matches your vibe. change the playlist. add or remove apps. the skill picks it up on next session.

## a few things this skill won't do

- it won't shame you for missing a session
- it won't gamify your focus with streaks and badges (the streak counter exists for awareness, not pressure)
- it won't pretend to be human or fill silence with chatter
- it won't fabricate productivity patterns that aren't in your data
- it won't interrupt a focus block. ever

## one last thing

the value here isn't in any one session. it's in the second month, when you scroll back through your logs and see that you actually did show up, more than you thought. the timer is just the doorway. the logs are the proof.

light a candle. open the doc. press start.

we're working.
