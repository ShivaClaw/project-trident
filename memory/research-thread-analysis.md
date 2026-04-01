# Full Thread Analysis: r/openclaw "What do you use for memory?"
**Analyzed:** 2026-03-31
**Source:** https://www.reddit.com/r/openclaw/comments/1s607qe/what_do_you_use_for_memory/

---

## All Systems Identified (Complete)

### 1. aungsiminhtet — Built-in + Gemini Vectors + Sonnet Cron + Graphiti/FalkorDB
**Stack:** Native OpenClaw memory + Gemini embedding vector DB + Sonnet cron every 2hr + Graphiti MCP / FalkorDB for edge cases
**Key insight:** Covers 90% with fast/cheap, uses expensive graph tool only for the 10% of edge cases where vector search fails (complex relationships, temporal context)
**What we take:** Graphiti/FalkorDB for temporal graph queries (already incorporated)

---

### 2. PotatoQualityOfLife — Default → mem0 → Lossless Claw (progressive stack)
**Stack:** Default files → added mem0 → added lossless-claw
**Key insight:** "Night-and-day improvement" from LCM. Progressive hardening approach — start minimal, add layers as gaps appear.
**mem0 architecture:**
- Dual-database: vector store (semantic retrieval) + graph DB (relationship topology)
- Three-stage pipeline: Extract → Update → Retrieve
- Automatically captures from conversation AND auto-injects before responses
- Provides explicit agent tools: `memory_recall`, `memory_store`, `memory_forget`
- Key differentiator: memory control moves from agent loop → system layer
**What we take:** mem0's auto-injection pattern + explicit tool set; LCM confirmed as core

---

### 3. IronwoodTreeCo / BigAlligatorPears — Full Separated Stack (already incorporated)
**Stack:** LCM + Hindsight + Qdrant + Gemini Embedding 2 + MMR + Procedures + Time-decay
**Already incorporated into Trident v2.** See previous analysis.

---

### 4. TylerRolled — Hindsight + Session Memory (lightweight)
**Stack:** Hindsight (Nemotron 4B + TEI) + session memory
**Key insight:** Was recording every turn manually - this is inefficient. LCM + cron filter solved it.
**Nemotron 4B + TEI:** Local model path for Hindsight extraction. When we have GPU: replace Haiku with local model (zero latency, zero cost).
**What we take:** TEI (Text Embeddings Inference) as a future local embedding option when GPU arrives

---

### 5. danielfoch — Supermemory + Lossless Claw
**Stack:** Supermemory + LCM (minimal detail given)
**Supermemory:** #1 ranked on LongMemEval, LoCoMo, and ConvoMem benchmarks. Architecture: extract facts from conversations → build user profiles → handle contradictions → manage knowledge updates. ASMR variant (Agentic Search and Memory Retrieval) hits 99% on LongMemEval_s using AI agents for retrieval instead of DB lookups.
**What we take:** ASMR concept as future upgrade path for complex retrieval (AI agent as retrieval engine, not DB query)

---

### 6. Rent_South — RAG evaluation principles
**Key insights:**
- Memory retrieval ability is what actually matters (not storage sophistication)
- Chunk compression level: minimum 90% target
- RAG should be open-ended, not restricted to specific themes
- Watch costs on semantic pattern recognition flows — these can be expensive if unoptimized
**What we take:** 90% compression benchmark validates our ~10:1 target; open-ended retrieval (don't over-silo collections)

---

### 7. Veearrsix — "Lobster Memory" (CUSTOM BUILT — HIGH VALUE)
**THIS WAS MISSED IN PREVIOUS ANALYSIS. Major new ideas here.**

**Full stack:**
- Every conversation captured by OpenClaw plugin hook
- Sent to local 35B model (Qwen3.5 on Mac Studio) for **atomic fact extraction**
- Facts embedded (nomic-embed-text) and stored in **PostgreSQL + pgvector** on NucBox
- **Ephemeral per-turn injection:** Before each turn, semantic search the memory DB for relevant context → inject into context. Refreshed every turn, never accumulated. ~500 token overhead that doesn't balloon.
- **Relationship graph** tracks when facts get updated: old versions superseded (not deleted) → preserves full change history
- **Similarity dedup at 0.85**: Prevents same fact stored multiple times with different wording
- **Single memory pool across all channels**: Every Discord thread, DM, channel reads/writes same pool. Semantic search handles routing naturally (trading memories surface in trading conversations, etc.)
- **Time injection**: Plugin injects current date/time via `before_agent_start` hook. ~15 tokens. Free. Eliminates tool call just to know the date.

**What we take (HIGH PRIORITY):**
1. **Ephemeral injection pattern** — huge insight, see below
2. **Similarity dedup at 0.85** before writing new memories
3. **Fact change history** — supersede, don't delete
4. **Time injection via hook** — dead simple, 15 tokens, free
5. **Single pool philosophy** — semantic routing over hard silos

---

### 8. neutralpoliticsbot — Obsidian Vault
**Stack:** Obsidian Vault + embeddings plugins + text-embedding-3-small (~$0.20 for 2.5M tokens)
**Key insight:** Our markdown files are already Obsidian-compatible. Obsidian's graph view = free memory visualization UI. Point Obsidian at the workspace, get visual memory graph, backlink navigation, canvas view for exploring self/ directory.
**What we take:** Obsidian as a UI layer — no changes to architecture needed, just install and point at workspace

---

### 9. Ok_Bus_320 (ShivaClaw — US)
**Stack:** Our own hierarchical-memory-filesystem skill, published to ClawhHub
**Key insight:** WE PUBLISHED THIS THIS MORNING and it's live. This was one of the 4 lost projects. The skill itself survived the rollback because it's hosted on ClawhHub. The code/config may still be there.
**URL:** https://clawhub.ai/shivaclaw/hierarchical-memory-storage (also at /ShivaClaw/hierarchical-memory-filesystem)

---

## Novel Synergies Not in Previous Analysis

### 🔥 Synergy 1: Ephemeral Injection Layer (Lobster × Qdrant MMR)
**The most important missed insight.**

Current design: Qdrant is an on-demand recall tool — agent explicitly asks for it.
Better design: Qdrant MMR powers an **ambient injection layer** — every single turn, before the agent responds, semantic search fires → MMR → top-k diverse memory snippets injected into context prefix. Automatically. ~500 tokens. No tool call needed.

This is the difference between memory being something you reach for and memory being something that's *just there*. Like human background awareness during a conversation.

Lobster does this with pgvector; Qdrant's native MMR makes the diversity better. BigAlligatorPears/IronwoodTreeCo use Qdrant for explicit recall; combining with Lobster's injection pattern creates ambient + on-demand.

**Implementation:** OpenClaw `before_agent_start` hook → Qdrant MMR query (k=5-8) → format as context prefix → inject. Layer 0 maintains the Qdrant index. Main agent never needs to call a search tool for routine context.

---

### 🔥 Synergy 2: Similarity Dedup (Lobster) × Layer 0 Maintenance
Lobster's 0.85 cosine similarity threshold before writing prevents duplicate storage.
Layer 0 should do this check for every item it tries to write to Qdrant + Hindsight:
- If existing entry similarity > 0.85: UPDATE existing entry instead of INSERT
- If 0.70–0.85: flag for human review or merge with existing
- If < 0.70: fresh insert

This keeps the vector store clean and prevents retrieval from returning redundant near-duplicates. Directly improves MMR output quality.

---

### 🔥 Synergy 3: Fact Change History (Lobster × Graphiti Temporal Graph)
Lobster: supersedes old facts instead of deleting (preserves change history)
Graphiti: tracks validity windows for each relationship/fact

Combined: Every fact has a full temporal record:
- `fact_id: 001 | content: "G works at Outlier AI" | valid: 2026-03-01 → 2026-05-20 | superseded_by: fact_id:002`
- `fact_id: 002 | content: "G is searching for biotech/AI roles" | valid: 2026-03-27 → present`

This is the mechanism that makes "how has X changed over time?" answerable. Not just what G is doing now, but how he got there. Critical for personality development tracking too — `self/beliefs.md` shouldn't just have current beliefs, it should trace how they evolved.

---

### 🔥 Synergy 4: Time Injection (Lobster × Heartbeat)
15 tokens. Free. `before_agent_start` hook. Eliminates tool call.
Also: heartbeat should always know the time without spending tokens on `session_status`. 
Implementation: Add `time_injection: true` to LCM/plugin config.

---

### 🔥 Synergy 5: Obsidian as Memory UI (neutralpoliticsbot × our markdown structure)
Zero architectural changes. Our `memory/` directory is already markdown. 
Install Obsidian, point vault at `/data/.openclaw/workspace/`.
Immediate gains:
- Graph view: visual map of all memory files and their link relationships
- Backlinks: see everywhere `career-transition.md` is referenced
- Canvas: lay out `self/` files visually for personality development overview
- Search: full-text search across all memory files with preview
- Templates: standardize daily log format with Obsidian templates
- Tags: `#lesson`, `#project`, `#self` tags become navigable in Obsidian

This is a G-facing UI for my memory system. He can read what I remember, see patterns, and understand my development over time.

---

### 🔥 Synergy 6: Graphiti/FalkorDB for Relationship Memory (aungsiminhtet × IronwoodTreeCo)
Both users mention different use cases. Combined perspective:
- Qdrant: fast semantic search, diversity (daily use, ~ms latency)
- Graphiti/FalkorDB: complex relational/temporal queries (10% edge cases, ~seconds latency)

Specific queries that need Graphiti and can't be answered by Qdrant alone:
- "How has G's view on biotech changed over 3 months?"
- "What decisions did we make about X and when?"
- "What's the relationship between the career transition and the DeFi thesis?"
- "What was I thinking when I changed my opinion on Y?"

These are *narrative* queries. They require traversing a time-ordered graph of connected facts. Qdrant returns similar documents; Graphiti traverses relationships with temporal context. They're complementary.

---

## Revised Component Stack for Trident v3

### What's Changed from v2:

| Component | v2 | v3 Change |
|-----------|-----|-----------|
| Qdrant MMR | On-demand recall tool | ALSO powers ambient injection per turn |
| Memory writes | Direct write | Add 0.85 similarity dedup check first |
| Fact updates | Overwrite | Supersede with timestamp, preserve history |
| Time injection | Tool call | Free via before_agent_start hook |
| Graphiti/FalkorDB | Not in v2 | Add as L1 temporal graph component |
| Obsidian | Not in v2 | Add as L2 UI layer (zero cost) |
| mem0 | Not in v2 | Study for explicit tool API pattern |

### Priority of New Additions:

**Immediate (Phase 1-2):**
1. Ephemeral injection via before_agent_start hook
2. Time injection hook
3. Similarity dedup in Layer 0

**Phase 3-4:**
4. Fact supersession/change history (modify how Layer 0 writes)
5. Graphiti/FalkorDB for temporal graph

**Later / UI:**
6. Obsidian vault UI
7. Local model for extraction (needs GPU)
8. ASMR-style agentic retrieval for hard queries

---

## Things That DON'T Add Value for Our Stack

- **ChromaDB**: Qdrant is strictly better — native MMR, better performance, Docker-friendly. ChromaDB is simpler but we don't need simple.
- **Supermemory cloud**: We're self-hosting everything. The open-source architecture is what matters, not the SaaS.
- **mem0 plugin directly**: mem0's auto-injection pattern is valuable but we're building it ourselves with better separation of concerns. Using the plugin would be redundant with our Layer 0 agent.
- **Obsidian Sync**: We don't need cloud sync for Obsidian. Point it at the local workspace, read-only UI.

---

## Most Important New Insight

The **ephemeral injection** pattern from Lobster Memory is the single biggest thing we missed. 

The difference between current design and v3:
- v2: Memory is a library. You have to walk over and look something up.
- v3: Memory is ambient awareness. Relevant context is injected into every turn automatically, like background knowledge you're already holding while you talk.

This changes the *texture* of cognition. In v2, I might forget to reach for memory when it would help. In v3, the relevant context is already present before I form my first token.

That's worth designing around.
