---
summary: "Workspace template for TOOLS.md"
read_when:
  - Bootstrapping a workspace manually
---

# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

## What Goes Here

Things like:

- Camera names and locations
- SSH hosts and aliases
- Preferred voices for TTS
- Speaker/room names
- Device nicknames
- Anything environment-specific

## Examples

```markdown
### Cameras

- living-room → Main area, 180° wide angle
- front-door → Entrance, motion-triggered

### SSH

- home-server → 192.168.1.100, user: admin

### TTS

- Preferred voice: "Nova" (warm, slightly British)
- Default speaker: Kitchen HomePod
```

## This Host

### Installed skill binaries

- `mcporter` → `/data/.local/bin/mcporter`
- `summarize` → `/data/.local/bin/summarize`
- `summarizer` → `/data/.local/bin/summarizer`
- `gog` → not installed; skill expects Homebrew formula `steipete/tap/gogcli`, but `brew` is not present in this container
- `uv` → not installed (needed for `nano-banana-pro` helper script)

### Skill-related config

- `summarize` config → `/data/.summarize/config.json`
- `nano-banana-pro` can use `GEMINI_API_KEY` from env
- `api-gateway` / `github-api` need `MATON_API_KEY` (currently not configured)
- `self-improving-agent` learnings dir → `/data/.openclaw/workspace/.learnings/`

## Why Separate?

Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes, and share skills without leaking your infrastructure.

---

Add whatever helps you do your job. This is your cheat sheet.