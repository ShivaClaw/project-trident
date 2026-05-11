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

## Gateway Connectivity Diagnostic Protocol (2026-05-11)
- **Test sequence:** (1) Verify port binding: `netstat -tlnp | grep 18789` or `lsof -i :18789` — should show `LISTEN`, (2) Check systemd env: `systemctl show openclaw-gateway | grep Environment` — confirm env vars are set, (3) Test local connection: `curl -i http://localhost:18789/` → should return 200, (4) Test remote connection (if applicable): `curl -i https://100.117.138.18:18789/` via Tailscale → should return 200, (5) Check service logs: `journalctl -u openclaw-gateway -n 50 --no-pager` — look for auth errors or binding failures
- **Port conflict resolution:** If port 18789 is unavailable, `lsof -i :18789` will show the offending PID; `kill -9 <PID>` may be necessary before restart
- **Status:** Protocol established 2026-05-11 04:58 EDT; applied successfully to ThinkCentre gateway

## Network Routing: VPS→LAN Connectivity (2026-05-11)
- **Problem:** VPS (external IP 72.60.119.23, Docker container) cannot directly reach ThinkCentre's internal LAN IP (100.115.190.59:11434)
  - Root cause: Network topology — VPS cannot route to 100.x.x.x (ThinkCentre local network)
  - Distributed gateway (100.117.138.18:18789 via Tailscale) is reachable from VPS but does NOT proxy Ollama traffic on port 11434
  - SSH tunnel attempted but SSH key file `/home/boss/.ssh/id_rsa` is missing on VPS container
- **Solution space:**
  - SSH tunnel + port forwarding (requires SSH key file or password)
  - VPN tunnel (Tailscale or other)
  - Restore local Ollama on VPS (undoes consolidation savings)
  - Configure gateway to proxy Ollama (requires `config.patch` investigation)
- **Lesson:** Testing VPS-to-ThinkCentre connectivity BEFORE consolidation would have caught this. "COMPLETE" status was premature.
  - Better workflow: Validate from source/destination pair before marking infrastructure changes complete
- **Impact:** VPS cron jobs cannot access inference until this is resolved
- **Status:** BLOCKED; awaiting G input on solution preference [2026-05-11 08:04 UTC]

## Notes to remember
- Distinguish gateway health from CLI shadowing
- Prefer non-destructive environmental diagnosis before changing binaries
- OpenRouter API key must be lowercase: `sk-or-v1-...` (not `Sk-or-v1-...`)
- Mistral Small 3.2 correct model ID on OR: `mistralai/mistral-small-3.2-24b-instruct`
- Free-tier OR models (step-3.5-flash:free) go rate-limited without warning — unreliable as last resort
- gpt-5.2 requires `max_completion_tokens` not `max_tokens`
- **himalaya IMAP credential failure (Apr 27–30):** OAuth setup completed Apr 12, but himalaya returning "Invalid credentials" on IMAP auth attempts. Persisting through Apr 30. Likely config/token mismatch rather than OAuth flow failure. Workaround: manual email checks via browser; use `gog` CLI as fallback. [updated 2026-04-30]

## OpenClaw Dual-Instance Issue (2026-05-02)
- **Problem:** Two OpenClaw processes running simultaneously on srv1489775 (Hostinger VPS)
- **Detected:** 2026-05-02T06:10 EDT via `ps aux | grep -i openclaw`
- **Impact:** Configuration work in progress; dual instances interfering with system state
- **Action required:** Identify and kill the stale/unintended instance
- **Lesson:** Dual installations can coexist and cause confusion; explicit binary management critical

## OpenClaw Config Protection (2026-05-02T07:54 EDT)
- **Discovery:** The `models.providers` config block in `/data/.openclaw/openclaw.json` is protected
- **Attempt:** G tried to add Ollama provider configuration via `edit` and `config.patch` tools
- **Result:** All edits failed silently or were rejected; config.patch reports success but changes don't persist
- **Root cause:** OpenClaw prevents modifications to protected config blocks that affect model routing layer
- **Workaround:** Protected fields cannot be edited via tool API; requires different approach (e.g., manual file edit with elevated permissions, or config reload from different source)
- **Lesson:** Some config fields are immutable via standard tools; check OpenClaw docs or source for protected fields before attempting edits
- **Status:** Ollama service itself is running and healthy (confirmed via `ollama list` on host)

## OpenClaw Gateway Systemd Env Var Persistence (2026-05-11)
- **Issue:** `OPENCLAW_ALLOW_INSECURE_PRIVATE_WS=1` environment variable set during testing but not persisted to systemd service
- **Symptom:** Gateway service starts successfully but CLI cannot connect; WebSocket auth fails with connection refused or DNS error
- **Root cause:** Environment variables passed via shell session do NOT persist across systemd service restart
- **Fix:** Add variable to systemd service config file under `[Service]` section: `Environment="OPENCLAW_ALLOW_INSECURE_PRIVATE_WS=1"`
- **Workflow:** (1) Edit systemd service file (e.g., `/etc/systemd/system/openclaw-gateway.service`), (2) Add Environment= line, (3) `systemctl daemon-reload`, (4) `systemctl restart openclaw-gateway`, (5) Verify connectivity
- **Lesson:** Systemd environment variables require config file persistence, not shell export
- **Status:** [pending fix on ThinkCentre; documented 2026-05-11 06:03 EDT]

## OpenClaw Gateway Device Pairing Security (2026-05-11)
- **Issue:** Remote CLI connections to OpenClaw gateway require device pairing approval before any operations are allowed
- **Symptom:** `openclaw gateway call` or RPC methods fail with error: `GatewayClientRequestError: device pairing required (requestId: ...)`
- **Root cause:** Gateway has security feature preventing untrusted remote devices from executing operations without explicit approval
- **Workflow to fix:** (1) User must approve device pairing on the gateway host's Control UI, (2) Control UI is typically at gateway default address (http://localhost or https://<host>), (3) Pairing approval grants that CLI/device permission to execute commands, (4) After approval, retry the CLI command
- **Example:** LoClaw (ThinkCentre) requires user to approve CLI pairing on its Control UI before remote Ollama configuration via `openclaw gateway call` works
- **Lesson:** This is intentional security; do not bypass. For distributed OpenClaw setup, always approve pairing on each node's Control UI before attempting remote configuration
- **Status:** LoClaw configuration blocked pending G's pairing approval [2026-05-11T07:18 EDT]
