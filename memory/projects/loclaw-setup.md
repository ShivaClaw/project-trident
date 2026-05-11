# LoClaw Setup — Node Pairing & Configuration

**Project:** Configure LoClaw (ThinkCentre) OpenClaw node to use distributed Ollama inference

**Status:** 🔴 **BLOCKED** — Awaiting device pairing approval on LoClaw Control UI

## Timeline

- **2026-05-11 07:09 EDT** — Attempted remote Ollama configuration via OpenClaw CLI gateway calls
- **2026-05-11 07:13 EDT** — Discovered device pairing requirement; security feature prevents untrusted remote CLI access
- **2026-05-11 07:18 EDT** — Documented blocker; awaiting G input

## Blocker

**Device Pairing Security:** LoClaw's OpenClaw gateway requires explicit pairing approval on the LoClaw Control UI before any remote CLI commands are permitted.

**How to unblock:**
1. Access LoClaw Control UI (typically http://100.117.138.18:8080 or similar on Tailscale)
2. Find pairing/device approval section
3. Approve the CLI device (will show a pairing request)
4. Retry remote configuration commands

## Next Steps

1. G approves device pairing on LoClaw Control UI
2. Configure LoClaw to use ThinkCentre Ollama (100.115.190.59:11434)
3. Test Ollama connectivity from LoClaw container
4. Verify model inference works via distributed gateway

## Notes

- This is intentional security; do not bypass pairing requirement
- LoClaw's gateway is running and operational (gateway socket accessible)
- Ollama on ThinkCentre is accessible internally (verified via container status)
- Configuration should complete in <5 min once pairing is approved
