# Heartbeat Protocol Instructions

**Source:** User instruction from message 17712 (2026-04-24 04:52 EDT)

**Instructions:**
- Read HEARTBEAT.md if it exists (workspace context). Follow it strictly.
- Do not infer or repeat old tasks from prior chats.
- If nothing needs attention, reply HEARTBEAT_OK.

---

## Current Implementation [2026-04-25]

**Layer 0 Heartbeat-Integrated (Cron: every 15 minutes)**
- **Model:** claude-haiku-4-5 (cost-optimized)
- **Scope:** Simplified as of 2026-04-19
  - Section A: Subagent lifecycle (kill idle >30 min), time-sensitive deadline tracking (<3 days)
  - Section B: Memory triage (LCM scan, classify, route to appropriate memory files)
- **Execution time:** 17–33 seconds (improved from 37–68 sec post-optimization)
- **Cycle count:** 66 runs since 2026-04-19; all nominal
- **Artifacts:** Daily log updates (`memory/daily/YYYY-MM-DD.md`), state tracking (`memory/layer0/last-run.md`)

**Delegated workstreams (not in heartbeat):**
- Job Search Priority: Mon–Fri 8 AM MDT (specialized Job Hunter agent)
- Trading Position Checks: Weekday 6–16 MDT (intraday trading agent; skips weekends)
- Morning Briefing: Mon–Fri 6 AM MDT (synthesis agent; rate-limited by API availability)

---

**Note:** This file will be updated with additional heartbeat-related instructions or best practices as they emerge.
