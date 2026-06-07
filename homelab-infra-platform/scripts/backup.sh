#!/usr/bin/env bash
# backup.sh
# Creates a timestamped archive of selected Docker named volumes.
# Review the volume list before relying on this for recovery.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="$REPO_ROOT/backups"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
TARGET="$BACKUP_DIR/homelab-volumes-$TIMESTAMP.tar.gz"
TMP_DIR="$(mktemp -d)"

VOLUMES=(
  "uptime-kuma-data"
  "prometheus-data"
  "grafana-data"
)

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

if ! command -v docker >/dev/null 2>&1; then
  echo "ERROR: docker is not installed or is not in PATH." >&2
  exit 1
fi

mkdir -p "$BACKUP_DIR"

for volume in "${VOLUMES[@]}"; do
  echo "Exporting volume: $volume"
  docker run --rm \
    -v "$volume:/data:ro" \
    -v "$TMP_DIR:/backup" \
    busybox \
    sh -c "cd /data && tar cf /backup/${volume}.tar ."
done

tar -czf "$TARGET" -C "$TMP_DIR" .

echo "Backup created: $TARGET"
