# Troubleshooting Guide

Use this guide to document repeatable fixes. Add exact symptoms, checks, and resolutions as the lab grows.

## `docker: command not found`

Symptom:

```text
docker: command not found
```

Cause:

- Docker Engine is not installed, or the Docker CLI is not available in the current shell.

Fix:

- Install Docker Engine and the Docker Compose plugin on the Ubuntu host.
- Reopen the shell or verify the user has the expected Docker permissions.
- Validate with:

  ```bash
  docker --version
  docker compose version
  ```

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
docker compose -f docker/compose.yml logs -f <service-name>
```

Likely causes:

- Container is stopped or unhealthy.
- Port conflict on the host.
- Firewall is blocking access.
- Service is listening on a different port than expected.

## Grafana Asks For Username And Password

Cause:

- This is expected Grafana behavior. Grafana requires a login before dashboards are available.
- The Compose default is `admin/change-me-locally` unless changed through local environment values.

Fix:

- Use the locally configured Grafana admin credentials.
- If the password is unknown, reset it with the Grafana CLI from inside the container instead of committing a real password to Git.

Example:

```bash
docker compose -f docker/compose.yml exec grafana grafana cli admin reset-admin-password '<new-local-password>'
```

Do not commit the real password.

## Prometheus Route Returns 405 With `curl -I`

Symptom:

```text
HTTP/1.1 405 Method Not Allowed
```

Cause:

- `curl -I` sends an HTTP `HEAD` request. Prometheus expects `GET` or `OPTIONS` for the web UI.

Fix:

```bash
curl -H "Host: prometheus.ozul" http://localhost
```

## `curl: (23) Failure writing output to destination`

Symptom:

```text
curl: (23) Failure writing output to destination
```

Cause:

- This can happen when piping a large response to `head`. `head` exits after reading enough lines, and `curl` reports that the downstream pipe closed early.

Fix:

- Treat this as harmless for validations such as:

  ```bash
  curl http://localhost:9100/metrics | head
  ```

## Ansible Cannot Reach Host

Checks:

```bash
ansible -i ansible/inventory.ini homelab -m ping
```

Likely causes:

- Wrong hostname or address in inventory.
- SSH key not available.
- Remote user does not have required permissions.
- Host is powered off or unreachable.

## Ansible SSH Fails Because Of System SSH Config Permissions

Symptom:

```text
Bad owner or permissions on /etc/ssh/ssh_config.d/20-systemd-ssh-proxy.conf
```

Cause:

- The SSH client refuses to load system SSH config files if ownership or permissions are unsafe.

Fix:

```bash
sudo chown root:root /etc/ssh/ssh_config.d/20-systemd-ssh-proxy.conf
sudo chmod 0644 /etc/ssh/ssh_config.d/20-systemd-ssh-proxy.conf
stat -c '%U:%G %a %n' /etc/ssh/ssh_config.d/20-systemd-ssh-proxy.conf
```

Expected safe state:

```text
root:root 644 /etc/ssh/ssh_config.d/20-systemd-ssh-proxy.conf
```

## Metrics Missing in Grafana

Checks:

- Confirm Prometheus is running.
- Confirm exporters are reachable from Prometheus.
- Confirm Grafana has a Prometheus data source configured.
- Check Prometheus targets at `http://prometheus.ozul/targets`.

## Prometheus Is Not Scraping Node Exporter

Cause:

- Prometheus is missing the Node Exporter scrape configuration, or the config is not mounted into the container.

Fix:

- Mount `docker/prometheus.yml` into the Prometheus container.
- Include the `node-exporter:9100` target.
- Validate the Compose file:

  ```bash
  docker compose -f docker/compose.yml config
  ```

- Restart the stack if the running container needs the updated config:

  ```bash
  docker compose -f docker/compose.yml up -d
  ```

## Documentation Drift

When the actual setup changes, update:

- `docs/architecture.md`
- `docs/network-map.md`
- `docs/runbook.md`
- `docs/troubleshooting.md`
