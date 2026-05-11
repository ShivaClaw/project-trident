# Semantic — Systems

Technical knowledge about tools, infrastructure, and systems I interact with.

---

## OpenClaw

**Version:** 2026.3.23-2 (current at /data/.npm-global/bin/openclaw)
**⚠️ Stale binary:** /usr/local/bin/openclaw → 2026.3.12 — use explicit path for diagnostics
**Config:** /data/.openclaw/openclaw.json
**Workspace:** /data/.openclaw/workspace
**LCM DB:** /data/.openclaw/lcm.db
**Extensions:** /data/.openclaw/extensions/

**Plugins active:**
- lossless-claw 0.5.2 — contextEngine slot, Haiku summarization

**Session config:**
- Idle reset: 43200 min (30 days)
- Heartbeat: every 30m, 07:00–23:00 America/Denver

---

## VPS (Hostinger)

**Environment:** Docker container on Hostinger VPS (72.60.119.23) — Ollama moved to ThinkCentre (2026-05-11)
**OS:** Linux 6.8.0-110-generic x64 (confirmed 2026-04-30)
**Resources:** ~14GB available RAM, ~178GB free disk
**Homebrew:** /home/linuxbrew/.linuxbrew
**Running containers (2026-04-30 13:20 EDT):** OpenClaw gateway, Traefik, Qdrant, FalkorDB, Ollama
**Storage:** Docker volumes persistent under /home/boss/odin/
**Networks:** Multiple bridge networks (trident-network, traefik_proxy)

---

## Docker Services (planned)

- Qdrant: ~512MB–1GB RAM, port 6333/6334
- Hindsight: ~512MB–1GB RAM
- FalkorDB: ~512MB RAM

---

## Ollama (Local Inference)

**Status:** ✅ OPERATIONAL (as of 2026-04-27 02:05 EDT; config updated 2026-04-30 14:25 EDT)
**Primary Model:** Qwen 2.5 7B (4.7GB, Q4_K_M quantization)
**Deprecated Model:** ~~Qwen 3.5 9B~~ [deleted 2026-04-30 14:25 EDT]
**Endpoint:** http://100.115.190.59:11434 (ThinkCentre local Ollama, pulled Qwen via distributed gateway) [UPDATED 2026-05-11]
**Prior endpoint:** http://ollama:11434 on root_trident-network (172.21.0.2)
**Fallback chain (2026-04-30 14:25):** Qwen 2.5 7B → Claude Haiku 4.5 → Gemini 2.5 Flash → Grok 3 Mini Fast
**Performance:** ~3–4s per request; no timeouts observed; CPU-only, expect queued qwen2.5:7b (primary model only)
**Fallback chain:** Qwen 2.5 7B → Claude Haiku 4.5 → Gemini 2.5 Flash → Grok 3 Mini Fast

**Resolution history:**
- RESOLVED: Qwen 3.5 9B moved to ThinkCentre Ollama (GPU-capable system) — CPU-only VPS no longer used for inference
- Root cause: 9B params unsustainable without GPU acceleration; timed out at first token generation
- Fix applied: Downgraded to Qwen 2.5 7B (2026-04-27 02:05 EDT)
- Gateway: openclaw-kk8i-openclaw-1, localhost:18789

**Docker networking:**
- root_trident-network (shared)
- ollama-local_default
- traefik_proxy
- Container-to-container DNS resolution verified functional

---

## Maton API Gateway

**Status:** ✅ OPERATIONAL (verified 2026-04-28 02:59 EDT)
**Endpoint:** https://gateway.maton.ai/google-drive/drive/v3/files
**Authorization:** Bearer token via MATON_API_KEY environment variable
**Path structure:** /google-drive/drive/v3/{resource}
**Capabilities:**
- List files with field selection: ✅ (fixed syntax issue)
- Download PDFs: ✅ via /alt=media parameter
- PDF export (non-Docs files): ❌ not supported

---

## Gmail

Access via `gog` CLI. Always needs explicit env:
```
GOG_KEYRING_PASSWORD=$(cat /data/.openclaw/.gog-keyring-password) GOG_ACCOUNT=brandongkirksey@gmail.com gog gmail ...
```
Keyring file: /data/.openclaw/.gog-keyring-password

**Tool blocker:** himalaya IMAP credential invalid (2026-04-27 detected; persists 2026-04-30)
- OAuth setup completed 2026-04-12, but token/config mismatch in password-store
- Error: "Invalid credentials" on IMAP connect
- Status: Blocks automated email monitoring; manual browser checks viable
- Workaround: Use `gog` or manual Gmail access via browser
- Better approach pending: SSH key-based auth to VPS (currently using password auth via sshpass)

**Email delivery via Maton API (2026-04-28 attempted):**
- Attempted cowo-v1.0.user.js delivery via Maton API gateway (/google-mail/ endpoint)
- Request: curl with base64-encoded attachment (320KB payload)
- Response: 320,396 bytes received; status code/error handling unclear
- Status: **UNCONFIRMED** — verify delivery to brandongkirksey@gmail.com inbox
- Fallback: Use `gog` CLI for manual delivery if Maton API silent failure confirmed

## SSH Authentication (VPS)

**Current method:** Password authentication via sshpass (2026-04-30 operational)
- Command pattern: `sshpass -p '<password>' ssh ...`
- Password stored in .env.secret (git-ignored, but plaintext risk)
- RESOLVED: VPS Ollama monitoring discontinued 2026-05-11 — consolidated to ThinkCentre
- Performance: Reliable, <1s connect time
- **Better approach:** Add SSH key to VPS manually after container deployment stabilizes [deferred 2026-04-30]
