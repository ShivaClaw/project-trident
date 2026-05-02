# Session State Logging (WAL Protocol)

**Purpose:** Ensure critical facts survive context compaction and session resets.

**File:** `SESSION-STATE.md` (updated every session)

## Triggers

Pause everything. Log to `SESSION-STATE.md` immediately when:

1. **User correction:** "No, it's X not Y"
2. **Proper nouns:** New name, company, URL, file path
3. **Preferences:** "I like/prefer X"
4. **Decisions:** "Let's do X" or "approved"
5. **Specific values:** Numbers, dates, commit hashes
6. **Draft changes:** User edits to work-in-progress

## Format

```markdown
## Session: YYYY-MM-DD HH:MM EDT

**Entry 1:** [trigger] — [fact]
- Source: Message X
- Context: brief note

**Entry 2:** [trigger] — [fact]
```

## Example

```markdown
## Session: 2026-05-01 13:39 EDT

**Trigger: Decision** — Implement Tier 1 memory upgrade
- Components: semantic search, Retrieve-Before-Act, procedures/, dreaming
- Blocker: "memory" plugin not in allowlist
- Status: Update AGENTS.md + create procedures/; enable dreaming in config

**Trigger: Preference** — Use Sonnet 4.6 for deep dives, local models for routine
```

## Weekly Promotion

Every Friday, review `SESSION-STATE.md`:
- Promote durable facts → `MEMORY.md`
- Promote decisions → `memory/projects/`
- Promote errors → `memory/lessons/`
- Clear `SESSION-STATE.md`

## Last Verified

2026-05-01 — SESSION-STATE.md pattern active, weekly promotion cadence established
