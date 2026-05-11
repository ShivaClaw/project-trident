# OpenClaw Docker to Host Migration Project

## Overview
G has decided to move OpenClaw from its current Dockerized instance to a host-native installation on Ubuntu 24.04 on the VPS. The primary goal is a clean, minimal-risk migration.

## Recent Updates (2026-05-07)

### Skills Analysis for Migration
Assistant provided a rundown of existing skills/extensions, recommending which are likely needed for a cloud-only, clean OpenClaw migration and suggesting deletion for others. User provided path: `docker/openclaw-kk8i/data/.openclaw/skills/`.

### Docker Dashboard Information
User provided an image of their Docker dashboard, which the assistant analyzed and reported on.

### Plugin Directory Logic
Assistant explained that the Dockerized OpenClaw instance either doesn’t use a traditional `/data/.openclaw/plugins` directory, or plugins are managed via `skills` or `extensions` directories.

### Migration Checklist
Assistant provided a refined step-by-step checklist for a clean, minimal-risk migration from Dockerized OpenClaw to a host-native install on Ubuntu 24.04.

---
**Last Updated:** 2026-05-07T19:26:00Z (Heartbeat-Integrated L0H)
