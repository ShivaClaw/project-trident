# Memory Architecture Research — March 30, 2026

## Executive Summary

Robust AI agent memory systems require:
1. **Layered architecture** (short-term → long-term)
2. **Multiple memory types** (episodic, semantic, procedural)
3. **Consolidation mechanisms** (episodic → semantic abstraction)
4. **Hybrid retrieval** (recency + importance + relevance + semantic search)
5. **Reflection mechanisms** (periodic synthesis of insights)

---

## Core Concepts

### Memory Types

**Episodic Memory**
- Stores specific past experiences, events, and their context (who, what, when, where, how)
- Functions like a "task diary" or detailed journal
- Temporal metadata + event logging
- Enables case-based reasoning, pattern detection, and explainability
- Implementation: timestamped event logs, vector databases for semantic search

**Semantic Memory**
- Stores generalized, structured factual knowledge independent of specific events
- Represents the "knowledge bank" or internal encyclopedia
- Contains definitions, rules, abstract concepts, extracted patterns
- Implementation: knowledge bases, symbolic AI, vector embeddings
- Derived from episodic memories through consolidation

**Procedural Memory**
- Stores skills, rules, and learned behaviors
- Often implicit in model weights or explicit in agent code
- Includes reasoning procedures, retrieval strategies, decision-making patterns

---

## Hierarchical Memory Architecture

**Multi-tiered structure:**
- **Short-term (working memory):** Active processing space for real-time reasoning
  - Holds recent input, retrieved knowledge, current goals
  - Limited capacity (context window)
  - High-fidelity, immediate access
  
- **Medium-term (session memory):** Tracks state across conversation turns
  - Bridges short-term and long-term
  - Manages active tasks, in-progress context
  
- **Long-term memory:** Persistent storage across sessions
  - External to LLM (vector DBs, knowledge bases, document stores)
  - Semantic + episodic + procedural stores
  - Optimized for retrieval efficiency

**Key advantage:** Prevents "context distraction" in long interactions, enables structured semantic navigation

---

## Memory Consolidation

**Purpose:** Transform fragile short-term memories into stable, long-term knowledge

**Process:**
1. Capture raw episodic events in short-term buffer
2. Identify patterns, abstract key insights
3. Compress redundant information
4. Integrate into semantic knowledge base
5. Store compressed semantic abstractions long-term

**Biological parallel:** Hippocampus (fast learning) → Neocortex (slow, stable learning)

**AI techniques:**
- **Experience replay** (RL): Store episodes in buffer, replay for consolidation
- **Summarization & rewriting:** Distill episodic logs into semantic rules
- **Pattern distillation:** Extract recurring themes, principles, relationships
- **Reflection:** Periodic synthesis of memories into higher-level insights

**Example:** Many episodic logs of user behavior → semantic rule like "users who browse X in the morning are 40% more likely to purchase Y within 24 hours"

---

## Generative Agents Architecture (Stanford/Google)

**Core components:**

1. **Memory Stream**
   - Comprehensive long-term record of experiences
   - Stores all perceptual, planning, reflective, and action events
   - Each memory: text + timestamp + salience score
   - Enables long-term coherence

2. **Reflection**
   - Synthesizes clusters of memories into higher-level insights
   - Periodically triggered (e.g., importance threshold)
   - Reflections stored back into memory stream
   - Enables generalization, inference, long-term planning

3. **Retrieval**
   - Scores memories on three dimensions:
     - **Recency:** More recent = more accessible
     - **Importance:** Significant events prioritized
     - **Relevance:** Contextually pertinent to current query
   - Hybrid scoring function combines all three

4. **Consolidation via Reflection**
   - Reflection mechanism *is* the consolidation process
   - Raw episodic memories → abstract semantic insights
   - Manages information overload, improves efficiency

---

## Memory Retrieval Strategies

**Key dimensions:**

1. **Recency**
   - Prioritize recent memories
   - Decay strategies for older, less-relevant info
   - Timestamp-based weighting

2. **Importance (Salience)**
   - Not all memories are equal
   - Critical events prioritized over routine details
   - Can be explicit (scored) or implicit (inferred)

3. **Relevance**
   - Pertinent to current task/query/context
   - Prevents retrieval of semantically similar but unhelpful memories

4. **Semantic Search**
   - Beyond keyword matching
   - Understands meaning, context, relationships, intent
   - Vector embeddings for conceptual similarity
   - Effective for unstructured/episodic memories

**Hybrid retrieval:** Combine all four dimensions into unified scoring function
- Example: `score = α·semantic_similarity + β·recency + γ·importance`
- Vector embeddings + timestamp metadata + salience scores

---

## Write-Ahead Log (WAL) Concept

**Definition:** Record of agent's internal state, thoughts, and planned actions

**Purpose in stateless LLMs:**
- LLMs don't retain memory across API calls
- WAL acts as structured context window
- Ensures continuity across turns
- Tracks execution state, previous attempts, next steps

**Implementation:**
- Persist critical state changes to durable storage *before* proceeding
- If crash/restart occurs, replay log to reconstruct state
- Common in databases, applicable to agent memory

**For AI agents:**
- Working memory writes to log before advancing
- Log becomes feed for next LLM call
- Prevents loss of critical context mid-task

---

## Key Design Principles

1. **Separation of concerns:** Episodic vs. semantic vs. procedural
2. **Compression:** Raw logs → abstracted patterns
3. **Durability:** Write-ahead logging, persistent storage
4. **Retrieval efficiency:** Hybrid scoring (recency + importance + relevance + semantic)
5. **Reflection:** Periodic synthesis of insights
6. **Hierarchical structure:** Short-term ↔ long-term exchange
7. **Context management:** Prevent overload, prioritize signal

---

## Recommended Implementation Patterns

**For persistent agents:**
1. **Daily episodic logs** (raw events, timestamped)
2. **Weekly reflection** (consolidate episodic → semantic)
3. **Monthly synthesis** (high-level patterns, promote to long-term)
4. **Long-term semantic store** (curated, compressed, high-signal)
5. **Hybrid retrieval** (semantic search + recency + importance filters)

**For session-based agents:**
1. **Session state file** (working memory, write-ahead log)
2. **Episodic buffer** (within-session events)
3. **Post-session consolidation** (extract learnings, promote to long-term)

---

## Citations

- Stanford/Google: Generative Agents paper (memory stream + reflection)
- IBM: AI Agent Memory overview
- Hugging Face: Memory in Generative Agents
- Lilian Weng: LLM-Powered Autonomous Agents
- Multiple Medium/Substack deep dives on episodic/semantic/procedural memory

---

**Next steps:**
- Apply these principles to design a 3-tier memory architecture for Shiva
- Define: inbox layer, consolidation pipeline, retrieval strategy
- Specify: file structure, reflection triggers, compression rules
