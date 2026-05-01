# Project: Ollama VPS Deployment

**Status:** IN PROGRESS (model download in progress)
**Started:** 2026-04-30 13:20 EDT
**Goal:** Enable local inference on VPS (72.60.119.23) as fallback when OpenRouter is rate-limited

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

## Infrastructure

- **VPS:** Hostinger (72.60.119.23), Docker host_network mode
- **Endpoint:** http://72.60.119.23:11434 (raw Docker IP, not DNS)
- **Prior config:** http://ollama:11434 (Docker DNS, now deprecated)
- **Fallback chain (updated 2026-04-30 14:25):** Qwen 2.5 7B → Claude Haiku 4.5 → Gemini 2.5 Flash → Grok 3 Mini Fast

## Notes
- CPU-only inference is slow (~3–4s per request) but suitable as fallback when OpenRouter unavailable
- Docker host_network simplifies port exposure vs. bridge networking
- Password SSH auth (via sshpass) working reliably; ED25519 key auth still blocked
