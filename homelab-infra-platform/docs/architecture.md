# Architecture Overview

This document describes the current homelab architecture as implemented. It avoids private addresses and secrets while still documenting the operational design.

## Current Architecture

```text
Personal Laptop
|
| Tailscale / SSH / Browser
v
Ubuntu OptiPlex
|
| Docker Compose
v
Caddy Reverse Proxy
|
+--> Grafana
+--> Uptime Kuma
+--> Prometheus
|
+--> Node Exporter
```

## Components

- **Personal laptop** - Used as the operator workstation for SSH, browser access, Git, and documentation updates.
- **Tailscale** - Provides the private access path between the laptop and the OptiPlex.
- **Ubuntu OptiPlex** - Main homelab host running Docker Compose and Ansible-managed baseline configuration.
- **Docker Compose** - Runs the monitoring and reverse-proxy services from `docker/compose.yml`.
- **Caddy** - Reverse proxies friendly internal hostnames to backend containers:
  - `http://grafana.ozul` -> `grafana:3000`
  - `http://kuma.ozul` -> `uptime-kuma:3001`
  - `http://prometheus.ozul` -> `prometheus:9090`
- **Prometheus** - Collects metrics from itself and Node Exporter.
- **Node Exporter** - Exposes host metrics on port `9100` for Prometheus scraping.
- **Grafana** - Visualizes Prometheus metrics.
- **Uptime Kuma** - Monitors service availability.
- **Ansible** - Applies baseline host configuration, packages, `/opt/homelab`, and firewall rules.
- **GitHub Actions** - Validates YAML, shell scripts, and Docker Compose syntax.

## Data And Traffic Flow

1. The operator connects from a personal laptop to the OptiPlex over Tailscale, SSH, or browser.
2. Docker Compose starts Caddy, Grafana, Uptime Kuma, Prometheus, and Node Exporter.
3. Caddy listens on port `80` and routes `.ozul` hostnames to internal backend services.
4. Prometheus scrapes:
   - `localhost:9090` for Prometheus self-metrics.
   - `node-exporter:9100` for host metrics.
5. Grafana reads metrics from Prometheus for dashboards.
6. Uptime Kuma checks service availability from inside the lab environment.

## Security Notes

- Do not commit real credentials, API tokens, private keys, or personal network details.
- Keep real environment values in untracked local files such as `docker/.env`.
- Prefer SSH keys over passwords for host access.
- Prefer Caddy hostnames over direct dashboard ports for normal browser access.
- Node Exporter should not be broadly exposed outside the trusted lab path.
- The Ansible baseline allows Caddy HTTP traffic through `tailscale0`, keeping the intended access path narrow.
- Treat this as a learning lab, not a production security boundary.

## Screenshot Placeholders

[Screenshot here: architecture diagram or browser tabs showing grafana.ozul, kuma.ozul, and prometheus.ozul working over Tailscale]

## Future Enhancements

- Add Grafana dashboard provisioning.
- Add Ansible roles for Docker installation and user setup.
- Add backup restore testing.
- Add alerting once baseline monitoring is stable.
- Add Terraform only when there is an actual cloud, VM, or network resource to manage.
