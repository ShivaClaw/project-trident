# Gateway Health Check & Debug

**When to use:** Gateway not responding, slow inference, LLM model switching issues.

## Status Check

```bash
# Terminal on local machine
curl -s http://localhost:65007/health
# Expected: {"ok":true}

# Or via Telegram command
/status
```

## Full Health Check

```bash
# Gateway process
ps aux | grep openclaw | grep -v grep

# Config validity
jq . /data/.openclaw/openclaw.json > /dev/null && echo "Config valid"

# Memory index
ls -lah /data/.openclaw/workspace/memory/main.sqlite
# If missing/empty → rebuild with: openclaw memory index --force
```

## Common Issues

| Issue | Diagnosis | Fix |
|-------|-----------|-----|
| **"model not available"** | Primary model not in fallback chain | Check `agents.defaults.model.fallbacks` in config |
| **Slow inference** | Ollama endpoint latency | Check Ollama VPS: `curl -s http://72.60.119.23:11434/api/tags` |
| **"503 service unavailable"** | Gateway context pruning aggressive | Reduce `agents.defaults.contextPruning.ttl` from 1h to 30m |
| **Memory search fails** | No embedding provider configured | Verify OpenAI/Gemini API keys in env |

## Config Hot-Reload

Changes to `openclaw.json` auto-reload (no restart needed). Verify:

```bash
# Check last modified time
stat /data/.openclaw/openclaw.json

# Verify it was loaded
tail -50 ~/.openclaw/openclaw-gateway.log | grep "config"
```

## Restart Gateway (Nuclear Option)

```bash
docker compose down openclaw
docker compose up -d openclaw
curl -s http://localhost:65007/health
```

Expected response time: ~3 seconds.

## Last Verified

2026-05-01 17:00 EDT — Config valid, health endpoint responding
