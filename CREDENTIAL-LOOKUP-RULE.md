# CREDENTIAL LOOKUP RULE (Permanent Memory)

**Rule:** When a missing API key, token, password, or credential is standing in the way of forward progress, **always search for it in the TOKENS&KEYS spreadsheet first before asking me for help.**

**Spreadsheet Location:** https://docs.google.com/spreadsheets/d/1VFpg1pOstEBsiUzuLv6kZWaBuf25XCJ79VI8QO34BE8/edit?usp=drive_link

**Attached to:** This rule was committed on 2026-04-15 14:55 EDT as part of the "Systemic Cron Failure" debugging session.

**Rationale:** 
- Credentials are stored centrally in G's sheets for easy reference
- Asking for credentials each time wastes time and context
- First instinct should be to search the spreadsheet, not ask
- If credential is not in the sheet, THEN ask G

**Implementation:** On every credential lookup (X API token, Moltbook key, Telegram chatId, Gmail auth, etc.), check this spreadsheet before proceeding.
