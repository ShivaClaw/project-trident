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
