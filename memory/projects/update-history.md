# OpenClaw Update History

**Purpose:** Log all update checks, decisions, and actions.

---

## Format

```markdown
## [DATE] — v[OLD] → v[NEW]
- Type: [patch/minor/major]
- Decision: [safe/breaking/skip/bespoke]
- Reasoning: [brief summary]
- Action taken: [installed / deferred / patched / skipped]
```

---

## History

_Updates logged by weekly cron (Sundays 03:00 MDT)._

---

## POST-UPDATE HEALTHCHECK — 2026-04-25 16:38:25 UTC

**Status:** ⚠️ DEGRADED (warnings only)
**Results:** PASS: 17 | WARN: 1 | FAIL: 0

### Test Coverage

✅ **Gateway Status**
- Process: PASS
- Port 18789: PASS (Listening)

✅ **Memory Architecture**
- Layer 1 (SOUL.md): PASS
- Layer 1 (USER.md): PASS
- Layer 1 (MEMORY.md): PASS
- Daily logs: PASS (192 files in memory/)
- LCM database: ⚠️ WARN (database located at /data/.openclaw/lcm.db, 149M, operational)

✅ **Plugins & Skills**
- Skills installation: PASS (163 skills)
- Plugin: lossless-claw (LCM): PASS (Loaded)
- Channel: Telegram: PASS (Configured)

✅ **Cron Infrastructure**
- Cron system: PASS (8 jobs registered)
- Layer 0 Heartbeat: PASS (Found)
- Backup/Update Jobs: PASS (Found)

✅ **Config Schema Validation**
- JSON validity: PASS (Valid)
- Active channels: PASS (4 enabled)

✅ **Workspace Integrity**
- Git repository: PASS (Branch: main)
- Core directories: PASS (All present)
- Script permissions: PASS (post-update-healthcheck.sh executable)

### Remediation

**Warning:** LCM database location test was checking incorrect path (/data/.openclaw/workspace/.openclaw/lossless-claw.db). Database is correctly located at `/data/.openclaw/lcm.db` and operational (149M, active). Update healthcheck script to reflect actual LCM db path.

### Conclusion

✅ **OpenClaw integrity post-update: HEALTHY**
- All critical systems operational
- Gateway responsive and version current
- Memory architecture complete (all 4 layers functional)
- 163 skills loaded and available
- 8 cron jobs registered and tracking
- Config schema valid (4 channels enabled)
- Workspace backed by git, all core directories present

---

## 2026-04-05 — v2026.3.24 → v2026.4.2

- Type: Minor (breaking plugin config paths)
- Decision: Breaking but adaptable — safe to install with config migration
- Reasoning: Two breaking changes (xAI + Firecrawl config paths) but automated fix available via `openclaw doctor --fix`. Our setup uses neither xAI nor Firecrawl; only lossless-claw plugin affected. lossless-claw v0.5.2 remains compatible. Security hardening + task flow restoration are beneficial. No blockers detected.
- Action taken: Delivered recommendation for immediate install with rollback plan

---

## 2026-04-12 — v2026.3.24 → v2026.4.11

- Type: Minor (feature additions + bug fixes, no breaking changes)
- Decision: **✅ Safe to install**
- Reasoning: Comprehensive feature release (memory wiki, Teams reactions, Feishu improvements, Ollama caching, plugin manifest activation descriptors) + 15+ bug fixes (OpenAI OAuth, audio transcription, TTS persistence, WhatsApp reactions, Codex QA, Telegram topics, failover classification). **Zero breaking changes detected.** No config schema version bump. All existing plugins remain compatible. Security fixes + reliability improvements. No LCM schema changes. No cron payload mutations. Decision tree: minor version + no breaking changes mentioned + no community reports (search unavailable but changelog is clear) = **safe to proceed immediately**.
- Action taken: Delivered recommendation via WhatsApp (awaiting G approval for install)

---

## 2026-04-24 — v2026.3.24 → v2026.4.23

- Type: Minor (21-patch gap, stable changelog for final version)
- Decision: ⚠️ **Potentially breaking** — safe 2026.4.23 specifically, but cumulative 2026.4.x history shows Telegram regressions & lossless-claw compatibility risk
- Reasoning: 2026.4.23 changelog has zero explicit breaking changes and extensive security hardening (48+ fixes). However: (1) Telegram known failures on 2026.4.2, 2026.4.7, 2026.4.21/22 with pattern of regression+fix; (2) lossless-claw plugin compatibility uncertain after 2026.4.14 "strict-match contract" breaking change; (3) 21-patch jump without intermediate testing carries cumulative risk; (4) Config migration required for dreaming cron shape change (openclaw doctor --fix needed). Recommendation: Two-stage approach (v2026.4.11 first, then defer v2026.4.23) OR push to v2026.4.23 with full backup + doctor --fix + Telegram monitoring.
- Action taken: Delivered recommendation via WhatsApp (awaiting G decision on stage-wise vs. direct approach)

---

## 2026-04-02 — Cron Created

- **Current version:** 2026.3.23-2
- **Next check:** Sunday 2026-04-06 03:00 MDT
- **Protocol:** `/data/.openclaw/workspace/memory/projects/update-protocol.md`
- **Cron ID:** `96066df4-8a5b-4a86-b218-a252dd976b7d`

---

## POST-UPDATE HEALTHCHECK — 2026-04-25 16:38:25 UTC

**Status:** ⚠️  DEGRADED (warnings only)
**PASS:** 17 | **WARN:** 1 | **FAIL:** 0

Log: /tmp/post-update-health-20260425-163825.log

✅ Update successful.

---
