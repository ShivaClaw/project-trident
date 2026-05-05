# Macro Oracle Cron Logs

**Schedule:** Hourly (`orchestrate_hourly`) + sub-tasks  
**Config:** TypeScript job runner at `/data/.openclaw/workspace/macro-oracle/cron/`  
**Primary Model:** Internal business logic (no LLM)  
**Status:** ❓ Unclear if actively deployed

## Overview

This directory is reserved for Macro Oracle cron system execution logs.

**Job Types:**
- `orchestrate_hourly` — Hourly orchestration trigger
- `fetchSource` — Data source fetching
- `normalizeAxis` — Axis normalization (economic indicators?)
- `healthCheck` — Data pipeline health checks

## Current Status
- No execution logs found
- Deployment status unclear (code exists at `/data/.openclaw/workspace/macro-oracle/cron/`)
- Unclear if actively running on production

## Next Actions

- [ ] Verify Macro Oracle deployment status
- [ ] Confirm if currently running hourly
- [ ] Capture execution logs for each sub-job
- [ ] Record data volume + processing time
- [ ] Implement standardized log format (see `/memory/jobs/INDEX.md`)

---

_To be populated with execution logs once deployment is verified_
