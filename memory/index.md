# Memory Index

This is the routing map for Shiva's memory system.

## Purpose

Memory should support four functions:
- capture raw events cheaply
- compress them into durable abstractions
- retrieve relevant context quickly
- shape a coherent self over time

## Where things go

### `MEMORY.md`
High-signal long-term memory only.
Use for:
- durable facts about G
- stable preferences
- standing rules/agreements
- persistent project context
- major life transitions
- important lessons that remain true over time

Do **not** use it as a daily journal or task dump.

### `memory/daily/YYYY-MM-DD.md`
Raw episodic log.
Use for:
- what happened
- what was asked
- notable outputs
- observations worth maybe keeping
- unresolved threads

This is the inbox layer.

### `memory/projects/*.md`
State tracking for ongoing workstreams.
Each file should track:
- objective
- current state
- recent decisions
- constraints
- next steps
- unresolved questions

### `memory/self/*.md`
Self-model and personality development.
- `identity.md` → role, identity, self-concept
- `interests.md` → recurring curiosities and obsessions
- `beliefs.md` → working models, hypotheses, worldview shifts
- `voice.md` → communication style, tone, what feels authentic

### `memory/lessons/*.md`
Operational doctrine.
- `tools.md` → tool quirks and capabilities
- `mistakes.md` → recurring failures and corrections
- `workflows.md` → reliable patterns and procedures

### `memory/reflections/weekly/*.md`
Weekly consolidation.
Use for:
- what changed
- what mattered
- what should persist
- what should be forgotten
- where identity/interests shifted

### `memory/reflections/monthly/*.md`
Monthly synthesis.
Use for:
- long-arc patterns
- major changes in projects or identity
- strategic direction
- important promotions into `MEMORY.md`

## Core rules

1. No important insight stays only in a daily file.
2. If it matters, promote it into one of:
   - `MEMORY.md`
   - `memory/projects/`
   - `memory/self/`
   - `memory/lessons/`
3. Reflection files are for consolidation, not raw logging.
4. Keep long-term memory compressed and high-signal.

## Active files to review routinely

- `MEMORY.md`
- `memory/daily/` (recent)
- `memory/projects/`
- `memory/self/`
- `memory/lessons/`
- `memory/reflections/weekly/`
