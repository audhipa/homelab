# Runbook

This runbook documents basic operating procedures for the homelab infrastructure platform. Commands are intentionally simple and should be reviewed before use.

## First-Time Setup

1. Review the repository structure.
2. Copy example files locally instead of editing examples directly:

   ```bash
   cp ansible/inventory.example.ini ansible/inventory.ini
   cp docker/.env.example docker/.env
   ```

3. Fill in local values in untracked files only.
4. Validate syntax before deploying.

## Deploy Stack

From the repository root:

```bash
./scripts/deploy-stack.sh
```

The script starts services from `docker/compose.yml` using Docker Compose.

## Health Check

```bash
./scripts/healthcheck.sh
```

Use this to inspect running container status.

## Backup

```bash
./scripts/backup.sh
```

The backup script creates a timestamped archive from the named Docker volumes listed in the script. Review the volume list before relying on it.

## Rollback Approach

1. Stop the stack if needed.
2. Restore from the latest known-good backup.
3. Re-run `docker compose config` to validate configuration.
4. Start services and run the health check.

## Change Management

- Make small commits.
- Keep each change tied to one objective.
- Document failures in `docs/troubleshooting.md`.
- Avoid committing real `.env`, inventory, SSH keys, or other sensitive files.
