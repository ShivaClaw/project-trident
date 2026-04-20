# Heartbeat: Trading Portfolio

## Current Open Positions

Tracked by Layer 0 heartbeat during trading hours (6 AM–4 PM MDT weekdays).

| Asset | Direction | Entry Price | Current Price | Size | Unrealized P/L | Stop Loss | Take Profit | Status |
|-------|-----------|-------------|--------------|------|----------------|-----------|------------|--------|
| [ASSET] | [long/short] | [price] | [price] | [qty] | [P/L] | [SL] | [TP] | [open/approaching-SL/approaching-TP/exit-signal] |

---

## Daily Trade Log

See `memory/heartbeat/trading/YYYY-MM-DD.md` for each day's entries.

---

## End-of-Day Protocol

**At 4:00 PM MDT (or later):**
- Close ALL remaining open positions at market price
- Record final exits to daily trade log
- Calculate total day P/L
- Update this file with closed position summary

---

## Rules (From HEARTBEAT.md)

- Trading hours: 6:00 AM–4:00 PM MDT weekdays only
- All positions MUST close by 4:00 PM regardless of P/L
- Position sizing: 1–15% account per trade
- Leverage: 0–2x (YOLO acceptable if sized <5%)
- Layer 0 heartbeat checks positions every 15 min during trading hours
- Alert if approaching stop/TP levels or >1% move from entry

---

## Strategy Notes

[Add trading thesis, market structure observations, tactical approach]
