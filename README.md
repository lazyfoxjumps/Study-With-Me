# Loft Hours

> Formerly **Study With Me**. The skill, the workflow, and the voice are unchanged. Only the name moved upstairs.

A body-doubling focus skill for Claude Code. It sets the room, sits down next to you, holds silence while you work, and writes down what you actually got done before it leaves. Think of it less like a productivity app and more like a quiet study buddy who shows up on time and never makes you feel bad.

Built with ADHD and other neurodivergent brains in mind. Not as an afterthought, as the whole point.

## Why this exists

If you have ADHD (or anything in that family: inattentive brain, executive dysfunction, RSD, the works), you already know the productivity-app graveyard. The apps with streaks that punish you. The to-do lists that become a wall of shame. The timers that nag. They all assume the problem is that you don't care enough, so they try to scare or guilt you into caring. That is exactly backwards.

The real friction is usually one of these:

- **Starting.** The gap between "I should work" and actually beginning is where whole afternoons disappear. Task initiation is a real wall, not a character flaw.
- **Object permanence for your own intentions.** You sit down to write the intro and surface two hours later having reorganized your entire desktop. The goal didn't feel real, so it quietly evaporated.
- **No felt sense of progress.** You worked hard all week and your brain insists you did nothing, because there's no record it can point to. The receipts don't exist, so the gaslighting wins.
- **Working alone is hard.** Body doubling (just having another presence nearby) genuinely helps a lot of us focus, which is why "study with me" videos and coworking calls work. It is not a placebo.

Loft Hours is built around those four, specifically. It lowers the cost of starting, keeps your goal physically on screen so it can't dissolve, leaves a written trail so future-you has proof, and acts as a calm presence that holds the session without hovering.

No shame, no gamified pressure, no toxic positivity. It will never tell you to "crush it." It just sits with you and keeps the receipts.

## What it actually does

You type `/loft-hours` and it walks you through a full focus session:

1. Asks four short questions: what, how long, what does done look like, how's your energy.
2. (Optional) Sets the room: turns on Do Not Disturb, closes the distracting apps, opens the ones you need, starts your focus playlist.
3. Opens a calm, full-window timer with your goal right at the top.
4. Pings you with a soft bell at halfway, last minute, and complete.
5. Then gets completely out of your way for the whole block. No nagging, no check-ins, no "you got this."
6. When the timer rings, asks one honest question: "You said you'd [thing]. Where are you?"
7. Gives you a real break.
8. Wraps up by capturing what you did, what's next, and how you're feeling.
9. Quietly writes the whole session to a markdown log, so future-you can see the patterns.

The thing it is most careful about: it does not interrupt you during a focus block. Ever. The only signals are the visual timer and a gentle bell at three moments. You get to disappear into the work, which is the entire point.

## The ADHD-friendly design, on purpose

These aren't accidental. Each piece is doing a specific job:

- **Externalized goal.** Your target sits on screen the whole time, so it can't quietly slip out of working memory. When you look up, it's right there.
- **One-decision start.** You answer four small questions and the session begins. The ritual does the hard "transition into work" part for you, so your brain doesn't get to relitigate whether to start.
- **A real body double.** A quiet presence that holds the session, marks the time, and is there without watching over your shoulder.
- **Frictionless rescue.** Your goal is saved the instant you set it, so a dead laptop or a closed lid doesn't lose your intention. Pick it back up tomorrow with `--resume`.
- **Receipts that fight the gaslighting.** Every session becomes a dated markdown file. When your brain says "you did nothing this week," you can open the folder and prove it wrong.
- **The streak counter is for awareness, not pressure.** It exists so you can see your rhythm, not so a number can make you feel like garbage for missing a day. Miss a day. Nobody's keeping score against you.
- **Gentle redirection instead of shame.** When you drift, it names the drift plainly and kindly, so you can recalibrate. It does not lecture and it does not pile on.

## Getting started

If you're reading this, the skill is probably already installed. Type any of these into Claude and you're off:

- `/loft-hours`
- "Let's do a focus session"
- "I need to focus for 50 minutes"
- "Body double me"
- "Help me focus"

First time? Open `config.json` and drop in your focus playlist (Spotify URI, Apple Music URL, YouTube playlist, your call). Everything else you can tune later.

## The four-question intake

Every session starts with four quick questions:

1. **What are you working on?** One line. The more specific, the better.
2. **How long?** 25, 50, 90 minutes, or custom.
3. **What does done look like?** This is the magic one. Vague answers ("work on the doc") get a single gentle push for specificity. Concrete answers ("finish the intro and outline section 4") set up everything downstream, including how honest the break check-in can be.
4. **How's your energy?** Low, medium, or high. Tracked over time so you can eventually see when you're actually sharp instead of guessing.

Your answers are saved immediately. If your laptop dies mid-session, your goal isn't lost.

## The environment ritual (optional)

Before the timer starts, Loft Hours offers to set up your space. For a lot of us, this is the part that does the heavy lifting, because it turns "starting work" into something physical that happens before your brain has time to argue.

- **Do Not Disturb on.** No pings, no banners, no Slack guilt.
- **Close the distracting apps.** Configurable list. Default clears Slack, Messages, Discord, Mail.
- **Open the apps you need.** Based on whether you're writing, coding, or studying.
- **Start your focus playlist.** Spotify, Apple Music, YouTube, anything with a URL.
- **(Advanced) Chrome tab triage.** Close every tab that isn't on your allowlist.
- **(Advanced) Window snapping.** Arrange your workspace into a saved layout.

Three flavors: **full ritual** (everything), **quick ritual** (just Do Not Disturb and music), or **skip** if you're already locked in. Want to bypass it entirely? Run `/loft-hours --quick` and go straight to the timer.

## The timer

This is the part that makes it feel like a "study with me" stream.

A clean, calm, full-window timer opens in its own popup. Big numbers, a gentle progress bar, and your goal pinned at the top so you never lose the thread of why you're here. It auto-updates every second and stays accurate even if you tab away.

Four states:

- **Focus.** Calm accent, gentle pulse. "You're working."
- **Last minute.** Amber warning glow. "Wrap up your thought."
- **Break.** Soft green. "Rest now."
- **Complete.** Dark and quiet. "You did it."

Bells fire at three moments via native notifications (macOS banners, `notify-send` on Linux, balloon tips on Windows): halfway through, final minute, and block complete. A soft in-browser chime fires at the same three moments, synced to the visual timer, so it stays correct even if you pause, rewind, or skip.

You can turn any of these off in `config.json` under `timer_ui`. Set `native_bells: false` if you only want the in-browser chime (always synced, no drift after manual control).

### Controls

Three buttons sit just below the progress bar:

- **Rewind** adds 60 seconds back onto the clock (configurable as `rewind_seconds`).
- **Pause / Play** freezes and resumes the countdown.
- **Skip** ends the block immediately and plays the completion chime.

Keyboard shortcuts work too: Space pauses, Left arrow rewinds, Right arrow skips.

### Theme picker

Click the gear icon (top right) to open the settings panel.

At the top, five **presets** for the people who do not want to think about hex codes:

- **Dark Academia.** Oxblood and aged oak, Donna Tartt energy.
- **Light Academia.** Sepia ink on parchment cream, sunlit study room.
- **Forest Cottagecore.** Moss and bark, herb garden at dusk.
- **Candlelit Nocturne.** Warm gold on midnight, single candle on the desk.
- **Linen & Latte.** Espresso and warm cream, cozy cafe corner.

Each preset is a pill with the name and a five-swatch preview. Tap to apply instantly. Light backgrounds work as well as dark ones now, since the foreground and overlay colors auto-adjust.

Below the presets, five color slots for full custom tweaking (accent, background, warn, break, done), each with a native color picker plus a hex input. Changes apply live. Hit **"Save as default"** and the theme writes straight back to your `config.json`, silently. No file picker, no permission prompt (a tiny local-only HTTP server on 127.0.0.1 with a per-session token handles the write). Non-Chromium browsers fall back to downloading a `theme.json` snippet.

## The break check-in

When the bell rings, one question:

> "You said you'd [your goal]. Where are you?"

Answer in one line. You get one line back.

- On track? A short acknowledgement and the name of the next chunk. Off you go.
- Drifting? It names the drift specifically and gently. No shame, just the truth, so you can recalibrate without spiraling.

Then a real break: 5 minutes after a 25-minute block, 10 minutes after 50 or 90. With optional reminders if you turned them on:

- Drink water.
- Stand up, stretch the legs.
- 20-20-20 eye rest (look 20 feet away for 20 seconds).

The reminders rotate, so it isn't the same nudge every break.

## The wrap-up

End of session, four quick things:

1. What did you actually finish? (One line.)
2. What's the next concrete step? (Becomes tomorrow's `--resume` goal.)
3. Energy now vs. when you started?
4. One-line reflection (optional, skip it if you're tired).

Then it turns Do Not Disturb off, pauses the music, and asks if you want your apps back, or if you'd rather leave the room quiet.

## The log (the part that compounds)

Every session writes a markdown file to `~/Documents/study-log/YYYY/MM/YYYY-MM-DD-HHMM.md`. Each one looks like this:

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

These are just markdown. Open them in Obsidian, grep them, feed them back to Claude, whatever. They're yours. And they're the antidote to the "I did nothing" lie your brain tells you on hard days.

## Weekly and monthly rollups

Once you've done a few sessions, ask for a review:

- `/loft-hours review week`
- `/loft-hours review month`

It reads your log folder and writes you a report:

- Total focused hours.
- Session count.
- Streak (consecutive days with at least one session).
- Goal-vs-delivered ratio (how often you finished what you said you would).
- Energy patterns (when you're sharpest in the day or week).
- Drift patterns pulled from your reflections.
- Two or three specific suggestions grounded in your actual data, no horoscope-style fluff.

This is the part that turns Loft Hours from "fancy timer" into something closer to a personal operating manual. After a month, you'll know things about your own focus that you genuinely did not know before. For a lot of neurodivergent folks, seeing your patterns from the outside is the difference between fighting your brain and finally working with it. (If the window has fewer than three sessions, it'll say so and skip the analytics instead of inventing patterns.)

## Flags

- `--quick`. Skip the environment setup, go straight to the timer.
- `--with <skill-name>`. Pre-load another skill so you can reach for it mid-session. Example: `/loft-hours --with natal-chart-reader`. It just announces it's ready, it doesn't auto-fire.
- `--resume`. Use yesterday's "next step" as today's goal. Built for the "wait, what was I even doing?" mornings.

## Composability

It plays well with others. Invoke any other skill inside a session and the log captures that you did. Studying for an exam? Run `/loft-hours`, then mid-session ask Claude for a quick explanation, or have it review your code, or whatever you need. The timer keeps ticking. The session log notes what came up.

## Cross-platform

Works on macOS, Windows, and Linux. Each platform has its own adapter for the ritual features:

| Feature | macOS | Windows | Linux |
|---|---|---|---|
| Do Not Disturb | Yes, via Shortcuts | TODO | Yes, on GNOME |
| Close / open apps | Yes | Yes | Yes |
| Focus playlist | Yes, Spotify / Music / any URL | Yes, any URL | Yes, any URL |
| Pause music at end | Yes, Spotify, Apple Music | TODO | Yes, playerctl |
| Bell notification | Yes, native banner | Yes, balloon tip | Yes, notify-send |
| HTML timer popup | Yes, Chrome / Edge / Brave / Arc | Yes, Chrome / Edge | Yes, Chromium / Chrome |

Anything marked TODO falls back gracefully. A session never breaks because one ritual step is missing on your OS. You just see "not supported on this platform" and the timer keeps running.

## File structure

```
~/.claude/skills/loft-hours/
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

Session logs live separately at `~/Documents/study-log/` (configurable).

## Config

Open `~/.claude/skills/loft-hours/config.json` and tune to taste:

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

Change the accent color, swap the playlist, add or remove apps. The skill picks it up on your next session.

## A few things this skill won't do

- It won't shame you for missing a session.
- It won't gamify your focus with streaks and badges (the streak counter is for awareness, not pressure).
- It won't pretend to be human or fill silence with chatter.
- It won't fabricate productivity patterns that aren't in your data.
- It won't interrupt a focus block. Ever.

## One last thing

The value here isn't in any single session. It's in the second month, when you scroll back through your logs and see that you actually did show up, more than your brain wanted to admit. The timer is just the doorway. The logs are the proof.

Light a candle. Open the doc. Press start.

We're working.
