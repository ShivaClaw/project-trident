# Project: Ollama VPS Deployment [ARCHIVED 2026-05-11]

**Status:** ✅ SUPERSEDED — Consolidated to ThinkCentre Ollama
**Started:** 2026-04-30 13:20 EDT
**Ended:** 2026-05-11 01:13 EDT (VPS Ollama monitoring disabled, all inference routes through ThinkCentre)
**Original Goal:** Enable local inference on VPS (72.60.119.23) as fallback when OpenRouter is rate-limited

**CURRENT SETUP (2026-05-11):**
- ThinkCentre Ollama: http://100.115.190.59:11434 (Qwen 2.5 pulling)
- Distributed Gateway: 100.117.138.18:18789 (Tailscale)
- VPS Ollama: OFFLINE / ABANDONED

## Timeline

### 2026-04-30 13:20 EDT — Initial Deployment
- Created Docker container for Ollama on VPS
- Started downloading Qwen 2.5 7B (4.7GB)
- Updated openclaw.json to use VPS IP endpoint: http://72.60.119.23:11434
- Gateway config hot-reloaded via SIGUSR1 signal
- Queued Qwen 3.5 9B (fallback, ~14GB) for sequential download

### 2026-04-30 — Download Status
- **Qwen 2.5 7B:** In progress (ETA 2–4+ hours; CPU-only VPS, 127 MB/s observed)
- **Qwen 3.5 9B:** ❌ CANCELLED (2026-04-30 14:25 EDT — G removed as fallback; focused on Qwen 2.5 primary)
- **Next step:** Test inference latency (~3–4s expected per request on CPU) once 2.5 download completes
- **Blocker:** Model availability before integration complete

### 2026-04-30 14:25 EDT — Qwen 3.5 Cleanup
- Deleted qwen3.5:9b from Ollama container (`ollama rm qwen3.5:9b`)
- Removed all config references:
  - openclaw.json: removed qwen3.5 model entry
  - Nirvana plugin (router.js): removed fallback references
  - Infrastructure notes (systems.md): updated Ollama section
- Gateway config reloaded via SIGUSR1 signal
- Simplified fallback chain removes heavy model, reduces storage footprint

## Infrastructure [ARCHIVED]

- **VPS:** Hostinger (72.60.119.23) — Ollama service NO LONGER IN USE
- **Former Endpoint:** ~~http://72.60.119.23:11434~~ [REMOVED 2026-05-11]
- **New Endpoint:** http://100.115.190.59:11434 (ThinkCentre)
- **Cron Job:** "Ollama Model Availability Monitor" disabled in jobs.json
- **Fallback chain (current):** Qwen 2.5 7B (ThinkCentre) → Claude Haiku 4.5 → Gemini 2.5 Flash → Grok 3

## Notes [ARCHIVE]
- CPU-only inference on VPS was slow (~3–4s per request), but no longer needed
- ThinkCentre has GPU capability and Ollama is properly integrated
- All reliance on VPS Ollama removed 2026-05-11
- Transition complete; VPS Ollama service can be stopped/removed
