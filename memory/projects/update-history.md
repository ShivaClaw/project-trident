# OpenClaw Update History

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
