#!/bin/bash
# Post-Update Healthcheck Script
# Purpose: Automated smoke tests after OpenClaw updates
# Triggered: Manually after update, or via post-update cron
# Output: Pass/Fail status, detailed diagnostics, remediation steps if needed

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
WORKSPACE="/data/.openclaw/workspace"
TIMESTAMP=$(date -u +"%Y-%m-%d %H:%M:%S UTC")
HEALTH_LOG="/tmp/post-update-health-$(date -u +%Y%m%d-%H%M%S).log"

# Test result counters
PASS=0
WARN=0
FAIL=0

echo -e "${BLUE}=== POST-UPDATE HEALTHCHECK ===${NC}" | tee "$HEALTH_LOG"
echo "Timestamp: $TIMESTAMP" | tee -a "$HEALTH_LOG"
echo "" | tee -a "$HEALTH_LOG"

# Helper function: test result
test_result() {
  local name=$1
  local status=$2
  local detail=$3
  
  if [ "$status" = "pass" ]; then
    echo -e "${GREEN}✅ PASS${NC} | $name" | tee -a "$HEALTH_LOG"
    ((PASS++))
  elif [ "$status" = "warn" ]; then
    echo -e "${YELLOW}⚠️  WARN${NC} | $name" | tee -a "$HEALTH_LOG"
    ((WARN++))
  else
    echo -e "${RED}❌ FAIL${NC} | $name" | tee -a "$HEALTH_LOG"
    ((FAIL++))
  fi
  
  if [ ! -z "$detail" ]; then
    echo "         $detail" | tee -a "$HEALTH_LOG"
  fi
}

# ============================================================================
# TEST SUITE
# ============================================================================

echo -e "${BLUE}[1/6] OpenClaw Gateway Status${NC}" | tee -a "$HEALTH_LOG"
echo "" | tee -a "$HEALTH_LOG"

# Test 1.1: Gateway process
if /data/.npm-global/bin/openclaw status > /tmp/openclaw-status.txt 2>&1; then
  GATEWAY_VERSION=$(grep -i "version" /tmp/openclaw-status.txt | head -1 | awk '{print $NF}')
  test_result "Gateway process" "pass" "Version: $GATEWAY_VERSION"
else
  test_result "Gateway process" "fail" "openclaw status failed"
fi

# Test 1.2: Gateway port responsive
if timeout 5 bash -c "echo > /dev/tcp/127.0.0.1/18789" 2>/dev/null; then
  test_result "Gateway port 18789" "pass" "Listening"
else
  test_result "Gateway port 18789" "fail" "Not responding"
fi

echo "" | tee -a "$HEALTH_LOG"
echo -e "${BLUE}[2/6] Memory Architecture${NC}" | tee -a "$HEALTH_LOG"
echo "" | tee -a "$HEALTH_LOG"

# Test 2.1: Layer 0 files exist
if [ -f "$WORKSPACE/scripts/layer0-agent-prompt-template.md" ]; then
  test_result "Layer 0 prompt template" "pass" "Found"
else
  test_result "Layer 0 prompt template" "fail" "Missing"
fi

# Test 2.2: Layer 1 memory structure
MEMORY_FILES=("$WORKSPACE/SOUL.md" "$WORKSPACE/USER.md" "$WORKSPACE/MEMORY.md" "$WORKSPACE/HEARTBEAT.md")
MISSING=0
for f in "${MEMORY_FILES[@]}"; do
  [ ! -f "$f" ] && ((MISSING++))
done

if [ $MISSING -eq 0 ]; then
  test_result "Layer 1 memory files (4)" "pass" "All present"
else
  test_result "Layer 1 memory files" "warn" "$MISSING missing"
fi

# Test 2.3: Layer 1.5 semantic storage
if [ -d "$WORKSPACE/memory/layer0.5" ]; then
  CONTEXT_FILES=$(find "$WORKSPACE/memory/layer0.5" -name "context-injection-*.json" 2>/dev/null | wc -l)
  test_result "Layer 0.5 semantic context" "pass" "$CONTEXT_FILES context files"
else
  test_result "Layer 0.5 semantic context" "warn" "Directory missing"
fi

# Test 2.4: LCM database
if [ -f "$WORKSPACE/.openclaw/lossless-claw.db" ]; then
  DB_SIZE=$(du -h "$WORKSPACE/.openclaw/lossless-claw.db" | awk '{print $1}')
  test_result "LCM plugin database" "pass" "Size: $DB_SIZE"
else
  test_result "LCM plugin database" "warn" "Database file not found"
fi

echo "" | tee -a "$HEALTH_LOG"
echo -e "${BLUE}[3/6] Plugins & Skills${NC}" | tee -a "$HEALTH_LOG"
echo "" | tee -a "$HEALTH_LOG"

# Test 3.1: Plugin list
if /data/.npm-global/bin/openclaw skills list > /tmp/skills-list.txt 2>&1; then
  SKILL_COUNT=$(wc -l < /tmp/skills-list.txt)
  test_result "Skills installation" "pass" "$SKILL_COUNT skills found"
else
  test_result "Skills installation" "fail" "Could not list skills"
fi

# Test 3.2: Key plugins loaded
REQUIRED_PLUGINS=("lossless-claw" "telegram" "whatsapp")
for plugin in "${REQUIRED_PLUGINS[@]}"; do
  if grep -q "$plugin" /tmp/openclaw-status.txt 2>/dev/null; then
    test_result "Plugin: $plugin" "pass" "Loaded"
  else
    test_result "Plugin: $plugin" "warn" "Not found in status"
  fi
done

echo "" | tee -a "$HEALTH_LOG"
echo -e "${BLUE}[4/6] Cron Infrastructure${NC}" | tee -a "$HEALTH_LOG"
echo "" | tee -a "$HEALTH_LOG"

# Test 4.1: Cron list
if /data/.npm-global/bin/openclaw cron list > /tmp/cron-list.txt 2>&1; then
  CRON_COUNT=$(grep -c '"name"' /tmp/cron-list.txt 2>/dev/null || echo "0")
  test_result "Cron system" "pass" "$CRON_COUNT jobs registered"
else
  test_result "Cron system" "fail" "Could not list crons"
fi

# Test 4.2: Key crons enabled
REQUIRED_CRONS=("Layer 0" "Morning Briefing" "Job Hunter" "Social Media")
for cron_name in "${REQUIRED_CRONS[@]}"; do
  if grep -q "$cron_name" /tmp/cron-list.txt 2>/dev/null; then
    test_result "Cron: $cron_name" "pass" "Found"
  else
    test_result "Cron: $cron_name" "warn" "Not found"
  fi
done

echo "" | tee -a "$HEALTH_LOG"
echo -e "${BLUE}[5/6] Config Schema Validation${NC}" | tee -a "$HEALTH_LOG"
echo "" | tee -a "$HEALTH_LOG"

# Test 5.1: Gateway config readable
if [ -f /data/.openclaw/openclaw.json ]; then
  if python3 -m json.tool < /data/.openclaw/openclaw.json > /dev/null 2>&1; then
    test_result "Config JSON validity" "pass" "Valid JSON"
  else
    test_result "Config JSON validity" "fail" "Malformed JSON"
  fi
else
  test_result "Config file exists" "fail" "openclaw.json not found"
fi

# Test 5.2: Channel configuration
CHANNELS_ENABLED=$(grep -o '"enabled": true' /data/.openclaw/openclaw.json 2>/dev/null | wc -l)
test_result "Active channels" "pass" "$CHANNELS_ENABLED channels enabled"

echo "" | tee -a "$HEALTH_LOG"
echo -e "${BLUE}[6/6] Workspace Integrity${NC}" | tee -a "$HEALTH_LOG"
echo "" | tee -a "$HEALTH_LOG"

# Test 6.1: Git status
cd "$WORKSPACE"
if git status > /dev/null 2>&1; then
  GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
  test_result "Git repository" "pass" "Branch: $GIT_BRANCH"
else
  test_result "Git repository" "fail" "Not a git repo"
fi

# Test 6.2: Backup locations exist
BACKUP_DIRS=(".git" "memory/daily" "memory/projects" "memory/self" "scripts")
MISSING_DIRS=0
for dir in "${BACKUP_DIRS[@]}"; do
  [ ! -d "$WORKSPACE/$dir" ] && ((MISSING_DIRS++))
done

if [ $MISSING_DIRS -eq 0 ]; then
  test_result "Backup directories" "pass" "All present"
else
  test_result "Backup directories" "warn" "$MISSING_DIRS missing"
fi

# Test 6.3: Permissions check
if [ -x "$WORKSPACE/scripts/pre-update-snapshot.sh" ] && [ -x "$WORKSPACE/scripts/post-update-healthcheck.sh" ]; then
  test_result "Script permissions" "pass" "Executable"
else
  test_result "Script permissions" "warn" "Some scripts not executable"
fi

# ============================================================================
# SUMMARY
# ============================================================================

echo "" | tee -a "$HEALTH_LOG"
echo -e "${BLUE}=== SUMMARY ===${NC}" | tee -a "$HEALTH_LOG"
echo "PASS:  $PASS" | tee -a "$HEALTH_LOG"
echo "WARN:  $WARN" | tee -a "$HEALTH_LOG"
echo "FAIL:  $FAIL" | tee -a "$HEALTH_LOG"

# Determine overall status
if [ $FAIL -eq 0 ]; then
  if [ $WARN -eq 0 ]; then
    STATUS="✅ HEALTHY"
    STATUS_CODE=0
  else
    STATUS="⚠️  DEGRADED (warnings only)"
    STATUS_CODE=1
  fi
else
  STATUS="❌ UNHEALTHY (failures detected)"
  STATUS_CODE=2
fi

echo ""
echo -e "${GREEN}Overall Status: $STATUS${NC}" | tee -a "$HEALTH_LOG"
echo "Log saved: $HEALTH_LOG" | tee -a "$HEALTH_LOG"

# ============================================================================
# REMEDIATION GUIDANCE
# ============================================================================

if [ $FAIL -gt 0 ] || [ $WARN -gt 0 ]; then
  echo ""
  echo -e "${YELLOW}=== REMEDIATION GUIDANCE ===${NC}" | tee -a "$HEALTH_LOG"
  echo "" | tee -a "$HEALTH_LOG"
  
  if grep -q "Gateway process.*fail" "$HEALTH_LOG"; then
    echo "Gateway Process Failed:" | tee -a "$HEALTH_LOG"
    echo "  1. Check logs: tail -f /data/.npm-global/lib/node_modules/openclaw/logs/gateway.log" | tee -a "$HEALTH_LOG"
    echo "  2. Restart: openclaw gateway restart" | tee -a "$HEALTH_LOG"
    echo "  3. If still failing: Rollback git commit or VPS snapshot" | tee -a "$HEALTH_LOG"
    echo "" | tee -a "$HEALTH_LOG"
  fi
  
  if grep -q "config.*fail" "$HEALTH_LOG"; then
    echo "Config Integrity Failed:" | tee -a "$HEALTH_LOG"
    echo "  1. Backup: cp /data/.openclaw/openclaw.json /tmp/openclaw.json.bak" | tee -a "$HEALTH_LOG"
    echo "  2. Validate: python3 -m json.tool < /data/.openclaw/openclaw.json" | tee -a "$HEALTH_LOG"
    echo "  3. If malformed: git checkout HEAD -- /data/.openclaw/openclaw.json" | tee -a "$HEALTH_LOG"
    echo "" | tee -a "$HEALTH_LOG"
  fi
  
  if grep -q "Plugin.*fail" "$HEALTH_LOG" || grep -q "Skills.*fail" "$HEALTH_LOG"; then
    echo "Plugin/Skills Issue:" | tee -a "$HEALTH_LOG"
    echo "  1. Reinstall plugins: openclaw gateway restart" | tee -a "$HEALTH_LOG"
    echo "  2. Check plugin hashes: git status .openclaw/plugins/" | tee -a "$HEALTH_LOG"
    echo "  3. If corrupted: git checkout HEAD -- .openclaw/plugins/" | tee -a "$HEALTH_LOG"
    echo "" | tee -a "$HEALTH_LOG"
  fi
fi

# ============================================================================
# LOG TO UPDATE HISTORY
# ============================================================================

cat >> "$WORKSPACE/memory/projects/update-history.md" << EOF

## POST-UPDATE HEALTHCHECK — $TIMESTAMP

**Status:** $STATUS
**PASS:** $PASS | **WARN:** $WARN | **FAIL:** $FAIL

Log: $HEALTH_LOG

$([ $FAIL -eq 0 ] && echo "✅ Update successful, no critical issues detected." || echo "❌ Update completed with failures. See log for remediation.")

---
EOF

exit $STATUS_CODE
