# OpenClaw Update Quickstart

**TL;DR:** Snapshot → Update → Healthcheck → Done

---

## One-Command Update Flow

```bash
# 1. PRE-UPDATE (create baseline)
bash /data/.openclaw/workspace/scripts/pre-update-snapshot.sh

# 2. UPDATE (when ready)
sudo npm install -g openclaw@latest

# 3. POST-UPDATE (validate)
bash /data/.openclaw/workspace/scripts/post-update-healthcheck.sh
```

---

## When Things Break

**Option A: Rollback workspace only**
```bash
cd /data/.openclaw/workspace
git reset --hard <COMMIT_SHA>
```

**Option B: Full machine rollback (Hostinger VPS)**
- Restore VPS snapshot via Hostinger dashboard (~30 min)

---

## Scheduled Pre-Update Snapshot

Runs automatically every **Sunday 2:00 AM MDT**

- Creates git commit + VPS snapshot
- Sends Telegram notification
- Logged to `memory/projects/update-history.md`

---

## What Healthcheck Tests

✅ Gateway process  
✅ Memory architecture (Layer 0, 1, 0.5, LCM)  
✅ Plugins & skills  
✅ Cron jobs  
✅ Config validity  
✅ Workspace integrity  

---

## Status Meanings

| Output | Meaning |
|--------|---------|
| ✅ HEALTHY | All good, proceed normally |
| ⚠️ DEGRADED | Warnings only, monitor |
| ❌ UNHEALTHY | Failures detected, see remediation |

---

## Rollback in Seconds

**Pre-update commit:** Stored in `memory/projects/update-history.md`

Example:
```
Git Commit: a7f3c2e
VPS Snapshot: snap-20260415-192600
```

If you need to go back:
```bash
git reset --hard a7f3c2e
```

---

## Full Guide

See: `/data/.openclaw/workspace/memory/projects/UPDATE-PROTOCOL.md`

---

**Last updated:** 2026-04-15 19:26 EDT
