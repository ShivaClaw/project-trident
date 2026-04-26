# Heartbeat: Time-Sensitive Tracking

## Standing Deadlines

Check every heartbeat (Layer 0 every 15 min). Flag items with **days < 3** as `[DEADLINE-URGENT]`.

### Outlier AI Shutdown
- **Deadline:** May 20, 2026
- **Days remaining:** 26
- **Impact:** Income loss → zero personal financial buffer
- **Mitigation:** Job search (Batch 4 Apr 22, ongoing)
- **Last checked:** 2026-04-26 04:54 UTC

### Job Search Milestones
- **Batch 4 Job Hunter run:** Wednesday Apr 22, 8 AM EDT
- **Batch 5 scheduled:** [TBD]
- **Status:** 🔴 OVERDUE priority — flag in daily log [DEADLINE-OVERDUE]
- **Last checked:** 2026-04-26 04:54 UTC (cycle #110) — [DEADLINE-OVERDUE] 4 days past Apr 22

---

## Time-Sensitive Items (TTL)

Add items with explicit expiration windows. Layer 0 removes when expired.

| Item | Deadline | Days Remaining | Status | Notes |
|------|----------|----------------|--------|-------|
| [task] | [date] | [auto] | [pending/in-progress/completed] | [details] |

---

## Urgency Scale

| Level | Days | Action | Channel |
|-------|------|--------|---------|
| 🔴 OVERDUE | < 0 | Immediate escalation | Daily log `[DEADLINE-OVERDUE]` |
| 🔴 CRITICAL | < 1 | Within hours | Daily log `[DEADLINE-URGENT]` |
| 🟠 HIGH | 1–3 | Today/tomorrow | Daily log flag |
| 🟡 MEDIUM | 3–7 | This week | Memory note |
| 🟢 LOW | 7+ | This month | Standard tracking |

---

## Last Layer 0 Heartbeat Check

2026-04-26 04:54 UTC (cycle #110) — items checked: 2, urgent: 0, overdue: 1 (Batch 4 search — 4 days overdue)