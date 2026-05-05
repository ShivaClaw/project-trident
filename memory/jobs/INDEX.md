# Job Execution Logs — Centralized Index

This directory contains standardized execution logs for all automated routines and cron jobs.

## Directory Structure

```
memory/jobs/
├── INDEX.md                    (this file)
├── MANIFEST.md                 (overview of all active jobs + schedules)
├── heartbeat/                  (every 30m, 7 AM–11 PM MDT)
├── briefing/                   (Mon–Fri, 6:00 AM MDT)
├── social-media/               (cron-triggered, ~16:00 UTC)
├── introspection/              (weekly, schedule TBD)
├── macro-oracle/               (hourly orchestration + sub-tasks)
└── cost-summary.md             (monthly aggregate cost tracking)
```

## Log Format (Per Job)

Each job subdirectory contains dated execution logs:

```
YYYY-MM-DD.md
├── Job Name: [name]
├── Scheduled Time: [time]
├── Actual Start/End: [timestamps]
├── Duration: [seconds]
├── Primary Model: [model]
├── Fallback Models: [model1, model2]
├── Tasks Executed:
│   - Task 1: [status] ([duration])
│   - Task 2: [status] ([duration])
├── Tokens Used:
│   - Input: [count]
│   - Output: [count]
├── Cost Estimate: $[amount]
├── Results: [summary of outcomes]
└── Errors/Blockers: [if any]
```

## Active Jobs (Current Configuration)

| Job | Schedule | Model(s) | Typical Cost | Status |
|-----|----------|----------|--------------|--------|
| **Heartbeat** | Every 30m, 7 AM–11 PM MDT | Gemini 2.5 Flash (Ollama qwen2.5:7b fallback) | $0.002–0.005 | ✅ Active |
| **Morning Briefing** | Mon–Fri 6:00 AM MDT | Haiku 4.5 | $0.015–0.030 | ✅ Active |
| **Social Media** | Cron ~16:00 UTC | Ollama (X/Moltbook calls) | $0.005–0.010 | ⚠️ X API exhausted |
| **Weekly Introspection** | TBD | Unknown | TBD | ? Unclear |
| **Macro Oracle** | Hourly + sub-tasks | Internal logic | Depends on data | ? Unclear |

## Cost Aggregation

Monthly summaries are recorded in `cost-summary.md`:
- Per-job costs (primary + fallback)
- Total spend by model provider
- Efficiency metrics (tokens per dollar)
- Anomalies and optimization opportunities

## Logging Protocol

**When:** After each job execution (automated or manual)  
**What:** Use the template above; include all fields  
**Where:** Append to `memory/jobs/[job-type]/YYYY-MM-DD.md`  
**Format:** Markdown (parseable, human-readable)

## Example Entry

```markdown
## Heartbeat Cycle #523 (17:38 UTC / 11:38 MDT)

- **Job Name:** Heartbeat L0 (integrated)
- **Scheduled:** Every 30m
- **Actual Start:** 2026-05-01T17:38:00Z
- **Actual End:** 2026-05-01T17:38:06Z
- **Duration:** 6.2 seconds
- **Primary Model:** google/gemini-2.5-flash
- **Fallback:** ollama/qwen2.5:7b
- **Tasks:**
  - LCM scan: 34 new messages detected (~2.5 seconds)
  - Time-sensitive checks: Job Search Batch 4 status, Outlier AI deadline (~1.2 seconds)
  - Subagent monitor: 0 active, 0 recent (~0.8 seconds)
  - Memory routing: 5 actionable signals classified (~1.7 seconds)
- **Tokens Used:**
  - Input: ~850 tokens
  - Output: ~120 tokens
- **Cost:** ~$0.0035 (Gemini Flash)
- **Results:** 
  - Detected: 34 new messages, 5 actionable signals
  - Routed: Model preference, research direction, technical discovery, session state, infrastructure note
  - Memory files updated: MEMORY.md, SESSION-STATE.md, semantic/* files
- **Errors:** None
```

---

## Next Steps

1. ✅ Create directory structure
2. ⏳ Migrate existing logs from scattered locations
3. ⏳ Set up automated logging on each job execution
4. ⏳ Create monthly cost summaries
5. ⏳ Build cost tracking dashboard (optional)

---

_Last updated: 2026-05-04_
