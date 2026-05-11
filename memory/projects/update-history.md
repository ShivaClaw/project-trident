# OpenClaw Update History

## 2026-05-11 — v2026.4.24 → v2026.5.7

- **Type:** minor (one-month rollup)
- **Decision:** ⚠️ **TEST FIRST, THEN INSTALL** — Potentially breaking with community stability concerns
- **Reasoning:** 
  - 28+ fixes across plugin publishing, auth hardening, session management, Discord voice
  - CLI schema changes: cron list/show JSON output now includes `status` field (affects external tools)
  - Authorization tightening: stricter owner enforcement, Active Memory requires admin scope
  - Session cache invalidation behavior changes impact long-lived sessions
  - Community reports: WhatsApp routing broken for some 2026.4.x upgraders; isolated cron timeout issues
  - Local config: ✅ clean, no pre-existing blockers
  
- **Action taken:** 
  - Full analysis delivered to user
  - Recommendation: Test in isolated session first (3 min), then install if stable
  - Ready-to-run test commands + rollback plan provided
  - Awaiting user approval to proceed with testing

---

## 2026-05-04 — v2026.4.24 → v2026.5.3-1

- **Type:** patch/hotfix (minor)
- **Decision:** ⚠️ **HOLD** — Potentially breaking, not production-ready
- **Reasoning:** 
  - Critical issue #63612: main session prompt crash during long sessions (blocks primary workflow)
  - DeepSeek V4 Pro regression in 2026.5.3-1 ("Invalid option" error)
  - Discord plugin manifest broken
  - Benefits (security scanner fix, doctor --fix) are marginal vs. stability risk
  - Community reports indicate beta quality, not production-stable
  
- **Action taken:** 
  - Analysis delivered to user
  - Recommendation: wait for v2026.5.4+
  - Test instructions + rollback plan provided if user opts to test
  - Current version (2026.4.24) is stable for user's workload

---

## Template for Future Updates
```
## [DATE] — v[OLD] → v[NEW]
- **Type:** [patch/minor/major]
- **Decision:** [safe/breaking/hold/skip/bespoke]
- **Reasoning:** [1-2 sentence technical summary]
- **Action taken:** [what was recommended/done]
```
