# Project: OpenClaw to Bare-Metal VPS Deployment

**Status:** 🟡 **GATEWAY CONFIGURATION PHASE** (migration core COMPLETED)

**Timeline:** 2026-05-09 03:49 EDT – ongoing

---

## Executive Summary

G initiated a container-to-bare-metal migration of OpenClaw from Docker (claw-of-shiva_tech) to Hostinger VPS (Ubuntu 24.04, 72.60.119.23). **Core migration COMPLETED 05:27 EDT.** Currently in gateway configuration phase — attempting to expose OpenClaw gateway UI and resolve loopback-only binding constraints.

---

## Phase 1: BARE-METAL INSTALLATION (COMPLETED 2026-05-09 05:27 EDT)

### Hardware Target
- **Host:** Hostinger VPS (72.60.119.23, Ubuntu 24.04)
- **Architecture:** x86_64
- **Version:** 2026.5.7
- **Installation method:** npm global install (`openclaw` package)
- **Binary location:** `/usr/bin/openclaw`
- **State directory:** `/home/openclaw/.openclaw/`

### Installation Summary
✅ Binary installed via npm global  
✅ State directory initialized  
✅ Configuration files created  
✅ Service user created (`openclaw`)  
✅ Systemd service configured (not enabled for now)  

**Timestamp:** 2026-05-09T05:18–05:27 EDT

---

## Phase 2: GATEWAY CONFIGURATION (ONGOING)

### Current Status
🔴 **CRITICAL BLOCKERS (NEW 2026-05-09 08:42 EDT):**
- **SSH Key Corruption:** `/data/.ssh/vps_rsa` file corrupted ("string is too large") — blocking VPS access
- **Ollama Service Down:** API not responding, 0 models detected — inference unavailable
- **Related issues:** Login failure with publickey/password auth (code 255)

### Previous Issues (Standing)
- HTTP server listening on loopback ONLY: `127.0.0.1:18789` and `::1:18789`
- Gateway needs external access for OpenClaw control UI
- Config keys attempted: `gateway.bind`, `bind`, `server.bind` (invalid/unrecognized)
- Process management permissions: Running as `openclaw` user; sudo/elevation constraints

### Attempted Solutions
1. SSH tunnel forwarding attempted (2026-05-09 05:37–05:59 EDT)
   - Established SSH key setup
   - Tunnel config tested but VPS connectivity issues at that time
   
2. Anthropic API key configuration (2026-05-09 07:38–07:47 EDT)
   - Gateway restart triggered
   - Anthropic plugin already enabled in config
   - Models now authenticated and available

### Open Questions
- How to expose gateway to external interfaces (not just loopback)?
- Config key naming for gateway bind address?
- Permission model for process elevation?

**Current phase start:** 2026-05-09T05:27 EDT  
**Last activity:** 2026-05-09T08:42 EDT (SSH key corruption + Ollama down detected)
**⚠️ ESCALATION:** Critical VPS infrastructure failures detected; blocking further deployment work

---

## Infrastructure Context

### VPS Shared Services (72.60.119.23)
- **OpenClaw Gateway** (main focus — gateway UI exposure needed)
- Traefik (HTTP/HTTPS reverse proxy)
- Ollama (local LLM inference — qwen2.5:7b)
- FalkorDB (graph database)
- Qdrant (vector database)
- clawofshiva-website (Nginx static content)

### File Locations
- **Local workspace:** `/data/.openclaw/workspace/`
- **VPS state:** `/home/openclaw/.openclaw/`
- **VPS config:** `~/.openclaw/openclaw.json`
- **VPS logs:** `/tmp/openclaw/openclaw-2026-05-09.log`

---

## Next Steps (PRIORITY ORDER)

### URGENT (Resolve Before Gateway Work)
1. **SSH Key Repair/Recovery:**
   - [ ] Recover/regenerate `/data/.ssh/vps_rsa` key
   - [ ] Verify VPS host key validity
   - [ ] Restore SSH access to 72.60.119.23

2. **Ollama Service Recovery:**
   - [ ] SSH into VPS and diagnose ollama container/process status
   - [ ] Verify qwen3.6:27b model availability (user query: available?)
   - [ ] Restart ollama service if needed
   - [ ] Confirm API responding on localhost

### Deferred (After Infrastructure Stable)
1. **Gateway binding solution:**
   - [ ] Identify correct config key for external binding
   - [ ] Test with 0.0.0.0 or all interfaces binding
   - [ ] Verify Traefik can reverse-proxy to gateway

2. **SSH tunnel as interim solution:**
   - [ ] Verify VPS SSH connectivity stable (post-key-recovery)
   - [ ] Document SSH tunnel procedure for UI access
   - [ ] Consider persistent tunnel setup

3. **Testing & Validation:**
   - [ ] OpenClaw control UI accessible from external client
   - [ ] Gateway API responding to requests
   - [ ] Logs/monitoring accessible

---

## Decisions Logged

- **Decision:** Bare-metal install over Docker — for better performance and cleaner state management
- **Decision:** Use existing Traefik reverse proxy for gateway exposure (rather than standalone)
- **Decision:** Defer systemd service enablement until gateway binding confirmed

---

## Notes & Learnings

- OpenClaw npm package is mature and installs cleanly on Ubuntu 24.04
- Gateway process initializes correctly but defaults to loopback-only binding
- Config documentation may be sparse for bind address configuration
- SSH key setup works, tunnel forwarding possible, but VPS connectivity must be stable
- ⚠️ SSH key integrity failures possible (file corruption observed 2026-05-09 08:27 EDT)
- ⚠️ Ollama requires monitoring; service health not automatically maintained

---

**Project owner:** G (Brandon)  
**Current phase:** Gateway Configuration (BLOCKED on infrastructure issues)  
**Last update:** 2026-05-09T08:42 EDT (SSH key + Ollama failure detected)  
**Status:** 🔴 **CRITICAL** — SSH key corruption + Ollama down; requires immediate triage  
**Next review:** Urgent — recommend immediate investigation of SSH key and ollama status when G returns
