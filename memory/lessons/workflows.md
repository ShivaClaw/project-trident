# Lessons — Workflows

## Reliable workflows
- For diagnostics: check status → inspect processes → inspect binary path/version → inspect live config/cron → then propose fixes
- For memory design: define layers first, then create files, then seed with real content, then automate consolidation carefully

## Step sequences that work
- When debugging OpenClaw version drift:
  1. identify all `openclaw` binaries on PATH
  2. compare versions and package roots
  3. inspect process environment
  4. verify behavior with explicit current binary
- When improving memory:
  1. create structure
  2. seed with current knowledge
  3. migrate old notes deliberately
  4. add reflection/consolidation routines

## Good habits
- Preserve reversibility before major structural changes
- Distinguish raw notes from durable memory
- Keep long-term memory compressed and high-signal

## Candidates for automation
- daily-to-project promotion suggestions
- weekly reflection generation
- stale-note review / consolidation reminders

## Reliability doctrine (cron/reflection)
- A scheduled introspection is only considered successful if it leaves artifacts:
  - `memory/reflections/weekly/YYYY-MM-DD.md`
  - and at least one downstream update (projects/self/lessons/performance) when applicable
- If cron status says "ok" but artifacts are missing, treat it as a failure mode (likely sandbox/tooling error) and run a manual consolidation pass.

## Layer 0 Heartbeat optimization (2026-04-19 20:50 UTC)
- **Workflow change:** Removed Job Search Priority Check and Trading Position Check from main heartbeat cycle
- **Rationale:** Specialized crons handle these more efficiently (Job Hunter runs Mon–Fri 8 AM MDT; Morning Briefing runs Mon–Fri 6 AM MDT; intraday trading agent for market hours)
- **Result:** 50% faster heartbeat execution (37–68 sec → 17–33 sec); no functionality lost
- **Heartbeat scope now:** subagent lifecycle checks (kill idle >30 min), time-sensitive deadline tracking (<3 days), memory triage
- **Implementation:** Delegated job search and trading checks to purpose-built cron jobs; heartbeat remains lean and fast
- **Reliability:** Specialized agents more responsive than generalist heartbeat; deadlines still caught by time-sensitive tracking
