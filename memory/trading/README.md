# Virtual Trading — Shiva's Hyperliquid Paper Portfolio

## Rules
- Starting capital: **1000 USDC** (virtual, non-custodial)
- All positions entered during morning briefing after macro + asset analysis
- All positions **must be closed by end of regular trading hours** each day (4:00 PM ET / 2:00 PM MDT)
- Heartbeat checks positions throughout the day and notes any significant moves
- Friday 4:20 cron calculates full weekly P/L

## Structure
- `portfolio.md` — current open positions and running balance
- `trades/YYYY-MM-DD.md` — daily trade log (entries, exits, reasoning, P/L)
- `performance.md` — weekly P/L summary, win rate, lessons

## Philosophy
- This is a real trading exercise — treat it as if the money is real
- Use macro + on-chain signals from the morning briefing to inform trades
- Document the reasoning for every entry and exit
- Be honest about bad calls — the point is to learn and develop a real edge
- Track not just P/L but quality of reasoning vs outcome
