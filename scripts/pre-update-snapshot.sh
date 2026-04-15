#!/bin/bash
# Pre-Update Snapshot Script
# Purpose: Create versioned git commit + optional VPS snapshot before OpenClaw updates
# Triggered: Before manual update or via scheduled cron (Sun 2:00 AM MDT)
# Output: Commit SHA, snapshot ID, timestamp to update-history.md

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
WORKSPACE="/data/.openclaw/workspace"
TIMESTAMP=$(date -u +"%Y-%m-%d %H:%M:%S UTC")
TIMESTAMP_FS=$(date -u +"%Y-%m-%d-%H%M%S")
GIT_SSH_CMD="ssh -F ${WORKSPACE}/.ssh/config"

# Current OpenClaw version
CURRENT_VERSION=$(/data/.npm-global/bin/openclaw status 2>/dev/null | grep -i "version" | head -1 | awk '{print $NF}' || echo "unknown")

echo -e "${GREEN}=== PRE-UPDATE SNAPSHOT WORKFLOW ===${NC}"
echo "Timestamp: $TIMESTAMP"
echo "Current version: $CURRENT_VERSION"
echo ""

# STEP 1: Git snapshot
echo -e "${YELLOW}[1/3] Creating git commit snapshot...${NC}"
cd "$WORKSPACE"

# Add all memory, config, and tool files
git add \
  AGENTS.md SOUL.md TOOLS.md USER.md HEARTBEAT.md IDENTITY.md MEMORY.md \
  memory/ \
  scripts/ \
  .gitignore \
  2>/dev/null || true

# Check if there are changes
if git diff --cached --quiet; then
  echo -e "${YELLOW}  ℹ️  No changes to commit (clean workspace)${NC}"
  GIT_COMMIT="none"
else
  CHANGED=$(git diff --cached --stat | tail -1 | awk '{print $NF}')
  git commit -m "snapshot(pre-update): v${CURRENT_VERSION} baseline — ${TIMESTAMP_FS}"
  GIT_COMMIT=$(git rev-parse HEAD | cut -c1-7)
  echo -e "${GREEN}  ✅ Committed: ${GIT_COMMIT}${NC}"
  echo "     Changes: $CHANGED"
fi

# STEP 2: Optional VPS snapshot (only if on Hostinger VPS)
echo ""
echo -e "${YELLOW}[2/3] VPS snapshot (optional, Hostinger only)...${NC}"

HOSTINGER_API_TOKEN=$(cat /data/.openclaw/workspace/memory/infra/HOSTINGER_CREDENTIALS.enc 2>/dev/null || echo "")

if [ -z "$HOSTINGER_API_TOKEN" ]; then
  echo -e "${YELLOW}  ℹ️  No Hostinger credentials found (skipping VPS snapshot)${NC}"
  VPS_SNAPSHOT="skipped"
else
  echo "  Initiating snapshot on srv1489775..."
  
  SNAPSHOT_RESPONSE=$(curl -s -X POST \
    "https://developers.hostinger.com/api/vps/v1/virtual-machines/1489775/snapshot" \
    -H "Authorization: Bearer ${HOSTINGER_API_TOKEN}" \
    -H "Content-Type: application/json" \
    2>&1)
  
  if echo "$SNAPSHOT_RESPONSE" | grep -q '"id"'; then
    VPS_SNAPSHOT=$(echo "$SNAPSHOT_RESPONSE" | grep -o '"id":"[^"]*"' | cut -d'"' -f4 | head -1)
    echo -e "${GREEN}  ✅ Snapshot created: ${VPS_SNAPSHOT}${NC}"
  else
    echo -e "${RED}  ⚠️  Snapshot failed: $(echo "$SNAPSHOT_RESPONSE" | head -1)${NC}"
    VPS_SNAPSHOT="failed"
  fi
fi

# STEP 3: Log to update-history.md
echo ""
echo -e "${YELLOW}[3/3] Logging snapshot details...${NC}"

HISTORY_FILE="$WORKSPACE/memory/projects/update-history.md"
mkdir -p "$(dirname "$HISTORY_FILE")"

# Append to update-history.md
cat >> "$HISTORY_FILE" << EOF

## PRE-UPDATE SNAPSHOT — $TIMESTAMP_FS

**Current Version:** $CURRENT_VERSION
**Git Commit:** $GIT_COMMIT
**VPS Snapshot:** $VPS_SNAPSHOT

**Timestamp:** $TIMESTAMP
**Status:** Ready for update

---
EOF

echo -e "${GREEN}  ✅ Logged to update-history.md${NC}"

# STEP 4: Print summary
echo ""
echo -e "${GREEN}=== SNAPSHOT COMPLETE ===${NC}"
echo "Git commit:    $GIT_COMMIT"
echo "VPS snapshot:  $VPS_SNAPSHOT"
echo "Ready for:     \`openclaw update\` or \`gateway update.run\`"
echo "Rollback:      \`git reset --hard $GIT_COMMIT\` (local only)"
echo ""
echo "Pre-update baseline saved. Proceed with update when ready."
