# Docker Compose and Traefik Issues

## 2026-05-07 - OpenClaw Deployment Conflict

**Reported Issue:**
The `openclaw-kk8i` router was reported by the user as being linked to two services (`gateway-svc` and `openclaw-kk8i`), causing a conflict where Traefik could not decide between them.

**Analysis/Correction:**
The assistant identified this as a bug in the `docker-compose.yml` configuration causing the Traefik router to have an ambiguous target. A corrected `docker-compose.yml` file was provided to resolve this conflict.
