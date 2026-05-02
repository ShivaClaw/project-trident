# Ollama VPS Restart

**When to use:** Gateway inference timeout, Ollama endpoint unresponsive, or model hung at token generation.

**Endpoint:** http://72.60.119.23:11434

## Quick Check

```bash
curl -s http://72.60.119.23:11434/api/tags | jq .
```

Expected: JSON with `models` array. If connection refused or timeout → restart.

## Restart Sequence

1. **SSH to VPS:** `ssh root@72.60.119.23`
2. **Stop Ollama:** `docker compose -f /docker/root_trident-network/docker-compose.yml down ollama-server`
3. **Wait:** 10 seconds
4. **Start:** `docker compose -f /docker/root_trident-network/docker-compose.yml up -d ollama-server`
5. **Verify load:** `docker exec ollama-server ollama ps` → wait for models to load (~30-60s)
6. **Test:** `curl -s http://72.60.119.23:11434/api/tags | jq .models[].name`

Expected models:
- `qwen2.5:7b` (primary)
- `dolphin3:8b` (fallback)

## Known Failure Modes

| Symptom | Cause | Fix |
|---------|-------|-----|
| `Connection refused` after restart | Docker image pull failed | Run `docker pull ollama:latest` manually |
| Model loads but times out at token 1 | Model OOM / insufficient RAM | Check `docker stats ollama-server` — should be <6GB used |
| Endpoint responds but models empty | Models not auto-loaded | Run `docker exec ollama-server ollama pull qwen2.5:7b` |

## Last Verified

2026-05-01 07:40 EDT — both models operational, 1.3GB RAM margin
