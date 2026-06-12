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

Manual equivalent:

```bash
docker compose -f docker/compose.yml up -d
```

## Check Stack

```bash
docker compose -f docker/compose.yml ps
```

Expected services:

- `caddy`
- `grafana`
- `uptime-kuma`
- `prometheus`
- `node-exporter`

## Stop Stack

```bash
docker compose -f docker/compose.yml down
```

## Validate Compose

```bash
docker compose -f docker/compose.yml config
```

## Check Logs

All services:

```bash
docker compose -f docker/compose.yml logs -f
```

Specific services:

```bash
docker compose -f docker/compose.yml logs -f caddy
docker compose -f docker/compose.yml logs -f prometheus
docker compose -f docker/compose.yml logs -f grafana
```

## Validate Caddy Routes Locally

Run these on the Docker host:

```bash
curl -I -H "Host: grafana.ozul" http://localhost
curl -I -H "Host: kuma.ozul" http://localhost
curl -H "Host: prometheus.ozul" http://localhost
```

`curl -I` is useful for Grafana and Uptime Kuma HTTP headers. Use `GET` for Prometheus because its web UI may not return a useful response to `HEAD`.

## Validate Node Exporter

```bash
curl http://localhost:9100/metrics | head
```

## Validate Ansible

```bash
ansible -i ansible/inventory.ini homelab -m ping
ansible-playbook -i ansible/inventory.ini ansible/site.yml --check
```

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

## Screenshot Placeholders

[Screenshot here: terminal output of docker compose ps showing all services Up]

[Screenshot here: Prometheus /targets page showing node-exporter UP]
