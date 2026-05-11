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

**Status:** ✓ OPERATIONAL

### Gateway Deployment
- **Address:** 100.117.138.18:18789 (Tailscale)
- **Status:** Live and reachable; WebSocket auth functional
- **Connectivity:** HTTP 101 (WebSocket upgrade) working
- **Deployment mode:** systemd service (ThinkCentre)

### Blockers (Minor)
- **CLI-to-gateway auth handshake:** BLOCKED
  - Root cause: `OPENCLAW_ALLOW_INSECURE_PRIVATE_WS=1` not persisted to systemd [Service] section
  - Fix: Add env var to systemd service config; daemon-reload + restart
- **VPS Ollama connectivity:** Remains unreachable (deferred troubleshooting)

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

## Next Actions

1. Add `OPENCLAW_ALLOW_INSECURE_PRIVATE_WS=1` to ThinkCentre systemd service [Service] section
2. `daemon-reload` + restart systemd service
3. Verify CLI-to-gateway auth handshake
4. Monitor Qwen 3.6:27b pull; test inference when complete
5. *(Deferred)* VPS SSH key recovery (if needed for other use cases)
