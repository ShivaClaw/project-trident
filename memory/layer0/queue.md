# Layer 0 — L2 Upload Queue

Files queued for upload to GitHub (shiva-memory repo). Processed by daily cron (3 AM MST).

## Pending uploads
(none yet — agent not yet running)

## Upload history
(none yet)

## Format
Each entry:
```
- path: memory/archive/daily/YYYY-MM-DD.md
  queued: YYYY-MM-DDTHH:MM:SSZ
  status: pending|uploaded|failed
  l2_path: archives/daily/YYYY-MM-DD.md
  sha: (git commit sha after upload)
```
