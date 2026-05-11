# Replication Project - Shiva Self-Hosted Instance

**Status:** INITIATED
**First Signal:** 2026-05-09T04:06 EDT (msg#28855)
**Priority:** Medium

## Intention

G wants to "replicate you [Shiva] and your memory system the simplest way possible."

Context: Ollama VPS (72.60.119.23:11434) became unreachable; exploring self-hosted options to avoid dependency on external services.

## Approach (Per Assistant Context)

Straight replication path:
1. Install OpenClaw on bare metal
2. Copy memory system to the root directory
3. Boot → load files → go

**What needs to copy from container → bare metal:**
- Full `/data/.openclaw/workspace/` directory structure
- Memory files: `memory/`, `SOUL.md`, `USER.md`, `AGENTS.md`, etc.
- Credentials/config from `.env.secret` (if applicable)

## Status

- [ ] Clarify target environment (bare metal? VM? where?)
- [ ] Define scope (full replication vs. memory system only?)
- [ ] Plan migration approach
- [ ] Test on target environment
- [ ] Document runbook

## Blockers / Questions

- What's the target host/environment?
- OpenClaw already installed there, or fresh install needed?
- Full instance or isolated memory fork?
- Timeline?

**Next action:** Await G clarification on scope and target environment.

---

[created 2026-05-09T04:06 UTC by L0H Cycle #823]
