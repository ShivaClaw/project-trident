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

## Friction points
- Old and new OpenClaw installs can coexist and create misleading diagnostics
- Session history can make duplicate cron runs look more pathological than they are
- Schema lookup may be shallow or unhelpful for some config paths
- ED25519 SSH keys can fail on VPS external IPs due to Docker network isolation or sshd config mismatch, but password auth via sshpass is reliable [2026-04-30]

## SSH Credential Management
- **Pattern that works:** Password authentication via sshpass on VPS external IP
  - `sshpass -p '<password>' ssh ...` connects reliably (<1s)
  - ED25519 key auth fails on 72.60.119.23 (Docker network isolation?)
  - Plaintext password risk: mitigate by storing in .env.secret (git-ignored) [2026-04-30]
- **Better approach (deferred):** Manually add SSH public key to VPS after container deployment stabilizes

## Ollama Model Management
- **Qwen3.5:9b Deletion (2026-04-30):** G deprecated qwen3.5:9b as fallback model; focused stack on Qwen 2.5 7B primary
  - Workflow: `ollama rm qwen3.5:9b` on Docker container via sshpass
  - Removed all references from: gateway config (openclaw.json), Nirvana plugin (router.js), infrastructure notes
  - Simplified fallback chain: Qwen 2.5 7B → Claude Haiku 4.5 → Gemini 2.5 Flash → Grok 3
  - Gateway config hot-reload via SIGUSR1 ensures instant effect
  - Lesson: Config changes require searching all dependent files; grep + edit workflow effective

## Gateway & Traefik Routing
- **Gateway connectivity OK locally** (localhost:65007 returns 200, OpenClaw dashboard HTML) [2026-04-30]
- **Traefik routing issue:** gateway.clawofshiva.tech returns 404; backend is operational but Traefik not routing correctly to service
- **Self-signed certificate:** Let's Encrypt rate-limit (429) on graphiti.clawofshiva.tech blocking certificate generation
  - Rate limit window expires: ~2026-05-01 04:00 UTC
  - Workaround: Manual DNS verification strategy for next renewal; current cert is self-signed
  - Impact: Non-blocking to macro-oracle backend (uses primary clawofshiva.tech domain)
- **Diagnosis pattern:** curl -I https://gateway.clawofshiva.tech/ → 404; dig gateway.clawofshiva.tech → resolves correctly (72.60.119.23); container logs show no errors
- **Next action:** Verify Traefik routing labels, check service name in docker-compose, confirm network bridge

## Notes to remember
- Distinguish gateway health from CLI shadowing
- Prefer non-destructive environmental diagnosis before changing binaries
- OpenRouter API key must be lowercase: `sk-or-v1-...` (not `Sk-or-v1-...`)
- Mistral Small 3.2 correct model ID on OR: `mistralai/mistral-small-3.2-24b-instruct`
- Free-tier OR models (step-3.5-flash:free) go rate-limited without warning — unreliable as last resort
- gpt-5.2 requires `max_completion_tokens` not `max_tokens`
- **himalaya IMAP credential failure (Apr 27–30):** OAuth setup completed Apr 12, but himalaya returning "Invalid credentials" on IMAP auth attempts. Persisting through Apr 30. Likely config/token mismatch rather than OAuth flow failure. Workaround: manual email checks via browser; use `gog` CLI as fallback. [updated 2026-04-30]
