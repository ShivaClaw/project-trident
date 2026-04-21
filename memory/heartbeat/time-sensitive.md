# Heartbeat: Time-Sensitive Tracking

## Standing Deadlines

Check every heartbeat (Layer 0 every 15 min). Flag items with **days < 3** as `[DEADLINE-URGENT]`.

### Outlier AI Shutdown
- **Deadline:** May 20, 2026
- **Days remaining:** 29
- **Impact:** Income loss → zero personal financial buffer
- **Mitigation:** Job search (Batch 4 Apr 22, ongoing)
- **Last checked:** 2026-04-21 01:55:07 MDT

### Job Search Milestones
- **Batch 4 Job Hunter run:** Monday Apr 22, 8 AM EDT
- **Batch 5 scheduled:** [TBD]
- **Hours remaining:** ~29.75 hours (approx 1.24 days) [DEADLINE-URGENT]
- **Status:** 🔴 CRITICAL priority — flag in daily log
- **Last checked:** 2026-04-21 01:55:07 MDT

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

2026-04-21 01:55:07 MDT — items checked: 2, urgent: 1, overdue: 0
