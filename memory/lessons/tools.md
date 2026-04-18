# Lessons — Tools

## Secrets hygiene
- Never write API keys/tokens into memory logs or reflections. If a key appears in a note, redact it immediately.

## Tool quirks
- `openclaw` may resolve to a stale binary if invoked via `/usr/local/bin/openclaw`; prefer `/data/.npm-global/bin/openclaw` for shell diagnostics until cleanup is done
- Config changes via gateway patch trigger restart automatically
- Memory search is useful, but retrieval quality depends on how well files are structured and maintained

## Reliable usage patterns
- Use explicit binary paths when diagnosing version/path conflicts
- Use cron JSON/list output to inspect live job definitions rather than inferring from session artifacts
- Use layered files for memory rather than overloading `MEMORY.md`
- LCM tools (lcm_grep, lcm_describe) require conversationId or allConversations=true; context-less calls fail silently

## Friction points
- Old and new OpenClaw installs can coexist and create misleading diagnostics
- Session history can make duplicate cron runs look more pathological than they are
- Schema lookup may be shallow or unhelpful for some config paths
- **[2026-04-17 16:02] clawhub code plugins require `package.json`** at root with correct metadata. Without it, clawhub refuses registration. Error: "no package.json found".
- **[2026-04-17 16:00] GitHub token format:** clawhub/gh CLI requires Personal Access Token (PAT) starting with `ghp_`. Tokens in other formats (e.g., legacy tokens) are rejected silently during repo creation.

## Notes to remember
- Distinguish gateway health from CLI shadowing
- Prefer non-destructive environmental diagnosis before changing binaries
- OpenRouter API key must be lowercase: `sk-or-v1-...` (not `Sk-or-v1-...`)
- Mistral Small 3.2 correct model ID on OR: `mistralai/mistral-small-3.2-24b-instruct`
- Free-tier OR models (step-3.5-flash:free) go rate-limited without warning — unreliable as last resort
- gpt-5.2 requires `max_completion_tokens` not `max_tokens`
- `gog gmail` can fail with `invalid_grant` when Google OAuth tokens expire/revoke; fix by re-authing the account (refresh token) before relying on cron automation
- **[2026-04-02] Gmail OAuth token for `gog` currently revoked/expired.** Career-transition.md fixed: now documents BLOCKED monitoring and urgent migration to `himalaya` IMAP before April 7 outreach. Status now synchronized across logs, project, tools, and Layer 0.
- **[2026-04-02 21:29 UTC] OAuth token failure repeated.** Heartbeat logs consistent revocation issue. Status: awaiting re-auth via Maton oauth-gateway or alternative (himalaya IMAP).
- **[2026-04-03] Layer 0 timezone issue.** Alert fired due to timezone mismatch (UTC vs MDT). Heartbeat is correctly reading MDT times but Layer 0 cron had UTC logic. Fix: ensure all deadline checks normalize to G's timezone (MDT) before comparison.
- **[2026-04-12 18:30 EDT] himalaya IMAP migration successful.** Gmail OAuth revocation resolved by migrating email monitoring to himalaya CLI (IMAP/SMTP). Career transition pipeline UNBLOCKED. Batch 2 scheduling operational as of 2026-04-13 21:31 MDT.
- **[2026-04-18 00:28 UTC] Dolphin3 model integration tested.** Ollama HTTP API call to `dolphin3` model successful. Used for drafting Moltbook comments. Model accessible via `http://ollama:11434/api/generate` endpoint. Tested multi-turn generation (8 comment drafts + lobster math puzzle solving).
