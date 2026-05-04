# OpenClaw Update Protocol

## Operational Overview

**Frequency:** Weekly (Monday 4:28 PM EDT via cron)

**Objective:** Proactive update surveillance + compatibility analysis before deployment

**Budget:** <5 minutes

---

## Decision Tree

### Step 1: Version Check

```bash
npm list -g openclaw | grep openclaw    # Current
npm view openclaw version                # Latest
```

**Outcome:**
- ✅ Versions match → Exit with "No updates available" → Done
- ❌ Newer available → Continue to changelog

---

### Step 2: Fetch Release Information

**Primary source:** GitHub releases
```
https://github.com/openclaw/openclaw/releases/tag/v[LATEST_VERSION]
```

**Fallback:** npm metadata
```bash
npm view openclaw@[VERSION] --json
```

Extract:
- Release type (patch/minor/major)
- Breaking changes
- Known issues
- Security fixes/concerns

---

### Step 3: Community Intelligence

Run web search: `openclaw [VERSION] compatibility issues`

Check for:
- GitHub issues reported in past 7 days
- Reddit /r/openclaw reports
- Discord channel mentions of regressions
- User workflows affected

**Common patterns:**
- Main session crashes or instability
- Plugin/integration breakage
- Config incompatibilities
- Model-specific errors (DeepSeek, Claude, etc.)

---

### Step 4: Local Compatibility Assessment

| Dimension | Check | Status |
|-----------|-------|--------|
| **Config Schema** | Run `doctor` pre/post | Breaking changes? |
| **LCM (History)** | Check for state migration | Backward compatible? |
| **Plugins** | List active integrations | Any known breakage? |
| **Cron Tasks** | Verify execution syntax | Still valid? |
| **Docker** | Container/image updates | Rebuild needed? |
| **Critical Tools** | Gateway, browser, canvas | Functional? |

---

### Step 5: Classification

#### ✅ **Safe to Install (Patch)**
Criteria:
- Patch or minor version, no breaking changes
- No community reports of regressions
- No config schema changes
- All integrations compatible

**Action:** Proceed with installation + standard testing

---

#### ⚠️ **Potentially Breaking (Minor/Major)**
Criteria:
- Minor/major bump with possible conflicts
- Some community reports but not universal
- Config changes manageable
- Specific workflows affected

**Action:** Recommend user test in isolated session + provide rollback plan

---

#### 🔧 **Incompatible but Adaptable (Major)**
Criteria:
- Major breaking changes
- Multiple migrations needed
- Community migration guides available
- Workarounds exist

**Action:** Draft detailed migration steps + bespoke patches if needed

---

#### ❌ **Skip Entirely**
Criteria:
- Critical blockers (main session crashes, core functionality broken)
- No workarounds
- Community consensus: "wait for next patch"
- User workflow fundamentally incompatible

**Action:** Recommend deferral + watch for follow-up patch

---

## Recommendation Templates

### ✅ Safe Installation

```markdown
**Recommendation: INSTALL**

This is a routine patch fixing [specific issue]. No breaking changes, no config migration needed.

**Steps:**
1. npm install -g openclaw@[VERSION]
2. openclaw doctor (verify config)
3. openclaw gateway restart
4. Run quick test (spawn sub-agent, check LCM)

**Rollback (if issues):**
npm install -g openclaw@[OLD_VERSION]
```

---

### ⚠️ Test First, Then Install

```markdown
**Recommendation: TEST FIRST, THEN INSTALL**

This update includes [changes] that may affect [workflow]. Community reports [specific issues].

**Test plan (isolated):**
1. npm install -g openclaw@[VERSION]
2. openclaw doctor --fix (migrate config)
3. Spawn test sub-agent session
4. Verify [specific feature] works
5. Check [integration] functionality

**If stable:** Deploy to production
**If issues:** Rollback immediately

**Rollback command:**
npm install -g openclaw@[OLD_VERSION]
```

---

### 🔧 Bespoke Migration Required

```markdown
**Recommendation: REQUIRES MIGRATION**

This major update introduces [breaking changes]. However, migration is straightforward.

**Pre-flight:**
1. Backup: cp -r /data/.openclaw/workspace /data/.openclaw/workspace.backup
2. Review: [specific config changes]

**Migration steps:**
[Detailed step-by-step instructions]

**Validation:**
[How to verify migration succeeded]

**Rollback:**
rm -rf /data/.openclaw/workspace
mv /data/.openclaw/workspace.backup /data/.openclaw/workspace
npm install -g openclaw@[OLD_VERSION]
```

---

### ❌ Defer Update

```markdown
**Recommendation: DEFER**

Issue: [Critical blocker blocking user's primary workflow]

**Current version is stable.** This update introduces [regressions]:
- [Issue #XXXXX] - [specific problem affecting your workflow]
- [Issue #XXXXX] - [alternative problem]

**Recommendation:** Wait for v[NEXT_VERSION]+ before upgrading.

**If you need [feature in new version]:** I can backport or provide workaround.

**Monitoring:** I'll re-evaluate when v[NEXT_VERSION] releases.
```

---

## Delivery Protocol

1. **Analyze locally** (run all checks)
2. **Draft recommendation** (use appropriate template above)
3. **Send via WhatsApp** (full analysis + ready-to-run commands)
4. **Log to update-history.md** with decision + reasoning
5. **Do NOT auto-install** — always await explicit approval from user

---

## Logging Format

Each update check logged to `memory/projects/update-history.md`:

```markdown
## [DATE] — v[OLD] → v[NEW]
- **Type:** [patch/minor/major]
- **Decision:** [safe/breaking/hold/skip/bespoke]
- **Reasoning:** [1-2 sentence summary]
- **Action taken:** [what was delivered/recommended]
```

---

## Example: Full Workflow

**Scenario:** New version detected (v2026.5.2 → v2026.5.3)

```bash
# Step 1: Check versions
npm list -g openclaw           # v2026.5.2
npm view openclaw version      # v2026.5.3 ← newer

# Step 2: Fetch changelog
web_fetch https://github.com/openclaw/openclaw/releases/tag/v2026.5.3
# Result: "Security hotfix for plugin scanner"

# Step 3: Community intelligence
web_search "openclaw 2026.5.3 compatibility issues"
# Result: "Main session crash reported in issue #63612"

# Step 4: Local check
/data/.npm-global/bin/openclaw doctor
# Result: No pre-existing config issues

# Step 5: Classification
# → ⚠️ POTENTIALLY BREAKING (main session crash = blocker)

# Step 6: Recommendation
# → HOLD, wait for v2026.5.4

# Step 7: Log + deliver
# Send WhatsApp + update update-history.md
```

---

## Notes

- **Update window:** Fridays post-work are safest for testing
- **Automatic rollback:** Maintain last 2 versions of npm packages locally if possible
- **Critical path:** Any update affecting LCM, cron, or main session gets extra scrutiny
- **User approval:** Always explicit before installing to production

---

_Last updated: 2026-05-04_
_Frequency: Weekly check every Monday 4:28 PM EDT_
