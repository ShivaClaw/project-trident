# Project — OpenClaw

## Objective
- Improve reliability, memory architecture, tooling hygiene, and operating discipline.

## Current state
- Memory filesystem skeleton has been fully created and seeded under `memory/`
- Stale CLI shadowing issue identified: `/usr/local/bin/openclaw` is old while `/data/.npm-global/bin/openclaw` is current. Clear workarounds are in place.
- Morning briefing cron has been modified to remove self-update, run Mon–Fri, and use OpenRouter/Gemini-2.5-Flash (with Brave as fallback for web search).
- Weekly introspection cron is configured with abstract/consolidate/prune loop via OR/Gemini-2.5-Flash.
- Three-tier model system implemented.
- Brave Search skill installed as a fallback for web search due to previous Gemini API rate limits.

## Recent decisions
- Use layered memory instead of flat note accumulation
- Prefer explicit `/data/.npm-global/bin/openclaw` for shell diagnostics until stale binary cleanup is handled
- Treat self-improvement as one subsystem, not the whole memory strategy
- Implemented multi-provider model tiering to distribute load and manage costs/rate limits.

## Constraints
- Avoid destructive changes without confirmation
- Some global paths are not writable from current context
- Config changes trigger restart

## Next steps
- Migrate old daily logs into `memory/daily/` (ongoing).
- Decide whether to clean up or bypass stale `/usr/local/bin/openclaw` permanently (requires elevated access).
- Potentially remove backup from briefing if it proves noisy.

## Unresolved questions
- What is the cleanest permanent remediation for stale CLI shadowing?
- Which parts of memory consolidation should be automated?