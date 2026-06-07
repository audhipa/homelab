#!/usr/bin/env bash
# deploy-stack.sh
# Safely starts or updates the Docker Compose stack.
# Review docker/compose.yml and docker/.env before running.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMPOSE_FILE="$REPO_ROOT/docker/compose.yml"
ENV_FILE="$REPO_ROOT/docker/.env"

if ! command -v docker >/dev/null 2>&1; then
  echo "ERROR: docker is not installed or is not in PATH." >&2
  exit 1
fi

if [[ ! -f "$ENV_FILE" ]]; then
  echo "ERROR: Missing docker/.env. Copy docker/.env.example to docker/.env locally first." >&2
  exit 1
fi

echo "Validating Docker Compose syntax..."
docker compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" config >/dev/null

echo "Starting homelab stack..."
docker compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" up -d

echo "Done. Run ./scripts/healthcheck.sh to review service status."
