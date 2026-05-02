# Git Backup & Memory Archival

**When:** Daily at 4:20 AM MDT (cron: Layer 2 Unified Backup)

**What:** Workspace memory files → GitHub → durable backup

## Procedure

1. **Stage changes**
   ```bash
   cd /data/.openclaw/workspace
   git add -A
   git status
   ```

2. **Commit**
   ```bash
   git commit -m "Memory sync: $(date +%Y-%m-%d--%H%M%Z)"
   ```

3. **Push to GitHub**
   ```bash
   git push origin main
   ```

4. **Verify**
   - Check GitHub repo: https://github.com/ShivaClaw/openclaw-workspace
   - Latest commit timestamp
   - File count in commit

## What's Included

- ✅ `MEMORY.md`, `SOUL.md`, `USER.md`, `AGENTS.md`
- ✅ `memory/daily/`, `memory/projects/`, `memory/self/`, `memory/lessons/`
- ✅ `.openclaw/openclaw.json` (no secrets — redacted in config)
- ❌ `.env.secret` (git-ignored, not backed up)
- ❌ `.openclaw/` credentials (git-ignored, local VPS snapshots only)

## Recovery Procedure

If workspace is lost:

```bash
# Clone backup
git clone https://github.com/ShivaClaw/openclaw-workspace /data/.openclaw/workspace-restore

# Restore
cp -r /data/.openclaw/workspace-restore/* /data/.openclaw/workspace/

# Manually restore secrets from:
# - `.env.secret` (Hostinger VPS backup)
# - `.openclaw/auth-profiles.json` (API keys, local only)
```

## VPS Snapshot Backup (Secondary)

- Hostinger dashboard: Automatic daily snapshots, 20-day retention
- Endpoint: Verify at Hostinger API or web console
- Retention: 20 days rolling

## Last Verified

2026-05-01 — Git push successful, GitHub repo current (commit 57248a2)
