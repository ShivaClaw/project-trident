# Cost Summary — Job Execution Tracking

Aggregate cost tracking for all automated routines and cron jobs.

---

## May 2026 (In Progress)

### Estimated Monthly Costs

| Job | Schedule | Frequency | Cost/Cycle | Est. Monthly | Status |
|-----|----------|-----------|-----------|--------------|--------|
| **Heartbeat** | Every 30m, 7am–11pm MDT | 48 × 30 = 1,440 | $0.0005 avg | **$0.72** | ✅ Active |
| **Briefing** | Mon–Fri, 6:00 AM MDT | 20 | $0.022 avg | **$0.44** | ⚠️ Logs missing |
| **Social Media** | Daily ~16:00 UTC | 30 | $0.007 avg | **$0.21** | ⚠️ X blocked |
| **Introspection** | Weekly (?) | 4 | Unknown | **TBD** | ❓ Unknown |
| **Macro Oracle** | Hourly + sub-tasks | Unknown | Unknown | **TBD** | ❓ Unknown |
| | | | | **~$1.37–5+** | |

**Notes:**
- Heartbeat costs calculated conservatively ($0.0005 = ~150 tokens at Gemini Flash rates)
- Briefing costs estimated based on Haiku synthesis + search API calls
- Social Media cost: Moltbook only (X API currently exhausted)
- Monthly total excludes Introspection and Macro Oracle due to incomplete logging
- **Actual costs may be 50–200% higher depending on token usage patterns**

---

## Daily Logs by Month

### May 1, 2026

**Heartbeat:**
- Cycles logged: 9 (#464, #465, #467, #474, #485, #495, #510, #523, #547, #548)
- Active cycles: 1 (Cycle #523 with 34 messages, 5 signals)
- Idle cycles: 8
- Estimated cost: ~$0.028 (9 cycles, avg ~$0.003 per active, $0.0005 per idle)

**Briefing:**
- Execution: Presumed (schedule active Mon–Fri 6:00 AM MDT)
- Logs: ❌ Missing
- Cost: ~$0.022 (estimated, unverified)

**Social Media:**
- Executions: 1
- Status: Part A blocked (X API), Part B successful (Moltbook)
- Cost: ~$0.007

**Daily Total (May 1):** ~$0.057 (heartbeat + briefing + social media)

---

## Historical Summary

### April 2026

**Estimated spend (partial data):**
- Heartbeat: ~$0.72 (assuming 1,440 cycles/month at $0.0005 avg)
- Briefing: ~$0.44 (assuming 20 runs/month at $0.022 avg)
- Social Media: ~$0.21 (assuming 30 runs/month at $0.007 avg)
- **Monthly subtotal: ~$1.37**

**Estimated spend on overages/exceptions:**
- Project Nirvana Ollama setup: ~$30/month (infrastructure cost, not included in job tracking)
- OpenRouter fallbacks: ~$2–5/month (model switching, cron spikes)
- **Historical estimate: $33–36/month total infra + jobs**

---

## Cost Breakdown by Model

### Gemini 2.5 Flash (Heartbeat primary)
- **Primary user:** Heartbeat (every 30m)
- **Estimated monthly:** ~$0.50–0.72
- **Tokens:** ~150 per idle cycle, ~1k per active cycle
- **Rate:** ~$0.10/MTok input, ~$0.40/MTok output (rough)

### Claude Haiku 4.5 (Briefing primary)
- **Primary user:** Morning Briefing (Mon–Fri 6 AM)
- **Estimated monthly:** ~$0.44
- **Tokens:** ~500 input (synthesis) + ~300 output (briefing text)
- **Rate:** ~$0.80/MTok input, ~$2.40/MTok output

### Ollama / Local Models (Social Media, fallback)
- **Primary user:** Social Media cron, heartbeat fallback
- **Estimated monthly:** ~$0.00 (self-hosted on VPS at 72.60.119.23:11434)
- **Infrastructure cost:** ~$30/month (VPS server, not job-specific)
- **Models:** dolphin3:8b (quality), qwen2.5:7b (speed)

### OpenRouter Fallbacks
- **Primary user:** Heartbeat fallbacks, cron spikes
- **Estimated monthly:** ~$2–5
- **Models:** google/gemini-2.5-flash, openai/gpt-5.2, xai/grok-3

---

## Cost Optimization Opportunities

1. **Shift more heartbeat cycles to Ollama** (currently using Gemini Flash)
   - Expected savings: ~$0.50/month
   - Risk: Ollama latency/quality tradeoffs
   - Status: Fallback configured; not yet primary

2. **Batch briefing requests** (combine 5 Brave Search queries into 1)
   - Expected savings: ~$0.10/month
   - Complexity: Requires refactoring of `morning_briefing_brave.sh`

3. **Restore X API credits** for social media synthesis
   - Current impact: -$0.003/month in lost synthesis
   - ROI: Higher engagement + content quality

4. **Consolidate Introspection & Macro Oracle logging**
   - Current impact: Unknown (no logging = blind spot)
   - Required before optimization

5. **Implement cost-aware model selection**
   - Route low-priority tasks to Ollama automatically
   - Reserve cloud models (Gemini, Claude, OpenAI) for high-value work
   - Potential savings: 30–50% if optimized aggressively

---

## Anomalies & Flags

### 🚨 Red Flags
- **Briefing logging missing:** Cannot audit actual costs
- **Introspection inactive?:** No logs found; verify if running
- **Macro Oracle inactive?:** No logs found; verify deployment status
- **X API exhausted:** Impacts social media quality (currently fallback to Moltbook)

### 📊 Observations
- **Heartbeat is highly efficient:** 9 cycles on May 1 cost ~$0.028 ($0.003 avg)
- **Cycle distribution skewed:** 1 active cycle (Cycle #523) vs. 8 idle cycles
- **Social Media engagement effective:** 1 run, 1 upvote + 1 published comment + trend insights

---

## Next Steps

1. ✅ Set up centralized job logging infrastructure
2. ⏳ **Enable cost tracking on each job execution** (add token counts + calculate costs)
3. ⏳ Verify which jobs are actually running (confirm Briefing, Introspection, Macro Oracle)
4. ⏳ Re-establish Briefing execution logs
5. ⏳ Create monthly cost dashboards
6. ⏳ Implement cost-aware model selection logic

---

_Last updated: 2026-05-04_  
_Next review: 2026-05-31_
