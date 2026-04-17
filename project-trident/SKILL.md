---
name: project-trident
description: Three-tier persistent memory architecture for OpenClaw agents. Implements LCM-backed durability, hierarchical .md file organization, and agentic signal routing. Designed for autonomous agents needing continuity, identity development, and resilience across sessions. Solves "blank spots" where events fail to be captured in short-term memory.
---

# Project Trident: Three-Tier Persistent Memory Architecture

**Problem:** OpenClaw agents lose context between sessions. Default memory is shallow, fragile, and doesn't support autonomous growth.

**Solution:** Trident is a production-grade three-tier memory system combining SQLite durability, semantic organization, and agentic curation.

---

## Start Here

**New to Trident?** → Read `references/trident-lite.md`  
No Docker required. Works on Windows, Mac, Linux, and any VPS out of the box.

**Already have MEMORY.md, SOUL.md, or custom memory files?** → Read "Migration" below.

**Want Docker-based semantic search?** → Read `references/deployment-guide.md`

**Not sure which model or interval to use?** → Read `references/cost-calculator.md`

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│ Conversation Input (user messages, tool results, internal)  │
└──────────┬──────────────────────────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────────────────────────┐
│ LAYER 0: LCM (Lossless Context Management)                  │
│ ├─ SQLite persistence (every message)                       │
│ ├─ DAG lineage tracking                                     │
│ └─ Never loses a message, even after compaction             │
└──────────┬──────────────────────────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────────────────────────┐
│ LAYER 0.5: Signal Router (Cron Agent, every 10–30 min)     │
│ ├─ Scans daily logs via WAL protocol                       │
│ ├─ Classifies signals: correction / project / self / fact  │
│ ├─ Routes to Layer 1 buckets                               │
│ └─ Cost: ~$1.44/day (Haiku 15-min) or $0 (Ollama)         │
└──────────┬──────────────────────────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────────────────────────┐
│ LAYER 1: Hierarchical Memory Buckets                        │
│ ├─ MEMORY.md (curated long-term)                           │
│ ├─ memory/daily/ (raw episodic logs)                       │
│ ├─ memory/self/ (personality, beliefs, identity)           │
│ ├─ memory/lessons/ (learnings, tool quirks, mistakes)      │
│ ├─ memory/projects/ (work-in-progress)                     │
│ └─ .md format (human-readable, Git-compatible)             │
└──────────┬──────────────────────────────────────────────────┘
           │ (optional upgrade)
           ▼
┌─────────────────────────────────────────────────────────────┐
│ SEMANTIC RECALL (Optional — add when memory > 50K msgs)    │
│ ├─ Qdrant vector search (Docker, binary, or cloud)         │
│ └─ FalkorDB entity graph (Docker, Redis module, or cloud)  │
└─────────────────────────────────────────────────────────────┘
```

---

## Platform Support

| Platform | Trident Lite | Semantic Recall (Docker) | Semantic Recall (No Docker) |
|---|---|---|---|
| Linux | ✅ | ✅ | ✅ (native binary) |
| macOS | ✅ | ✅ | ✅ (native binary) |
| Windows | ✅ | ✅ (WSL2) | ✅ (binary or cloud) |
| VPS (Ubuntu/Debian) | ✅ | ✅ | ✅ |
| Docker container | ✅ | ✅ | ✅ |

See `references/platform-guide.md` for platform-specific commands.

---

## Core Layers

### Layer 0: LCM (Lossless Context Management)

- **What:** SQLite+DAG capture of every session message
- **Why:** Baseline durability for all conversation history; recovery foundation
- **Key property:** Compaction creates summaries that link back to source messages via DAG — nothing is ever truly lost
- **Prerequisite:** Enable `lossless-claw` plugin in `openclaw.json`

### Layer 0.5: Signal Router (Cron Agent)

- **What:** Independent cron running every 10–30 minutes
- **Why:** Parse conversation noise, classify signals, route to appropriate buckets
- **Four functions:**
  1. **Attention management** — corrections (highest priority), decisions, breakthroughs
  2. **Fact-finding** — names, numbers, dates, technical facts
  3. **Pattern matching** — route to the correct semantic bucket
  4. **Memory categorization** — daily, self, lessons, projects, reflections
- **Model:** Claude Haiku recommended (cost-optimized, ~95% accuracy)
- **Template:** `scripts/layer0-agent-prompt-template.md`
- **Security:** Run `scripts/template-integrity-check.sh` as a pre-check

### Layer 1: Hierarchical Memory Buckets

- **What:** Persistent `.md` file organization
- **Structure:**
  - `MEMORY.md` — curated long-term memory (keep compressed and high-signal)
  - `memory/daily/` — raw episodic logs (YYYY-MM-DD.md)
  - `memory/semantic/` — models, knowledge, technical facts
  - `memory/self/` — personality, beliefs, voice, growth, identity
  - `memory/lessons/` — learnings, tool quirks, debugging notes, mistakes
  - `memory/projects/` — work-in-progress, active sprints, recurring workstreams
  - `memory/reflections/` — weekly/monthly consolidation
  - `memory/layer0/` — AGENT-PROMPT.md, audit log, approved hash
- **Why:** Human-readable, Git-compatible, debuggable, diff-able
- **Quality rule:** Compress over accumulate; signal density over volume

---

## Optional Extension: Semantic Recall

For agents handling 50K+ messages, add vector search and entity graphs:

**Qdrant (Vector Search):**
- **Deployment:** Docker, standalone binary, or Qdrant Cloud (free tier)
- **Purpose:** Semantic search across memory chunks ("what did we discuss about X six months ago?")
- **Integration:** Pre-turn context injection via Layer 0.5

**FalkorDB (Entity Graphs):**
- **Deployment:** Docker, Redis module, or FalkorDB Cloud
- **Purpose:** Entity relationship tracking (person X works at company Y, mentioned on date Z)
- **Integration:** Graphiti MCP for automated entity extraction

**These are optional.** Trident core (Layers 0, 0.5, 1) works standalone indefinitely.

---

## Migration from Existing Memory

If you already have `MEMORY.md`, `SOUL.md`, or other memory files, use the migration script:

```bash
chmod +x scripts/migrate-existing-memory.sh

# Dry run (preview changes, no files modified)
./scripts/migrate-existing-memory.sh --dry-run

# Live run (with backup)
./scripts/migrate-existing-memory.sh
```

**What it does:**
1. Creates backup of all existing files → `memory/migration-backup/`
2. Creates Trident directory structure
3. Guides you through file routing decisions (interactive)
4. Installs AGENT-PROMPT.md
5. Generates migration report

**Safety guarantees:**
- Dry-run mode previews all changes before committing
- Originals are backed up (never deleted)
- You approve each routing decision interactively

---

## Security

### Template Integrity

Layer 0.5 reads `memory/layer0/AGENT-PROMPT.md` and executes its instructions. A compromised prompt = compromised routing.

**After setup, approve your template:**
```bash
chmod +x scripts/template-integrity-check.sh
./scripts/template-integrity-check.sh --approve
```

**Before each Layer 0.5 run, verify:**
```bash
./scripts/template-integrity-check.sh --silent
# Exit 0: clean. Exit 1: tampered (halt routing).
```

**After intentional edits, re-approve:**
```bash
./scripts/template-integrity-check.sh --approve
```

All checks are logged to `memory/layer0/audit-log.md`.

### Defense in Depth

- **Sandboxed cron:** Layer 0.5 runs in `isolated` session (no main session access)
- **File scope:** Layer 0.5 only writes to `memory/` subdirectory
- **Audit trail:** Every routing decision logged to `memory/layer0/audit-log.md`
- **Network isolation:** Layer 0.5 cron has no external network requirements
- **Backup:** All memory protected by Git/VPS snapshots (see `references/deployment-guide.md`)

---

## WAL Protocol (Write-Ahead Logging)

**Rule:** Write important facts before composing responses.

**Triggers:**
- Corrections: "It's X, not Y"
- Proper nouns: names, places, products
- Preferences: "I like/don't like X"
- Decisions: "Let's do X"
- Specific values: numbers, dates, URLs, prices

**Pattern:**
1. User message arrives
2. Scan for WAL triggers
3. **Write to daily log or memory file first**
4. Then compose response

This prevents blank spots where critical context gets lost between Layer 0.5 runs.

---

## Cost

| Profile | Model | Interval | Cost/day |
|---|---|---|---|
| Zero Budget | Ollama (local) | 30 min | $0 |
| Budget | Claude Haiku | 30 min | $0.72 |
| **Standard** | **Claude Haiku** | **15 min** | **$1.44** |
| Premium | Claude Sonnet | 15 min | $3.12 |

See `references/cost-calculator.md` for the full decision tree, Gemini Flash option, and optimization strategies.

---

## Implementation Checklist

### Trident Lite (No Docker Required)

- [ ] Enable `lossless-claw` plugin in `openclaw.json`
- [ ] Create Layer 1 directory structure (`memory/` subdirs)
- [ ] Populate `MEMORY.md` with Trident header
- [ ] Copy `scripts/layer0-agent-prompt-template.md` → `memory/layer0/AGENT-PROMPT.md`
- [ ] Customize AGENT-PROMPT.md for your domain and workspace path
- [ ] Create Layer 0.5 cron job (15-min interval, Haiku model)
- [ ] Run `template-integrity-check.sh --approve`
- [ ] Test Layer 0.5 manually via `cron run --run-mode force`
- [ ] Verify signals routing to Layer 1 buckets

### Optional: Semantic Recall

- [ ] Deploy Qdrant (Docker, binary, or cloud) — see `references/deployment-guide.md`
- [ ] Deploy FalkorDB (Docker, Redis module, or cloud) — optional
- [ ] Implement pre-turn context injection in Layer 0.5
- [ ] Test semantic search queries

### Optional: Git Backup

- [ ] `git init` in workspace
- [ ] Add `.gitignore` for private files (SOUL.md, USER.md, etc.)
- [ ] Create daily backup cron (see `references/deployment-guide.md`)

---

## Design Principles

1. **Durability over convenience** — SQLite+DAG is slower than in-memory, but persistent
2. **Human-readable over compressed** — `.md` files are debuggable, diff-able, Git-compatible
3. **Agentic curation over auto-capture** — Layer 0.5 router prevents noise accumulation
4. **Deployment-agnostic** — No required cloud services; local-first by default
5. **Personality as first-class component** — `memory/self/` is core architecture, not metadata
6. **Security by default** — Template integrity, sandboxed cron, audit logging
7. **Progressive complexity** — Start with Trident Lite; upgrade to Semantic Recall when needed

---

## What This Solves

- **Blank spots** — Events that fail to be captured are recovered by Layer 0.5 cron
- **Coherence across sessions** — LCM + Layer 1 + Layer 0.5 form continuous pipeline
- **Offline resilience** — Local models (Ollama) can substitute for cloud APIs
- **Identity development** — `memory/self/` supports autonomous agent personality formation
- **Audit trail** — `.md` files + optional Git provide version control and history
- **Trust** — Template integrity check prevents prompt injection attacks

## What This Doesn't Solve

- **Real-time decision making** — 10-30 min lag in Layer 0.5; for sub-second decisions, rely on LCM directly
- **Very long contexts without Semantic Recall** — Add Qdrant/FalkorDB for 50K+ message recall
- **Private data protection** — Assumes secure local filesystem; add encryption-at-rest for regulated environments

---

## Further Reading

| File | Purpose |
|---|---|
| `references/trident-lite.md` | **Start here.** Full Trident Lite setup (no Docker) |
| `references/deployment-guide.md` | Semantic Recall (Qdrant/FalkorDB) and Git backup |
| `references/cost-calculator.md` | Model selection, interval tuning, pricing grid |
| `references/platform-guide.md` | Windows, Mac, Linux, VPS platform-specific commands |
| `scripts/migrate-existing-memory.sh` | Migrate existing memory files into Trident structure |
| `scripts/template-integrity-check.sh` | Security verification for AGENT-PROMPT.md |
| `scripts/layer0-agent-prompt-template.md` | Customizable Layer 0.5 router prompt |

---

## License

MIT-0 — Free to use, modify, and redistribute. No attribution required.
