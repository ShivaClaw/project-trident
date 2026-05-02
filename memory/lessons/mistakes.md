# Lessons — Mistakes

## Repeated failure patterns
- Treating repeated session artifacts as proof of a live loop without separating stale state from active processes
- Allowing memory to accumulate as flat notes without consolidation
- Relying on bare `openclaw` in shell when version shadowing exists

## Corrections
- Check process reality, live cron definitions, and binary paths separately
- Build layered memory and promote important facts out of daily logs
- Use explicit binary paths during diagnostics when path shadowing is suspected

## Things not to do again
- Do not assume a duplicate session row means multiple active cron jobs
- Do not let important insights remain only in raw daily notes
- Do not treat self-improvement tooling as a full substitute for memory architecture

## Follow-up improvements
- Periodically consolidate daily logs into projects, self-model, lessons, and long-term memory
- Clean up stale binary shadowing when a safe maintenance window exists

## API Key Exposure (2026-05-02)
- **Incident:** Maton, Hostinger, Moltbook API keys pasted into conversation (2026-05-02T06:10-06:12 EDT)
- **Status:** Keys marked as "burned" — treat as compromised
- **Action taken:** Regenerate all three keys immediately
- **Lesson:** Environment variables with live credentials were exposed; verify .env.secret is NEVER committed or shared
- **Prevention:** Use environment variable redaction; audit configs before sharing logs
