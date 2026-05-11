# Lesson: Traefik Docker Compose Conflict Resolution

## 2026-05-07 - Ambiguous Router Configuration

**Problem:**
When a Traefik router in a `docker-compose.yml` file is implicitly or explicitly linked to multiple services without clear differentiation, Traefik can become ambiguous about which service to route traffic to, leading to conflicts and deployment failures (e.g., "router is linked to two services, which Traefik can’t decide between").

**Root Cause:**
Incorrect or overlapping Traefik labels and network configurations in the `docker-compose.yml` that assign the same router entry point to multiple backend services.

**Resolution:**
Ensure that each Traefik router has a unique and unambiguous target service. This often involves carefully reviewing and correcting service labels, network definitions, and router rules within the `docker-compose.yml` to ensure clear one-to-one mapping or appropriate routing rules for multiple services.
