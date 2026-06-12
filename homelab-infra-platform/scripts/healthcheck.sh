#!/usr/bin/env bash
# healthcheck.sh
# Safely reports host and Docker Compose service status for the homelab stack.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMPOSE_FILE="$REPO_ROOT/docker/compose.yml"

echo "=== Homelab Healthcheck ==="
echo

echo "[1/7] Hostname:"
hostname
echo

echo "[2/7] Uptime:"
uptime
echo

echo "[3/7] Disk usage:"
df -h /
echo

echo "[4/7] Memory usage:"
free -h
echo

echo "[5/7] Network addresses:"
ip -brief addr
echo

echo "[6/7] Docker availability:"
if ! command -v docker >/dev/null 2>&1; then
  echo "ERROR: docker is not installed or is not in PATH." >&2
  exit 1
fi

docker --version
echo

echo "[7/7] Docker Compose stack status:"

if [[ ! -f "$COMPOSE_FILE" ]]; then
  echo "ERROR: Compose file not found at: $COMPOSE_FILE" >&2
  exit 1
fi

echo "Validating Docker Compose syntax..."
docker compose -f "$COMPOSE_FILE" config >/dev/null

echo
echo "Current service status:"
docker compose -f "$COMPOSE_FILE" ps

echo
echo "Healthcheck complete."
