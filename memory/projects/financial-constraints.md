# Financial Constraints

## Impact on Operations

### Current Status [2026-04-25]
- **Cloud API Credits:** Renewed as of 2026-04-24
- **Primary Model:** `ollama/qwen3.5:9b` (local, $0/query)
- **Fallback Chain:** Claude Haiku 4.5 → Gemini 2.5 Flash → Grok 3 Mini Fast (cloud, for emergencies only)
- **Decision:** Continue prioritizing local inference as primary; cloud reserved for fallback only
- **Cost Impact:** Reduced from ~$200/week (cloud-first) to ~$0 during local-inference window

### Historical Context
- **2026-04-21 05:55 UTC:** Emergency pivot initiated due to cloud credits exhaustion
- **2026-04-22 13:11 UTC:** All nine cron jobs transitioned from cloud APIs to local model
- **2026-04-24 16:38 UTC:** Ollama restoration completed post-network-isolation fix; qwen3.5:9b restored as primary
- **2026-04-24 17:06–17:14 UTC:** Credential management centralization completed (`.env.secret` → cron availability)