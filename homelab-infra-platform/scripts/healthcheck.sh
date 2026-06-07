#!/usr/bin/env bash
# healthcheck.sh
# Safely reports Docker Compose service status for the homelab stack.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMPOSE_FILE="$REPO_ROOT/docker/compose.yml"

if ! command -v docker >/dev/null 2>&1; then
  echo "ERROR: docker is not installed or is not in PATH." >&2
  exit 1
fi

echo "Validating Docker Compose syntax..."
docker compose -f "$COMPOSE_FILE" config >/dev/null

echo "Current service status:"
docker compose -f "$COMPOSE_FILE" ps
