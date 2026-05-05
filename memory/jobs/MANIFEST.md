# Job Manifest — Active Routines & Schedules

## Overview

This file is the source of truth for what jobs are running, when, and at what cost.

---

## 1. Heartbeat (Every 30 minutes)

**Schedule:** 7:00 AM – 11:00 PM MDT, every 30 minutes  
**Config:** `openclaw.json` → `sessions.main.heartbeat`

| Property | Value |
|----------|-------|
| **Primary Model** | `google/gemini-2.5-flash` |
| **Fallback** | `ollama/qwen2.5:7b` (Ollama VPS: 72.60.119.23:11434) |
| **Isolated Session** | Yes (subagent) |
| **Typical Duration** | 2–7 seconds |
| **Typical Cost** | $0.002–0.005 per cycle |
| **Logs Location** | `memory/jobs/heartbeat/` |

**Tasks:**
- Scan LCM for new messages since last heartbeat
- Check time-sensitive flags (job search status, Outlier AI deadline)
- Monitor active subagents
- Route memory updates to appropriate files
- Report idle or detect actionable signals

**Last Documented Cycle:** 2026-05-01 Cycle #548  
**Status:** ✅ Active and healthy

---

## 2. Morning Briefing

**Schedule:** Monday–Friday, 6:00 AM MDT  
**Config:** `morning_briefing_brave.sh` (bash script, not in openclaw.json as a formal cron)

| Property | Value |
|----------|-------|
| **Primary Model** | `anthropic/claude-haiku-4-5` (inferred) |
| **Fallback** | TBD |
| **Typical Duration** | ~5–10 minutes |
| **Typical Cost** | $0.015–0.030 per run |
| **Logs Location** | `memory/jobs/briefing/` |

**Tasks:**
- Fetch Denver weather (curl wttr.in)
- Brave Search: US/Global macro headlines (5 results)
- Brave Search: Colorado/Denver news (5 results)
- Brave Search: Biotech/Synbio news (5 results)
- Brave Search: Crypto market snapshot (5 results)
- Brave Search: US stock market snapshot (5 results)
- Gmail check (recent/flagged emails)
- Asset snapshot (if enabled)
- Trading positions check (if enabled)
- Delivery to Telegram/Discord/etc.

**Last Documented Run:** Unknown (execution logs missing)  
**Status:** ⚠️ Script exists; no recent execution logs found

---

## 3. Social Media Synthesis & Networking

**Schedule:** Cron-triggered, ~16:00 UTC (10:00 AM EDT / 8:00 AM MDT)  
**Config:** Cron job (details unclear, possibly in gateway)

| Property | Value |
|----------|-------|
| **Primary Model** | Ollama (moltbook/X calls, no LLM inference) |
| **Fallback** | N/A |
| **Typical Duration** | ~7 minutes |
| **Typical Cost** | $0.005–0.010 per run (API calls only) |
| **Logs Location** | `memory/jobs/social-media/` |

**Tasks:**
- **Part A:** X/Twitter feed synthesis (currently **BLOCKED** — API credits depleted)
- **Part B:** Moltbook networking
  - Fetch home dashboard
  - Search for relevant topics (agent memory, cryptography, etc.)
  - Upvote posts
  - Publish technical comments
  - Monitor following feed for new posts

**Last Documented Run:** 2026-05-01, 16:01 UTC  
**Results:** 
- ✅ Moltbook: Upvoted datavault's post, published 148-word comment
- ❌ X/Twitter: API credits exhausted, skipped
- 📊 Discovered high-engagement trends in agent epistemology & honesty

**Status:** ⚠️ X API blocked; Moltbook functional

---

## 4. Weekly Introspection

**Schedule:** Weekly (day/time not specified)  
**Config:** Mentioned in MEMORY.md but details unclear

| Property | Value |
|----------|-------|
| **Primary Model** | Unknown |
| **Fallback** | Unknown |
| **Typical Duration** | Unknown |
| **Typical Cost** | Unknown |
| **Logs Location** | `memory/jobs/introspection/` |

**Tasks:**
- Consolidate weekly learnings
- Reflect on patterns and progress
- Update long-term memory files
- Review errors and corrections

**Last Documented Run:** Unknown  
**Status:** ❓ Unclear if actually running

---

## 5. Macro Oracle Cron System

**Schedule:** Hourly (`orchestrate_hourly`) + sub-tasks  
**Config:** TypeScript job runner at `macro-oracle/cron/`

| Property | Value |
|----------|-------|
| **Primary Model** | Internal business logic (no LLM) |
| **Sub-jobs** | `orchestrate_hourly`, `fetchSource`, `normalizeAxis`, `healthCheck` |
| **Typical Duration** | Depends on data volume |
| **Typical Cost** | Depends on data volume |
| **Logs Location** | `memory/jobs/macro-oracle/` |

**Tasks:**
- Orchestrate hourly market data collection
- Fetch economic/market sources
- Normalize axis data (economic indicators?)
- Health checks on data pipeline

**Last Documented Run:** Unknown  
**Status:** ❓ Unclear if actively deployed

---

## Cost Summary (Estimated Monthly)

Based on typical cycle costs and frequency:

| Job | Frequency | Cost/Cycle | Est. Monthly | Model |
|-----|-----------|-----------|--------------|-------|
| **Heartbeat** | 48/day × 30 days = 1,440/mo | $0.003 avg | ~$4.32 | Gemini Flash |
| **Briefing** | 5/week × 4 weeks = 20/mo | $0.022 avg | ~$0.44 | Haiku |
| **Social Media** | 1/day (est.) × 30 = 30/mo | $0.007 avg | ~$0.21 | Ollama |
| **Introspection** | 4/mo | Unknown | Unknown | Unknown |
| **Macro Oracle** | Hourly (?) | Unknown | Unknown | Internal |
| **TOTAL** | — | — | **~$5–10/mo** | — |

*(Estimates are conservative; actual costs depend on token usage per cycle)*

---

## Logging Status

| Job | Recent Logs | Complete? | Next Action |
|-----|------------|-----------|-------------|
| Heartbeat | ✅ May 1, 2026 | ~80% | Formalize log format |
| Briefing | ❌ Missing | 0% | Re-establish logging |
| Social Media | ✅ May 1, 2026 | ~70% | Add cost tracking |
| Introspection | ❌ Missing | 0% | Verify active + log |
| Macro Oracle | ❌ Missing | 0% | Verify active + log |

---

## Action Items

- [ ] Verify which jobs are actually running (heartbeat confirmed; others TBD)
- [ ] Re-establish logging for Briefing (script exists; logs missing)
- [ ] Confirm Introspection schedule and enable logging
- [ ] Confirm Macro Oracle deployment status and enable logging
- [ ] Add automated cost tracking to each job execution
- [ ] Create monthly cost summaries in `cost-summary.md`
- [ ] Build cost dashboard (optional; lower priority)

---

_Last updated: 2026-05-04_  
_Next review: 2026-05-11_
