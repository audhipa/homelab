# Troubleshooting Guide

Use this guide to document repeatable fixes. Add exact symptoms, checks, and resolutions as the lab grows.

## Docker Compose Fails Validation

Checks:

```bash
docker compose -f docker/compose.yml config
```

Likely causes:

- Bad YAML indentation.
- Missing environment file.
- Duplicate port bindings.
- Unsupported Compose options on the installed Docker version.

## Service Is Not Reachable

Checks:

```bash
docker compose -f docker/compose.yml ps
docker compose -f docker/compose.yml logs <service-name>
```

Likely causes:

- Container is stopped or unhealthy.
- Port conflict on the host.
- Firewall is blocking access.
- Service is listening on a different port than expected.

## Ansible Cannot Reach Host

Checks:

```bash
ansible all -i ansible/inventory.ini -m ping
```

Likely causes:

- Wrong hostname or address in inventory.
- SSH key not available.
- Remote user does not have required permissions.
- Host is powered off or unreachable.

## Metrics Missing in Grafana

Checks:

- Confirm Prometheus is running.
- Confirm exporters are reachable from Prometheus.
- Confirm Grafana has a Prometheus data source configured.
- Check Prometheus targets once a scrape configuration exists.

## Documentation Drift

When the actual setup changes, update:

- `docs/architecture.md`
- `docs/network-map.md`
- `docs/runbook.md`
- `docs/troubleshooting.md`
