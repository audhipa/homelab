# Homelab Operations Runbook

## Goal

This runbook keeps the homelab's normal operating path repeatable: prepare local configuration, validate the model, deploy the stack, inspect health, check routes and metrics, and stop services cleanly.

## Decisions

Machine-specific inventory and credentials stay outside Git. The committed `.example` files show the required shape, while `ansible/inventory.ini` and `docker/.env` hold the local values.

The normal deployment runs through `scripts/deploy-stack.sh`, which checks for Docker and `docker/.env`, validates the Compose model, and stops on errors. Manual Compose commands remain documented so I can bypass the wrapper during diagnosis.

Backup and recovery remain incomplete. The repository contains a backup script, but no restore has been validated, and the script's hard-coded volume names may differ from the names created by the active Compose project.

## Build

### Prepare local configuration

From `homelab-infra-platform/`, I create the two untracked local files:

```bash
cp ansible/inventory.example.ini ansible/inventory.ini
cp docker/.env.example docker/.env
```

The example inventory and Grafana values are then replaced locally.

### Deploy the stack

My normal deployment path is:

```bash
./scripts/deploy-stack.sh
```

The manual equivalent is:

```bash
docker compose -f docker/compose.yml up -d
```

The expected service set is:

- `caddy`
- `grafana`
- `uptime-kuma`
- `prometheus`
- `node-exporter`

### Inspect service state

```bash
docker compose -f docker/compose.yml ps
```

To stop the stack:

```bash
docker compose -f docker/compose.yml down
```

### Inspect logs

For the full stack:

```bash
docker compose -f docker/compose.yml logs -f
```

For the services I check most often:

```bash
docker compose -f docker/compose.yml logs -f caddy
docker compose -f docker/compose.yml logs -f prometheus
docker compose -f docker/compose.yml logs -f grafana
```

### Run the host health check

```bash
./scripts/healthcheck.sh
```

The script reports:

1. hostname;
2. uptime;
3. root-filesystem usage;
4. memory usage;
5. network addresses;
6. Docker availability and version;
7. validated Compose state and current service status.

### Apply or preview the host baseline

Ansible work begins with a connectivity check:

```bash
ansible -i ansible/inventory.ini homelab -m ping
```

Next, check mode previews the playbook:

```bash
ansible-playbook -i ansible/inventory.ini ansible/site.yml --check
```

When the inventory and preview are correct, the implementation playbook is:

```bash
ansible-playbook -i ansible/inventory.ini ansible/site.yml
```

### Create a draft volume archive

The current backup command is:

```bash
./scripts/backup.sh
```

The script attempts to archive the named volumes `uptime-kuma-data`, `prometheus-data`, and `grafana-data` into `backups/homelab-volumes-<timestamp>.tar.gz`.

The presence of that archive does not count as recovery proof. Before relying on it, I need to resolve the actual Compose volume names, verify the archive contents, restore them into clean volumes, restart the services, and validate the recovered state.

## Validation

### Compose model

```bash
docker compose -f docker/compose.yml config
```

### Caddy routes

```bash
curl -I -H "Host: grafana.ozul" http://localhost
curl -I -H "Host: kuma.ozul" http://localhost
curl -H "Host: prometheus.ozul" http://localhost
```

Prometheus uses `GET` here because `curl -I` sends `HEAD`, which returned `405 Method Not Allowed` even when the service was healthy.

### Node Exporter metrics

```bash
curl http://localhost:9100/metrics | head
```

If `curl` reports error `23` after `head` prints the sample, I check whether the downstream pipe simply closed after receiving the requested lines.

### Captured evidence

![Docker Compose service status](screenshots/docker-compose-ps.jpg)

![Prometheus target health](screenshots/prometheus-targets.jpg)

## Lessons learned

A wrapper script is useful only when I can still inspect the underlying command. Keeping both deployment paths made it easier to distinguish script failures from Compose failures.

Health checks also need layers. A running container does not prove its route works, a Caddy response does not prove the backend is healthy, and a Prometheus process does not prove its scrape targets are up.

The backup path is the strongest example of the difference between implementation and validation. Writing an archive is only the first half of recovery; a clean restore and application-level checks are the evidence that matter.
