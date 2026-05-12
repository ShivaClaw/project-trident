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

## Infrastructure migration workflow (2026-05-11)
- When a critical service fails (VPS Ollama): decide immediately whether to recover or abandon
- If abandoning: (1) identify all references in config/cron/memory, (2) update endpoints in memory files, (3) disable unused cron jobs, (4) verify connectivity on new endpoint, (5) create summary artifact
- Key: execute atomically across all systems (cron + memory + config) to avoid stale references
- Outcome: VPS Ollama → ThinkCentre migration, $30/mo savings, improved reliability (GPU), same inference API

## Reliability doctrine (cron/reflection)
- A scheduled introspection is only considered successful if it leaves artifacts:
  - `memory/reflections/weekly/YYYY-MM-DD.md`
  - and at least one downstream update (projects/self/lessons/performance) when applicable
- If cron status says "ok" but artifacts are missing, treat it as a failure mode (likely sandbox/tooling error) and run a manual consolidation pass.

## HEARTBEAT.md scope protocol (2026-05-11)
- **Protocol:** G issued explicit instruction to "Follow HEARTBEAT.md strictly."
- **Documented scope (3 sections):** (1) Standing check—flag job search blocking items; (2) Trading check (6 AM–4 PM MDT weekdays); (3) Heartbeat signals—detect and stash.
- **Anti-pattern:** Over-relaying infrastructure status (VPS Ollama routing, Coordinator state, LoClaw pairing) on every heartbeat, even when unchanged. Violates documented scope.
- **Fix:** Agent deferred repeated unchanged-status relays starting 17:09 EDT (May 11). Infrastructure monitoring remains in Layer 0 heartbeat checks (SECTION A.3), but infrastructure-only status relays (without job search or signal context) no longer propagate to daily log.
- **Key lesson:** When user specifies scope boundaries, honor them strictly. Inference about "what should be included" is subordinate to explicit instruction. This is a voice/integrity principle.

## Cron instruction-cycling conflict (2026-05-11 @ 19:39 EDT)
- **Root cause:** jobs.json configured with 13 jobs firing every 5 minutes, tagged HEARTBEAT but executing outside documented HEARTBEAT.md scope (repeatedly requesting infrastructure status relay)
- **Conflict:** Agent correctly deferred relays to comply with user directive; cron system continues cycling identical requests, contradicting explicit "follow HEARTBEAT.md strictly" instruction
- **Escalation:** Agent escalated at 2026-05-11T23:39Z (19:39 EDT) requesting explicit user instruction to either (A) update HEARTBEAT.md to include infrastructure monitoring, or (B) send direct override to resume relay
- **Status (as of 19:49 EDT):** User response pending; cron continues cycling at identical intervals with unresolved instruction conflict
- **Resolution required:** Explicit user decision on protocol scope — either expand HEARTBEAT.md or disable infrastructure monitoring from heartbeat cycle
