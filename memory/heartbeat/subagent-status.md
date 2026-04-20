# Heartbeat: Subagent Lifecycle Management

## Running Agents (Layer 0 Heartbeat Checks)

Check every 15 minutes via `subagents list`:

### [Agent Name / Session ID]
- **Status:** [running/idle/waiting/completed/error]
- **Model:** [model name]
- **Task:** [brief description]
- **Last activity:** [timestamp]
- **Duration idle:** [minutes] 
- **Action:** [none/steer/kill with reason]

---

## Kill Criteria

Remove agents matching any of:
- ✓ Completed task (last message shows "done", "finished", "complete")
- ✓ Stuck task (last message >30 min old, no new activity)
- ✓ Redundant task (2+ agents doing same work)
- ✓ Over-provisioned (Sonnet on simple task, >30 min idle)

---

## Model Optimization Opportunities

### Steers Recommended
- [ ] Sonnet → Haiku (simple tasks: file ops, template rendering, data cleaning)
- [ ] Haiku → Sonnet (complex reasoning: analysis, debugging, design decisions)

### Consolidation Opportunities
- [ ] Agent X and Agent Y doing same task → kill redundant, absorb into primary

---

## Archive

Log all kill/steer actions with timestamp and reason to Layer 0 daily log.
