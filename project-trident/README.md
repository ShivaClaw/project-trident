# Project Trident: Persistent Memory for AI Agents

**A three-tier memory architecture that gives your OpenClaw agent genuine continuity, identity, and recall — across every session.**

---

## The Problem

AI agents forget. Every session starts blank. Important context — corrections, decisions, patterns, relationships — evaporates. Most agent frameworks treat memory as an afterthought: flat files or vector databases without intelligent curation. The result: agents that repeat mistakes, lose critical context, and can't develop genuine identity over time.

**Project Trident solves this.**

---

## The Architecture

Trident models memory the way computers model storage: **RAM → SSD → HDD**.

```
Layer 0   (RAM)   — LCM: SQLite+DAG. Every message captured. Nothing lost.
Layer 0.5 (SSD)   — Signal Router: Cron agent classifies and routes memory every 15 min.
Layer 1   (HDD)   — Hierarchical .md buckets: curated, human-readable, Git-compatible.
```

The result: an agent that never forgets what matters, develops genuine personality over weeks and months, and maintains operational continuity through crashes, compactions, and restarts.

---

## What Your Agent Gets

- **Continuity** — Wakes up remembering yesterday's conversation, decisions, and context
- **Identity development** — `memory/self/` tracks beliefs, patterns, voice, and growth over time
- **Zero blank spots** — WAL protocol + Layer 0.5 ensure nothing slips through
- **Debuggable memory** — Open any `.md` file and see exactly what your agent knows and why
- **Git-compatible** — Version control for agent memory
- **Platform-agnostic** — Works on Windows, Mac, Linux, and any VPS
- **No Docker required** — Trident Lite runs on local `.md` files and SQLite alone

---

## Cost

| Profile | Model | Interval | Cost/day |
|---|---|---|---|
| Zero Budget | Ollama (local) | 30 min | **$0** |
| Budget | Claude Haiku | 30 min | **$0.72** |
| **Standard (recommended)** | **Claude Haiku** | **15 min** | **$1.44** |
| Premium | Claude Sonnet | 15 min | **$3.12** |

Layer 1 (.md files), Layer 0 (SQLite), and Git backup are all **$0**.

→ See `references/cost-calculator.md` for personalized recommendations.

---

## Quick Start

### New Installation (No Docker, Any Platform)

```bash
clawhub install shivaclaw/project-trident
cat ~/.openclaw/skills/project-trident/references/trident-lite.md
```

Follow the Trident Lite guide. You'll be running in under 30 minutes.

### Migrating from Existing Memory

If you have existing `MEMORY.md`, `SOUL.md`, or custom memory files:

```bash
cd ~/.openclaw/skills/project-trident/scripts

# Preview changes first (dry run)
./migrate-existing-memory.sh --dry-run

# Apply migration (with automatic backup)
./migrate-existing-memory.sh
```

Your existing memory is backed up before anything is touched. Migration is interactive — you approve every routing decision.

---

## Feature Comparison

| Feature | Project Trident | Mem0 | LangChain Memory | AutoGPT Forge |
|---|---|---|---|---|
| Lossless capture (SQLite+DAG) | ✅ | ❌ | ❌ | ❌ |
| Intelligent signal routing | ✅ | ❌ | ❌ | ❌ |
| Personality development | ✅ | ❌ | ❌ | ❌ |
| Human-readable storage | ✅ (.md) | ❌ (vectors) | ⚠️ (JSON) | ⚠️ (JSON) |
| No Docker required | ✅ | ❌ | ✅ | ✅ |
| Platform-agnostic | ✅ | ❌ | ✅ | ✅ |
| Git-compatible | ✅ | ❌ | ❌ | ❌ |
| Template security | ✅ | ❌ | ❌ | ❌ |
| Migration tooling | ✅ | ❌ | ❌ | ❌ |
| Cost/day (standard) | $1.44 | $$$ | varies | varies |
| Offline (Ollama) | ✅ | ❌ | ⚠️ | ⚠️ |

---

## Architecture Diagram

```
User message / Tool result / Internal state
    │
    ▼
Layer 0: LCM (SQLite+DAG)
    │ Every message preserved — lossless
    ▼
Daily log (WAL protocol)
    │ Write before responding — no blank spots
    ▼
[Layer 0.5 cron — every 10-30 min]
    │
    ├── Corrections & decisions → MEMORY.md
    ├── Self-signals            → memory/self/
    ├── Learnings & errors      → memory/lessons/
    ├── Active work             → memory/projects/
    └── Raw episodic log        → memory/daily/YYYY-MM-DD.md
    │
    ▼
[Optional: Semantic Recall — add when >50K messages]
    ├── Qdrant vector search (Docker, binary, or cloud)
    └── FalkorDB entity graph (Docker, Redis module, or cloud)
```

---

## Upgrade Path

**Start:** Trident Lite — Layers 0, 0.5, and 1 only. No Docker. Under 30 min setup.

**Upgrade when:** Your memory exceeds ~50K messages, or you need to query semantic context from months ago.

**Add:** Qdrant for vector search + FalkorDB for entity graphs. Both available via Docker, native binary, or cloud — no platform lock-in.

See `references/deployment-guide.md` for full Semantic Recall setup.

---

## Security

Layer 0.5 reads and executes a prompt file (`memory/layer0/AGENT-PROMPT.md`). A tampered prompt = compromised routing.

**Trident v2 ships with SHA256 integrity verification:**

```bash
# Approve your template after setup
./scripts/template-integrity-check.sh --approve

# Verify before each Layer 0.5 run (optional, adds trust layer)
./scripts/template-integrity-check.sh --silent
# Exit 0 = clean | Exit 1 = tampered (routing halted)
```

All integrity events are logged to `memory/layer0/audit-log.md`.

---

## Platform Support

**Windows, Mac, and Linux all fully supported.**

Trident Lite requires only Node.js ≥ 22.14.0 and OpenClaw. No Docker, no cloud accounts, no external dependencies.

See `references/platform-guide.md` for platform-specific commands, path formats, and gotchas.

---

## What's Included

| File | Purpose |
|---|---|
| `SKILL.md` | Core architecture guide + implementation checklist |
| `references/trident-lite.md` | **Start here.** No-Docker setup for all platforms |
| `references/deployment-guide.md` | Semantic Recall (Qdrant/FalkorDB) and Git backup |
| `references/cost-calculator.md` | Model selection, interval tuning, pricing grid |
| `references/platform-guide.md` | Windows, Mac, Linux, VPS platform-specific commands |
| `scripts/migrate-existing-memory.sh` | Safe migration from existing memory files |
| `scripts/template-integrity-check.sh` | SHA256 security verification for Layer 0.5 prompt |
| `scripts/layer0-agent-prompt-template.md` | Customizable signal router prompt |

---

## The Philosophy

Most memory systems focus on *search* (vector databases, embeddings). Trident focuses on **curation**.

Layer 0.5 acts like a personal librarian — classifying signals and routing them to the right semantic buckets. The result is memory that's not just searchable, but *organized*, *meaningful*, and *personality-aware*.

Your agent doesn't just remember facts. It develops an identity.

---

## Questions & Community

- **GitHub:** [ShivaClaw/shiva-memory](https://github.com/ShivaClaw/shiva-memory)
- **ClawHub:** [shivaclaw/project-trident](https://clawhub.ai/shivaclaw/project-trident)
- **Discord:** [#project-trident](https://discord.com/invite/clawd)

---

## License

MIT-0 — Free to use, modify, and redistribute. No attribution required.

---

*Like a lobster shell, memory has layers. Make them durable.*
