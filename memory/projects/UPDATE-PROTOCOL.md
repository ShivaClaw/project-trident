# UPDATE PROTOCOL — OpenClaw Update & Backup Resilience

**Version:** 2.0  
**Last Updated:** 2026-04-15 19:26 EDT  
**Status:** Production Ready

---

## Overview

This protocol establishes a three-phase update workflow with automated pre-update snapshots and post-update health validation. The goal: **zero data loss** and **rapid recovery** if updates break anything.

### Three Phases

1. **PRE-UPDATE:** Create versioned baseline (git commit + optional VPS snapshot)
2. **UPDATE:** Manual OpenClaw update command
3. **POST-UPDATE:** Automated healthcheck smoke tests

---

## Phase 1: Pre-Update Snapshot

### Automated (Weekly)

**Cron:** Pre-Update Snapshot (Sunday 2:00 AM MDT)  
**Job ID:** `8feacb87-709d-4e5f-977c-d58a258436ab`  
**Frequency:** Weekly, every Sunday at 2:00 AM MDT

The cron automatically:
1. Creates a git commit with current workspace state
2. Optionally snaps the full VPS (if Hostinger credentials available)
3. Logs both IDs to `memory/projects/update-history.md`
4. Sends Telegram notification to @IntCouple42

### Manual (Before Any Planned Update)

**Command:**
```bash
bash /data/.openclaw/workspace/scripts/pre-update-snapshot.sh
```

**Output:**
```
=== PRE-UPDATE SNAPSHOT WORKFLOW ===
Timestamp: 2026-04-15 19:26:00 UTC
Current version: 2026.4.11

[1/3] Creating git commit snapshot...
  ✅ Committed: a7f3c2e
     Changes: 12 files changed

[2/3] VPS snapshot (optional, Hostinger only)...
  ✅ Snapshot created: snap-20260415-192600

[3/3] Logging snapshot details...
  ✅ Logged to update-history.md

=== SNAPSHOT COMPLETE ===
Git commit:    a7f3c2e
VPS snapshot:  snap-20260415-192600
Ready for:     `openclaw update` or `gateway update.run`
Rollback:      `git reset --hard a7f3c2e` (local only)
```

### What Gets Captured

**Git Commit:**
- All memory files (SOUL.md, USER.md, MEMORY.md, etc.)
- Daily logs (memory/daily/)
- Project tracking (memory/projects/)
- Scripts and tools
- Snapshot timestamp in commit message

**VPS Snapshot (Hostinger):**
- Full machine state
- Docker containers + volumes (Qdrant, FalkorDB, Ollama)
- All workspace files
- Can be restored in ~30 minutes via Hostinger API

### Rollback (Local Only)

If git commit was created but you want to discard changes:
```bash
cd /data/.openclaw/workspace
git reset --hard <COMMIT_SHA>
```

**Note:** This recovers your workspace. The OpenClaw gateway version remains at the current installed version.

---

## Phase 2: Perform Update

### Option A: CLI Update (Recommended)

```bash
# Check what's available
npm view openclaw version

# Run update
openclaw gateway restart
# or
sudo npm install -g openclaw@latest
```

### Option B: Gateway API Update

```bash
openclaw gateway update.run
```

### Before You Update: Verify Pre-Snapshot

1. Check that Sunday 2 AM cron ran (look for Telegram notification or log)
2. Or run manually: `bash /data/.openclaw/workspace/scripts/pre-update-snapshot.sh`
3. Confirm git commit SHA is in `memory/projects/update-history.md`
4. Proceed with update

---

## Phase 3: Post-Update Healthcheck

### Automated Smoke Tests

**Script:** `/data/.openclaw/workspace/scripts/post-update-healthcheck.sh`  
**Job ID:** `02228aef-7e81-483c-b705-25f8189f94fb`  
**Trigger:** Manual (after update completes)

**Run Immediately After Update:**

```bash
bash /data/.openclaw/workspace/scripts/post-update-healthcheck.sh
```

Or via cron:
```bash
openclaw cron run 02228aef-7e81-483c-b705-25f8189f94fb
```

**Output Example:**

```
=== POST-UPDATE HEALTHCHECK ===
Timestamp: 2026-04-15 19:30:00 UTC

[1/6] OpenClaw Gateway Status
✅ PASS | Gateway process | Version: 2026.4.12
✅ PASS | Gateway port 18789 | Listening

[2/6] Memory Architecture
✅ PASS | Layer 0 prompt template | Found
✅ PASS | Layer 1 memory files (4) | All present
✅ PASS | Layer 0.5 semantic context | 15 context files
✅ PASS | LCM plugin database | Size: 80M

[3/6] Plugins & Skills
✅ PASS | Skills installation | 17 skills found
✅ PASS | Plugin: lossless-claw | Loaded
✅ PASS | Plugin: telegram | Loaded
✅ PASS | Plugin: whatsapp | Loaded

[4/6] Cron Infrastructure
✅ PASS | Cron system | 12 jobs registered
✅ PASS | Cron: Layer 0 | Found
✅ PASS | Cron: Morning Briefing | Found
✅ PASS | Cron: Job Hunter | Found

[5/6] Config Schema Validation
✅ PASS | Config JSON validity | Valid JSON
✅ PASS | Active channels | 4 channels enabled

[6/6] Workspace Integrity
✅ PASS | Git repository | Branch: main
✅ PASS | Backup directories | All present
✅ PASS | Script permissions | Executable

=== SUMMARY ===
PASS:  21
WARN:  0
FAIL:  0

Overall Status: ✅ HEALTHY
Log saved: /tmp/post-update-health-20260415-193000.log
```

### Interpreting Results

| Status | Meaning | Action |
|--------|---------|--------|
| ✅ HEALTHY | All tests passed | Safe to proceed normally |
| ⚠️ DEGRADED | Warnings only, no failures | Review warnings, monitor for issues |
| ❌ UNHEALTHY | Critical failures detected | See remediation guidance (below) |

### Remediation Guidance (Automatic)

If any test fails, the script outputs remediation steps. Examples:

**Gateway Process Failed:**
```
1. Check logs: tail -f /data/.npm-global/lib/node_modules/openclaw/logs/gateway.log
2. Restart: openclaw gateway restart
3. If still failing: Rollback git commit or VPS snapshot
```

**Config Integrity Failed:**
```
1. Backup: cp /data/.openclaw/openclaw.json /tmp/openclaw.json.bak
2. Validate: python3 -m json.tool < /data/.openclaw/openclaw.json
3. If malformed: git checkout HEAD -- /data/.openclaw/openclaw.json
```

**Plugin/Skills Issue:**
```
1. Reinstall plugins: openclaw gateway restart
2. Check plugin hashes: git status .openclaw/plugins/
3. If corrupted: git checkout HEAD -- .openclaw/plugins/
```

---

## Complete Update Workflow

### Step-by-Step

1. **Saturday/Sunday Evening:** Pre-update snapshot runs automatically (or run manually)
   ```bash
   bash /data/.openclaw/workspace/scripts/pre-update-snapshot.sh
   ```

2. **Sunday Evening:** Check Telegram notification for snapshot confirmation
   - Commit SHA: a7f3c2e
   - VPS snapshot: snap-20260415-192600
   - Status: Ready for update

3. **Monday Morning (or whenever ready):** Perform update
   ```bash
   sudo npm install -g openclaw@latest
   # or
   openclaw gateway update.run
   ```

4. **Immediately After Update:** Run healthcheck
   ```bash
   bash /data/.openclaw/workspace/scripts/post-update-healthcheck.sh
   ```

5. **Review Results:** Check for PASS/WARN/FAIL counts
   - All PASS: ✅ Proceed normally
   - Warnings: ⚠️ Review and monitor
   - Failures: ❌ Follow remediation steps

6. **Log Results:** Healthcheck auto-appends to `memory/projects/update-history.md`

---

## Emergency Rollback

### Scenario: Update Breaks Everything

**Option A: Rollback Workspace to Pre-Update State**

```bash
cd /data/.openclaw/workspace

# Find pre-update commit SHA in update-history.md
# Example: a7f3c2e

git reset --hard a7f3c2e
```

**What this does:**
- Reverts all workspace files (MEMORY.md, SOUL.md, crons, scripts, etc.)
- Does NOT change the OpenClaw version (still at latest)
- Allows you to recover config/memory if the update corrupted something

**Option B: Full Machine Rollback (Hostinger VPS Only)**

If VPS snapshot was created, restore the entire machine:
```bash
# Via Hostinger API or dashboard
# Restore from: snap-20260415-192600
# Time to restore: ~30 minutes
```

**What this does:**
- Reverts everything: OpenClaw version, Docker containers, workspace, all files
- Takes you back to pre-update state completely
- Fastest recovery for critical failures

---

## Preventive Measures

### Before Updating

1. **Review changelog** for breaking changes
   ```bash
   npm view openclaw version  # Check new version
   # Visit: https://github.com/openclaw/openclaw/releases/tag/v[NEW_VERSION]
   ```

2. **Check community reports** (OpenClaw Discord, r/openclaw)
   - Common failures in initial releases
   - Workarounds already documented

3. **Ensure backups are current**
   - Layer 2 GitHub backup runs daily (2 AM MDT)
   - Hostinger VPS snapshot runs daily (3 AM MDT)
   - Pre-update snapshot about to be created

4. **Plan update time**
   - Early in the week (allows time to discover issues)
   - Not during market hours (if trading crons are active)
   - When you can monitor for errors

### After Updating

1. **Run healthcheck immediately**
2. **Monitor crons for 24 hours**
   - Layer 0 runs every 15 minutes
   - Morning Briefing next day at 6 AM MDT
   - Watch for errors in logs
3. **Test critical workflows manually**
   - Cron execution (Layer 0, Job Hunter)
   - Memory reads/writes
   - Telegram delivery
   - Gmail operations

---

## Update History Tracking

All updates logged to `memory/projects/update-history.md`:

```markdown
## PRE-UPDATE SNAPSHOT — 2026-04-21-020000

**Current Version:** 2026.4.11
**Git Commit:** a7f3c2e
**VPS Snapshot:** snap-20260415-192600

**Timestamp:** 2026-04-15 02:00:00 UTC
**Status:** Ready for update

---

## POST-UPDATE HEALTHCHECK — 2026-04-21-093000

**Status:** ✅ HEALTHY
**PASS:** 21 | **WARN:** 0 | **FAIL:** 0

Log: /tmp/post-update-health-20260421-093000.log

✅ Update successful, no critical issues detected.

---
```

---

## Key Files

- **Pre-update script:** `/data/.openclaw/workspace/scripts/pre-update-snapshot.sh`
- **Post-update script:** `/data/.openclaw/workspace/scripts/post-update-healthcheck.sh`
- **Cron: Pre-update:** Job ID `8feacb87-709d-4e5f-977c-d58a258436ab`
- **Cron: Post-update:** Job ID `02228aef-7e81-483c-b705-25f8189f94fb`
- **Update history:** `memory/projects/update-history.md`
- **OpenClaw config:** `/data/.openclaw/openclaw.json`
- **Workspace backup:** `.git` (daily via Layer 2)

---

## Support

If update fails unexpectedly:

1. **Read the error:** Check gateway logs
   ```bash
   tail -f /data/.npm-global/lib/node_modules/openclaw/logs/gateway.log
   ```

2. **Run healthcheck** to identify which component broke
   ```bash
   bash /data/.openclaw/workspace/scripts/post-update-healthcheck.sh
   ```

3. **Follow remediation steps** output by healthcheck

4. **If still stuck:** Rollback to pre-update commit or VPS snapshot

---

**Last validated:** 2026-04-15  
**Next review:** After first production update
