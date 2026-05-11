# Project: VPS Infrastructure Migration

**Status:** MIGRATED & LIVE (2026-05-11)
**Primary outcome:** Abandoned failing VPS Ollama; consolidated inference to ThinkCentre
**Key decision:** Pragmatic pivot over cost-recovery thinking

---

## Phase 1: VPS Deployment (2026-03-20 – 2026-05-09)

- Hostinger VPS (srv1489775, 72.60.119.23)
- Ollama service + OpenClaw gateway deployed
- SSH key management via ED25519 (AUTH failures on external IP; workaround: sshpass + password)
- Cost: $30/mo

**Outcome:** Infrastructure unstable; SSH key corruption + service down (2026-05-09 08:42 EDT)

---

## Phase 2: Recovery Attempt → Decision (2026-05-09 – 2026-05-11)

**2026-05-09 08:42 EDT** — Critical: VPS Ollama unreachable; SSH key corrupted
**2026-05-11 04:37 EDT** — Decision: Abandon VPS; consolidate to ThinkCentre
  - Root cause analysis deferred (cost-benefit unfavorable)
  - Immediate action: Deploy ThinkCentre OpenClaw gateway
  - Cron monitoring job disabled (cron:ff6d019e-b535-4e60-b887-3ca906afd540)

---

## Phase 3: ThinkCentre Migration (2026-05-11 LIVE)

**Status:** ⚠️ PARTIAL — ThinkCentre gateway live, but VPS→ThinkCentre Ollama connectivity BLOCKED

### Gateway Deployment
- **Address:** 100.117.138.18:18789 (Tailscale)
- **Status:** Live and reachable; WebSocket auth functional
- **Connectivity:** HTTP 101 (WebSocket upgrade) working
- **Deployment mode:** systemd service (ThinkCentre)

### Blockers (ACTIVE)
- **VPS→ThinkCentre Ollama connectivity:** 🔴 BLOCKED (NEW — 2026-05-11 08:04 UTC)
  - **Issue:** VPS cannot reach ThinkCentre local IP (100.115.190.59) directly
  - **Root cause:** Network routing — VPS external IP cannot directly reach ThinkCentre's internal LAN IP
  - **Workaround attempted:** Distributed gateway does NOT proxy Ollama traffic on port 11434
  - **SSH tunnel attempt:** SSH key not accessible (/home/boss/.ssh/id_rsa missing)
  - **Impact:** VPS-based cron jobs cannot reach Ollama for inference
  - **Status:** REQUIRES SOLUTION (tunneling, gateway proxy, or VPS-only Ollama)
  - **2026-05-11 08:24 UTC:** G requested Ollama reconfiguration on ThinkCentre to listen on 0.0.0.0:11434 (broadcast listener) — potential solution path to enable VPS connectivity

- **CLI-to-gateway auth handshake:** BLOCKED
  - Root cause: `OPENCLAW_ALLOW_INSECURE_PRIVATE_WS=1` not persisted to systemd [Service] section
  - Fix: Add env var to systemd service config; daemon-reload + restart

### Ollama Integration
- **Primary endpoint:** 100.115.190.59:11434 (ThinkCentre Ollama)
- **Model in progress:** Qwen 3.6:27b (pull initiated 2026-05-11 04:37 EDT)
- **Fallback chain:** Qwen 2.5 7B → Claude Haiku 4.5 → Gemini 2.5 Flash → Grok 3

---

## Key Metrics

| Dimension | Outcome |
|-----------|---------|
| **Cost** | $30/mo savings |
| **Reliability** | Improved (GPU + local control) |
| **Inference latency** | Reduced (local network) |
| **Recovery time** | <4 hours (pivot vs. troubleshoot) |

---

## Lessons Captured

1. **Infrastructure migration via pragmatic abandonment:** When recovery cost exceeds pivot cost, abandon immediately.
2. **Atomic consolidation:** Update cron + config + memory simultaneously to avoid stale references.
3. **Tailscale routing:** Preferred over VPS direct IP for reliability and credential management.

---

## Lessons Learned (Phase 3)

1. **Network topology problem:** VPS external routing cannot directly address ThinkCentre LAN IPs
   - Solution space: SSH tunnel, VPN, or restore local Ollama on VPS
2. **Premature "COMPLETE" status:** Marked consolidation complete before testing actual VPS connectivity
   - Better approach: Test from VPS first, then declare complete

## Next Actions

1. **Resolve VPS→Ollama connectivity** (CRITICAL for inference)
   - Option A: SSH tunnel + port forward (requires SSH key fix)
   - Option B: Restore local Ollama on VPS (defeats consolidation goal)
   - Option C: Investigate gateway proxy configuration (check `config.patch`)
   - **Decision pending:** G input on preferred approach

2. Add `OPENCLAW_ALLOW_INSECURE_PRIVATE_WS=1` to ThinkCentre systemd service [Service] section
3. `daemon-reload` + restart systemd service
4. *(Deferred)* VPS SSH key recovery
