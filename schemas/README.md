# Infrastructure Schemas & Backups

Generated: 2026-05-11 03:40 UTC

## Files

- **docker-compose.yml** — Current production compose configuration
- **.env.example** — Environment variables reference (redacted, secrets omitted)
- **system-state.txt** — Git status and compose config dump at backup time

## Note

Qdrant and FalkorDB schema exports skipped due to:
- Docker not available in backup runtime environment
- Services may not be running at backup time

For live schema exports, run manually:
```bash
docker exec memory-qdrant curl -s http://localhost:6333/collections > /tmp/qdrant-collections.json
docker exec memory-falkordb graph.query 'CALL db.schema.constraints' > /tmp/falkordb-schema.txt
```
