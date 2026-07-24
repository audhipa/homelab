# Homelab Troubleshooting Record

## Goal

I kept the failures and diagnostic commands that changed how I operate the homelab. The purpose of this record is to make each symptom reproducible and to separate host, network, container, proxy, and application failures before changing configuration.

## Decisions

My diagnostic order is:

1. confirm the host and Docker CLI are available;
2. validate the Compose model;
3. inspect container state and logs;
4. test the backend directly;
5. test Caddy with the intended `Host` header;
6. confirm firewall and remote-access paths;
7. verify metrics at both the exporter and Prometheus target layers.

I record exact errors when I have them. For broader failure categories, I keep likely causes separate from confirmed resolutions so the documentation does not turn a guess into history.

## Build

### Docker CLI unavailable

The symptom is:

```text
docker: command not found
```

I treat this as a host prerequisite failure: Docker Engine is not installed, or the CLI is not available in the current shell.

After installation or a shell-permission change, I validate both required interfaces:

```bash
docker --version
docker compose version
```

### Docker Compose validation failure

I start with:

```bash
docker compose -f docker/compose.yml config
```

The checks I make next are YAML indentation, the environment file, duplicate host-port bindings, and whether the installed Compose version supports the configured options.

### Service not reachable

I inspect state and logs before changing ports or firewall rules:

```bash
docker compose -f docker/compose.yml ps
docker compose -f docker/compose.yml logs -f <service-name>
```

The failure can be a stopped or unhealthy container, a host-port conflict, a firewall rule, or a service listening on a different port than the Compose mapping expects.

### Grafana requests credentials

Grafana's login screen is expected. The Compose defaults are `admin/change-me-locally` only when local environment values do not override them.

If I need to reset an unknown local password, I use the Grafana CLI inside the container:

```bash
docker compose -f docker/compose.yml exec grafana grafana cli admin reset-admin-password '<new-local-password>'
```

The real password remains in local configuration rather than Git.

### Prometheus returns `405` to `curl -I`

The symptom is:

```text
HTTP/1.1 405 Method Not Allowed
```

`curl -I` sends an HTTP `HEAD` request. Prometheus accepts `GET` for the web interface, so I changed the route check to:

```bash
curl -H "Host: prometheus.ozul" http://localhost
```

This was a method mismatch, not proof that the proxy or Prometheus process was down.

### `curl` reports error `23` when sampling metrics

The symptom is:

```text
curl: (23) Failure writing output to destination
```

This occurred with:

```bash
curl http://localhost:9100/metrics | head
```

`head` exits after reading enough lines, which can close the pipe while `curl` is still writing. When the requested metric lines are present and the endpoint works without the pipe, I treat this specific error as a pipeline side effect rather than an exporter failure.

### Ansible cannot reach the host

I reproduce the connection separately from the playbook:

```bash
ansible -i ansible/inventory.ini homelab -m ping
```

The next checks are the inventory hostname or address, SSH key availability, remote user permissions, and host reachability.

### System SSH configuration blocks Ansible

The exact error was:

```text
Bad owner or permissions on /etc/ssh/ssh_config.d/20-systemd-ssh-proxy.conf
```

The SSH client rejected a system configuration file with unsafe ownership or permissions. I corrected and verified it with:

```bash
sudo chown root:root /etc/ssh/ssh_config.d/20-systemd-ssh-proxy.conf
sudo chmod 0644 /etc/ssh/ssh_config.d/20-systemd-ssh-proxy.conf
stat -c '%U:%G %a %n' /etc/ssh/ssh_config.d/20-systemd-ssh-proxy.conf
```

The expected state is:

```text
root:root 644 /etc/ssh/ssh_config.d/20-systemd-ssh-proxy.conf
```

### Grafana has no metrics

I check the dependency chain rather than starting with the dashboard:

1. Prometheus container state.
2. Prometheus target health at `http://prometheus.ozul/targets`.
3. Node Exporter reachability.
4. Grafana's Prometheus data-source configuration.

### Prometheus does not scrape Node Exporter

Prometheus originally needed an explicit scrape configuration and mount. The working configuration:

- mounts `docker/prometheus.yml` at `/etc/prometheus/prometheus.yml`;
- includes `node-exporter:9100` as a static target;
- restarts the Compose stack after the configuration changes.

I validate and apply that state with:

```bash
docker compose -f docker/compose.yml config
docker compose -f docker/compose.yml up -d
```

## Validation

The completed monitoring path has evidence at three levels:

- Node Exporter returns host metrics.
- Prometheus shows its own job and the `node-exporter` job as healthy.
- Grafana visualizes the collected Prometheus data.

![Prometheus target validation](screenshots/prometheus-targets.jpg)

![Grafana metrics validation](screenshots/grafana-dashboard.png)

## Lessons learned

An HTTP error can still prove useful reachability. Prometheus returning `405` confirmed that the request reached the service; the request method was wrong. The same principle applies to Caddy and Grafana responses: I use the exact status and response source to decide which boundary failed.

Shell pipelines can also create misleading errors. I now reproduce an endpoint without `head` before treating `curl` error `23` as a network or service failure.

Finally, SSH security checks can block automation before Ansible runs any task. Correct inventory values are not enough when the local SSH client refuses unsafe configuration-file permissions.

When the implementation changes, I update the architecture, network map, runbook, and this troubleshooting record together so the documented path does not drift from the repository.
