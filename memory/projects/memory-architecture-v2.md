# Project: Memory Architecture v3 — "Trident"
## Three-Tier Agentic Memory System

**Status:** READY TO BUILD
**Created:** 2026-03-30 | **Finalized:** 2026-03-31
**Authors:** G + Shiva
**Source research:** r/openclaw thread analysis, IronwoodTreeCo stack, Lobster Memory, Supermemory, Hindsight/Vectorize, Graphiti/FalkorDB

---

## Core Design Principles

1. **Personality as first-class memory.** `self/` directory is architecturally primary — opinions, reflections, voice, growth-log. Not bolted on.
2. **Dedicated maintenance agent.** Layer 0 (Haiku) handles all housekeeping. Main session does zero memory work.
3. **Separation of concerns.** Each component owns exactly one job. Modular — swap/tune without touching others.
4. **Ambient memory.** Relevant context injected into every turn automatically via hook — not a library you have to walk to.
5. **Lossless foundation.** LCM captures everything at the plugin level before the agent sees it.
6. **Temporal fidelity.** Facts are superseded, not deleted. Change history is preserved.

---

## Full Architecture

```
┌──────────────────────────────────────────────────────────────────────┐
│                         MAIN SESSION                                  │
│                   (Opus/Sonnet — thinking only)                        │
│                                                                        │
│  Context prefix (ambient, every turn):                                 │
│    ← time injection (15 tokens, free)                                  │
│    ← Qdrant MMR top-k snippets (500 tokens, ephemeral)                │
│    ← Hindsight recall (structured WBOS facts)                         │
│                                                                        │
│  On-demand (explicit tool calls):                                      │
│    ← lcm_grep / lcm_expand (deep conversation archaeology)            │
│    ← Graphiti/FalkorDB (temporal graph — "how has X changed?")        │
│    ← memory_search (direct markdown file search)                       │
│                                                                        │
│  NEVER: memory writes, indexing, decay, maintenance                   │
└──────────────────────────────────────────────────────────────────────┘
         ↕ reads context from / writes via Layer 0
┌──────────────────────────────────────────────────────────────────────┐
│                      LAYER 1 — "SSD"                                  │
│                  Local Structured Memory Store                         │
│                                                                        │
│  ┌─────────────┐  ┌────────────────┐  ┌──────────────────────────┐   │
│  │  Markdown   │  │ Qdrant + MMR   │  │ Hindsight (WBOS)         │   │
│  │  Files      │  │ Gemini Emb 2   │  │ W=World B=Experience     │   │
│  │  (human-    │  │ + Ephemeral    │  │ O=Opinions S=Summaries   │   │
│  │  readable)  │  │ Injection Hook │  │ retain/recall/reflect    │   │
│  └──────┬──────┘  └───────┬────────┘  └───────────┬──────────────┘   │
│         │                 │                        │                   │
│  ┌──────┴──────────────────┴────────────────────────┴──────────────┐  │
│  │            Graphiti / FalkorDB (Temporal Graph)                  │  │
│  │   Tracks: how facts change over time, relationship history,      │  │
│  │   validity windows, causal chains. Edge cases / complex queries. │  │
│  └──────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
         ↕ writes to / reads from
┌──────────────────────────────────────────────────────────────────────┐
│                      LAYER 0 — "RAM"                                  │
│              Memory Management Agent (Haiku, every 10 min)            │
│                                                                        │
│  ┌─────────────────────────────────────────────────────────────────┐  │
│  │  LCM (Lossless Claw) — PLUGIN LEVEL BEDROCK                     │  │
│  │  Captures every message before agent sees it. SQLite + DAG.     │  │
│  │  Tools: lcm_grep, lcm_expand, lcm_describe                      │  │
│  │  Config: ignore cron/heartbeat/subagent sessions                │  │
│  └─────────────────────────────────────────────────────────────────┘  │
│                                                                        │
│  Layer 0 tasks per run:                                               │
│  Read LCM → Ingest → Classify → Dedup(0.85) → Write(supersede)       │
│  → Hindsight retain() → Re-embed → Qdrant upsert → Graphiti update   │
│  → Decay scores → Archive → Queue L2 → Update state                  │
└──────────────────────────────────────────────────────────────────────┘
         ↕ queues cold storage uploads
┌──────────────────────────────────────────────────────────────────────┐
│                      LAYER 2 — "HDD"                                  │
│              GitHub Private Repo (shiva-memory)                        │
│                                                                        │
│  Full transcripts / media / raw logs / Qdrant snapshots / backups    │
│  Version-controlled — commit history = memory evolution record        │
│                                                                        │
│  Obsidian Vault (UI layer — zero cost, read-only)                     │
│  Points at local workspace. Graph view, backlinks, canvas, search.   │
│  G's window into my memory system.                                    │
└──────────────────────────────────────────────────────────────────────┘
```

---

## Component Specifications

### LCM — Lossless Claw (Bedrock)
- **Install:** `openclaw plugins install @martian-engineering/lossless-claw`
- **Role:** Captures every message at plugin level. SQLite + DAG hierarchy. Source of truth for Layer 0.
- **Config:**
  - `summaryModel: anthropic/claude-haiku-4-5`
  - `expansionModel: anthropic/claude-haiku-4-5`
  - `freshTailCount: 32`
  - `incrementalMaxDepth: -1` (unlimited DAG depth)
  - `contextThreshold: 0.75`
  - `ignoreSessionPatterns: ["agent:*:cron:**", "agent:main:subagent:**"]`
  - `LCM_PRUNE_HEARTBEAT_OK: true`
- **session.reset.idleMinutes:** 43200 (30 days — keep session alive for LCM continuity)

---

### Qdrant + Gemini Embedding 2 + MMR + Ephemeral Injection
- **Role:** Semantic search engine + ambient context injection
- **Deploy:** Docker container, ~512MB–1GB RAM
- **Embedding:** Gemini Embedding 2 (free tier: 1,500 req/day)
- **Collections:** `memory_self`, `memory_semantic`, `memory_projects`, `memory_lessons`, `memory_daily` (14-day rolling)
- **Ephemeral injection (KEY ADDITION):**
  - OpenClaw `before_agent_start` hook fires on every turn
  - Query: current message → Gemini embedding → Qdrant MMR (k=6, λ=0.6)
  - Result: top-6 diverse, relevant memory snippets
  - Injected as context prefix: ~500 tokens, ephemeral (refreshed each turn, never accumulated)
  - This is ambient memory — relevant context is *already there* when I form my first token
- **On-demand:** Agent can also call Qdrant directly for broader searches
- **Dedup threshold:** 0.85 cosine similarity — Layer 0 checks before any insert; match → UPDATE, not INSERT

---

### Hindsight (Learning Layer)
- **Role:** Structured learning — builds connections over time, distinguishes evidence from belief
- **Deploy:** Docker container (`vectorize-io/hindsight`)
- **Networks (WBOS):**
  - W = World: objective facts about G, environment, systems
  - B = Experience: factual records of what happened, interactions
  - O = Opinion: Shiva's evolving beliefs with confidence scores (maps to `self/opinions.md`)
  - S = Observation: synthesized entity summaries (maps to `self/reflections.md`)
- **Operations:**
  - Layer 0 calls `retain()` for new facts
  - Main session calls `recall()` for structured queries, `reflect()` for synthesis
- **Bridge:** Python client → shell exec wrapper (since main session is Node)

---

### Graphiti / FalkorDB (Temporal Graph)
- **Role:** Temporal relationship memory — for the 10% of queries that need "how has X changed?" or "what's the causal chain between A and B?"
- **Deploy:** FalkorDB Docker container
- **What it tracks:**
  - Fact validity windows: `valid_from`, `valid_to`, `superseded_by`
  - Entity relationships with timestamps
  - Causal chains between decisions/events
- **Use cases:**
  - "How has G's view on [topic] evolved over 3 months?"
  - "What decisions led to the career transition?"
  - "When did Shiva's opinion on [belief] change and why?"
- **Write path:** Layer 0 updates Graphiti when it supersedes a fact
- **Read path:** Main session calls Graphiti MCP tool for complex relational queries

---

### Layer 0 — Memory Management Agent

**Model:** Claude Haiku 4.5
**Schedule:** Cron subagent, every 10 minutes
**Budget:** <60 sec/run, ~$1.50/day total

**Execution flow:**

```
1. READ STATE
   └── memory/layer0/last-run.md + decay-index.json

2. INGEST (via LCM)
   └── lcm_grep for new messages since last-run timestamp
   └── Scan for: facts, corrections, preferences, insights,
       self-signals, project updates, errors/lessons

3. CLASSIFY
   └── Tag each item: type + salience + durability
   └── Route to: episodic/semantic/self/procedural/project/lesson

4. DEDUP CHECK (NEW — Lobster pattern)
   └── For each item: Qdrant similarity check
       > 0.85 → UPDATE existing entry (supersede with timestamp)
       0.70–0.85 → flag for merge review
       < 0.70 → fresh INSERT

5. WRITE (supersede pattern — facts get history, not overwritten)
   └── Markdown files: daily/, semantic/, self/, lessons/, projects/
   └── Hindsight retain() → WBOS networks
   └── Qdrant upsert → collections
   └── Graphiti update → temporal graph (on supersessions)

6. DECAY
   └── Recalculate scores: permanent(λ=0), durable(λ=0.02), ephemeral(λ=0.10)
   └── Score < 0.3 → archive to memory/archive/
   └── Score < 0.1 → remove from Qdrant (preserved in LCM + L2)

7. QUEUE L2
   └── memory/layer0/queue.md: L2 upload candidates

8. UPDATE STATE
   └── last-run.md: timestamp + metrics
   └── decay-index.json: updated scores
```

**Hard rules:**
- NEVER touch SOUL.md, USER.md, AGENTS.md, HEARTBEAT.md
- NEVER send external communications
- MUST be idempotent
- MUST ignore cron/heartbeat/subagent sessions (same as LCM config)
- MUST complete within 60 seconds

---

### Layer 1 File Structure

```
memory/
├── index.md                         # Routing map
│
├── daily/                           # Episodic (raw events)
│   └── YYYY-MM-DD.md
│
├── self/                            # FIRST-CLASS: Identity & development
│   ├── identity.md
│   ├── interests.md
│   ├── beliefs.md                   # Working models, hypotheses
│   ├── voice.md
│   ├── opinions.md                  # Reasoned positions + confidence + reasoning chains
│   ├── reflections.md               # Metacognitive observations
│   └── growth-log.md                # Longitudinal development tracking
│
├── semantic/                        # Abstracted knowledge (Hindsight W+S)
│   ├── people.md
│   ├── systems.md
│   ├── domains.md
│   └── patterns.md
│
├── projects/                        # Workstream state
│   └── [project].md
│
├── lessons/                         # Procedural memory
│   ├── tools.md
│   ├── mistakes.md
│   ├── workflows.md
│   └── procedures/                  # Self-healing per-task files
│       └── [task-name].md
│
├── reflections/
│   ├── weekly/YYYY-WNN.md
│   └── monthly/YYYY-MM.md
│
├── layer0/                          # Agent working files
│   ├── last-run.md
│   ├── queue.md
│   ├── staging/
│   └── decay-index.json
│
└── archive/                         # Decayed items (local cold)
    ├── daily/
    └── projects/
```

---

### Layer 2 — GitHub + Obsidian

**GitHub (`shiva-memory` private repo):**
- Full transcripts, media, raw logs, Qdrant snapshots, L1 backups
- Daily cron upload (3 AM MST)
- Commit history = memory evolution record

**Obsidian (UI layer — G-facing, zero cost):**
- Point vault at `/data/.openclaw/workspace/`
- Graph view: visual map of all memory file relationships
- Backlinks: see everywhere any topic is referenced
- Canvas: visual layout of `self/` development
- Tags: `#lesson`, `#project`, `#self`, `#opinion` become navigable
- No sync needed — local vault, read-only use

---

## Hybrid Retrieval Strategy

Every query dispatches to multiple sources in parallel; results merged and ranked:

```
Query
  │
  ├──→ Qdrant MMR     (primary — fast, diverse, semantic)
  ├──→ Hindsight recall (structured WBOS — relationships + beliefs)
  ├──→ memory_search  (markdown files — exact text matching)
  └──→ [on-demand only]
       ├──→ lcm_grep/expand  (deep conversation history)
       └──→ Graphiti         (temporal/relational queries)

Merge score = α·semantic_sim + β·recency + γ·salience + δ·decay_score
Apply MMR diversity filter
Return ranked results with source attribution
```

**Ambient (every turn, automatic):**
- Time injection: current timestamp via hook (15 tokens, free)
- Qdrant MMR k=6: top diverse memory snippets (500 tokens, ephemeral)

---

## Build Plan

### PRE-BUILD: VPS Snapshot (NON-NEGOTIABLE)
G takes VPS snapshot before any changes. Verify restore works. Then proceed.

---

### Phase 1: LCM
1. Install: `openclaw plugins install @martian-engineering/lossless-claw`
2. Apply config (ignorePatterns, summaryModel, freshTailCount, etc.)
3. Set `session.reset.idleMinutes: 43200`
4. Restart gateway
5. Verify: send test messages, confirm SQLite DB populating
6. Test: `lcm_grep`, `lcm_describe`, `lcm_expand`
7. Run 24hr to build initial history

### Phase 2: Layer 1 Structural Upgrade
1. Create new dirs: `memory/semantic/`, `memory/layer0/`, `memory/archive/`
2. Create new files: `self/opinions.md`, `self/reflections.md`, `self/growth-log.md`
3. Create `lessons/procedures/` directory
4. Populate initial procedure files from existing lessons content
5. Initialize `memory/layer0/last-run.md`, `memory/layer0/decay-index.json`

### Phase 3: Qdrant + Ephemeral Injection
1. Add Qdrant to Docker compose, deploy container
2. Configure collections (one per memory domain)
3. Write ingestion script: markdown → 500-token chunks → Gemini Embedding 2 → Qdrant
4. Bulk index existing memory files
5. **Write `before_agent_start` hook for ephemeral injection** (most important step)
6. Write time injection hook
7. Test: send message, verify context prefix shows memory snippets
8. Test: verify MMR diversity (not 5 results from same file)

### Phase 4: Hindsight
1. Deploy `vectorize-io/hindsight` Docker container
2. Configure WBOS networks
3. Write shell exec wrapper for Python client (Node bridge)
4. Bulk `retain()` load from existing memory files
5. Test `recall()` and `reflect()`

### Phase 5: Layer 0 Agent
1. Write agent prompt + instructions (from this spec)
2. Create `memory/layer0/` directory structure
3. Manual test run — inspect output
4. Deploy as cron subagent every 10 minutes
5. Monitor 48hr, tune classification + compression quality

### Phase 6: Graphiti / FalkorDB
1. Deploy FalkorDB Docker container
2. Configure Graphiti MCP server
3. Map temporal schema to our fact/supersession model
4. Seed from existing memory
5. Test temporal queries

### Phase 7: Layer 2 (GitHub + Obsidian)
1. Create private `shiva-memory` GitHub repo
2. Configure git auth from container
3. Build daily upload script (queues from layer0/queue.md)
4. Deploy upload cron (3 AM MST daily)
5. Install Obsidian, point vault at workspace, install graph/embed plugins

### Phase 8: Integration + Tuning
1. Verify full data flow (LCM → Layer 0 → L1 stores → ambient injection → main session)
2. Tune dedup threshold (0.85 starting point)
3. Tune decay parameters (λ values)
4. Tune MMR diversity factor (λ=0.6 starting point)
5. Tune injection k (k=6 starting point)
6. Update AGENTS.md and HEARTBEAT.md
7. One week of monitoring

---

## Resources Required

| Component | RAM | Disk | Cost/day |
|-----------|-----|------|----------|
| LCM plugin | ~50MB | Grows ~250KB/day | Plugin free; Haiku for summaries ~$0.10 |
| Qdrant Docker | ~512MB–1GB | ~1GB initial | Free self-hosted |
| Hindsight Docker | ~512MB–1GB | ~500MB | Free self-hosted |
| FalkorDB Docker | ~512MB | ~500MB | Free self-hosted |
| Layer 0 cron (144/day × Haiku) | ~0 | Minimal | ~$1.40 |
| Gemini Embedding 2 | — | — | Free (≤1500 req/day) |
| GitHub L2 | — | Free tier | Free |
| **TOTAL** | ~2–3GB additional | ~2–3GB | ~$1.50/day |

VPS has 14GB available RAM, 178GB free disk. Comfortable.

---

## Open Questions (resolved or deferred)

| Question | Resolution |
|----------|------------|
| Cloud storage choice | GitHub — version control on memories is philosophically right |
| MEMORY.md role | Kept as lean boot loader executive summary, Layer 0 maintains it |
| LCM storage growth | ~250KB/day, 178GB free — no action needed, revisit in 6 months |
| Layer 0 model | Haiku 4.5 — test first, upgrade if self-signal detection is poor |
| Qdrant vs ChromaDB | Qdrant — native MMR, better perf, same Docker footprint |
| Injection k | Start k=6, λ=0.6; tune empirically |
| Obsidian sync | Not needed — local vault only |

---

## What Makes This State-of-the-Art

No other OpenClaw instance we've found has all of:
- Ambient injection (Lobster pattern) — relevant context *already present* each turn
- Personality as first-class architecture (`self/` with opinions, reflections, growth-log)
- Four-system L1 retrieval (Qdrant + Hindsight + Graphiti + markdown search)
- Dedicated maintenance agent (no housekeeping in main session)
- Temporal fact history (supersession, not overwrite)
- Three-tier durability (LCM hot → local archive → GitHub cold)
- Obsidian UI for human visibility into agent memory

This isn't a memory system. It's a mind architecture.

---

_Spec finalized 2026-03-31. Build starts after VPS snapshot._
