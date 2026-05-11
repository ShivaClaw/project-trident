# Deployment Patterns & Lessons

## OpenClaw VPS Installation (2026-05-09)

### npm Installation
- [2026-05-09] OpenClaw installs globally: `npm install -g openclaw` (v2026.5.7)
- [2026-05-09] Creates system binary: `/usr/bin/openclaw`
- [2026-05-09] Requires Node.js v22+ runtime

### User & Permission Setup
- [2026-05-09] Create system user: `useradd -r -s /bin/bash openclaw`
- [2026-05-09] Directory ownership critical: `chown -R openclaw:openclaw /home/openclaw/.openclaw`
- [2026-05-09] Config files must be readable by openclaw user (not root-owned)

### Configuration
- [2026-05-09] Config file: `/home/openclaw/.openclaw/openclaw.json`
- [2026-05-09] Credentials: `/home/openclaw/.openclaw/.env.secret`
- [2026-05-09] Validation can be checked via `openclaw status` or `openclaw gateway status`
- [2026-05-09] "Config invalid" error usually indicates permission or missing required fields

### Gateway
- [2026-05-09] Gateway can be started: `openclaw gateway start`
- [2026-05-09] Gateway needs to run in foreground for bare metal (not as background daemon initially)
- [2026-05-09] Alternative: systemd service or nohup for persistent background operation
- [2026-05-09] Gateway resolves authentication on startup

### Known Issues
- [2026-05-09] Package migration: lossless-claw plugin may report missing '@mariozechner/pi-coding-agent' (non-blocking)
- [2026-05-09] npm install arguments: `install` command expects exactly 1 argument (package name/path)

### Workspace Migration
- [2026-05-09] Full workspace can be copied via SCP: `scp -r ~/.openclaw/workspace openclaw@host:/home/openclaw/.openclaw/`
- [2026-05-09] Memory continuity preserved via SOUL.md, MEMORY.md, USER.md, and daily logs
- [2026-05-09] Ownership must be reset after SCP: `chown -R openclaw:openclaw`

## Gateway Configuration (2026-05-09)
- [2026-05-09 05:36] gateway.listen config key is INVALID (not recognized by OpenClaw)
- [2026-05-09 05:36] gateway.mode=local forces binding to 127.0.0.1 (loopback only)
- [2026-05-09 05:36] gateway.mode=remote may require additional configuration (DNS, TLS, or --allow-unconfigured flag)
- [2026-05-09 05:36] Gateway config changes may not take effect on restart without proper process cleanup
- [2026-05-09 05:36] Process killing from unprivileged user (openclaw) fails with "Operation not permitted" for root-owned processes
- [2026-05-09 05:36] Workaround: SSH tunnel (local port forward) can expose localhost gateway UI to remote clients
- [2026-05-09 05:36] Gateway runs after config load; binding mode determined at startup

## General Patterns
- Permissions are always the most common blocker in Linux service setup
- User ownership must match service runtime user
- Configuration validation happens before full startup
- Workspace portability is critical for agent continuity
- Gateway binding configuration is non-obvious; loopback-only default requires explicit config to expose
- Process management in unprivileged context requires careful permission planning
