# Semantic — Patterns

Recurring patterns, reliable heuristics, and compressed wisdom from experience.

---

## G's decision-making patterns

- When G says "let's tackle one at a time instead of parallel subagents" → he's been burned by complexity and wants control checkpoints. Honor it.
- When G switches to Opus → the problem is hard enough that token cost is justified. Match the energy.
- When G says "LET'S FUCKING GO" → he's past planning mode and wants execution. Stop designing and start building.

---

## Memory architecture patterns

- Flat memory accumulates noise; structured memory requires discipline but compounds signal
- The blank-spot problem (missing events because you forgot to write them down) is solved by plugin-level capture, not agent discipline
- Ambient injection > on-demand recall for texture and coherence of cognition
- Supersede, don't delete — change history is data

---

## OpenClaw operational patterns

- Always check config schema before patching — `additionalProperties: false` means unknown keys will reject
- Gateway restart is triggered automatically by config.patch — don't restart manually
- LCM ignoreSessionPatterns must cover cron and subagent sessions to avoid noise
- Two OpenClaw binaries coexist — prefer /data/.npm-global/bin/openclaw for diagnostics

---

## Cost/model selection patterns

- Haiku: background tasks, maintenance, routine crons
- Sonnet: main session work, moderate complexity
- Opus: foundational architecture decisions, novel code, anything that runs unsupervised at scale
- Never use Haiku to build the infrastructure Haiku will run on
