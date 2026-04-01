# Procedure: Gmail Check

## Steps
1. Set env: `GOG_KEYRING_PASSWORD=$(cat /data/.openclaw/.gog-keyring-password)`
2. Set env: `GOG_ACCOUNT=brandongkirksey@gmail.com`
3. Run: `gog gmail search --query "is:unread newer_than:1d"`

## Full command (isolated subagent)
```bash
GOG_KEYRING_PASSWORD=$(cat /data/.openclaw/.gog-keyring-password) GOG_ACCOUNT=brandongkirksey@gmail.com gog gmail search --query "is:unread newer_than:1d"
```

## Failure Log

### 2026-03-26: Keyring password missing in subagent
- **Error:** "keyring: no password stored"
- **Fix:** Must explicitly pass GOG_KEYRING_PASSWORD — do not rely on inherited env
- **Status:** CONFIRMED WORKING

### 2026-03-27: Env vars not available in isolated sessions
- **Error:** Env vars from parent session not inherited
- **Fix:** Read password directly from file in the command string
- **Status:** CONFIRMED WORKING
