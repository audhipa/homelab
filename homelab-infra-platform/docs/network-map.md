# Network Map

Use this file to document the network topology of your homelab. Keep examples generic and avoid committing personal or sensitive network details.

## Network Segments

| Segment | Purpose | Example CIDR | Notes |
| --- | --- | --- | --- |
| Management | SSH, admin access, Ansible | `192.0.2.0/24` | Replace locally only |
| Services | Docker-hosted services | `198.51.100.0/24` | Replace locally only |
| Lab | Experiments and test nodes | `203.0.113.0/24` | Replace locally only |

The example CIDR ranges are documentation-only placeholders.

## Host Inventory Template

| Hostname | Role | Address | Notes |
| --- | --- | --- | --- |
| `lab-node-01` | Docker host | `example.local` | Runs monitoring stack |
| `lab-node-02` | Exporter target | `example.local` | Exposes metrics |
| `mgmt-node` | Control node | `example.local` | Runs Ansible commands |

## Service Ports

| Service | Default Port | Purpose |
| --- | ---: | --- |
| uptime-kuma | 3001 | Availability checks |
| Prometheus | 9090 | Metrics collection |
| Grafana | 3000 | Dashboards |
| Node Exporter | 9100 | Host metrics |

## Diagram Placeholder

```text
[Management Node]
       |
       | Ansible / SSH
       v
[Docker Host] ----> [Prometheus] ----> [Grafana]
       |                 |
       |                 v
       +----------> [Node Exporter]
       |
       +----------> [uptime-kuma]
```
