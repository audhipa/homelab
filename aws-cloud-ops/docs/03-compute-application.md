# Compute and Dockerized Application

## Host baseline

The Phase 1 host is an Ubuntu EC2 instance administered through Session Manager.

Recorded output from the build:

```text
Operating system: Ubuntu 24.04.4 LTS (Noble Numbat)
Session user: ssm-user
Private host identity: ip-10-0-1-171
Initial web-service check: nginx active/running
CloudWatch Agent: running and configured
```

Nginx was useful as an early port-80 test. It is not application proof by itself.

## Application contract

The small Flask service exposes three endpoints:

| Endpoint | Expected result |
|---|---|
| `/` | Service identity, environment, version, host, and UTC timestamp. |
| `/health` | HTTP `200` with a healthy status. |
| `/version` | Current application version. |

The container listens on port `8000`; the host exposes the service on port `80`.

## Validation

Run these from the application directory before capturing evidence:

```bash
sudo docker compose ps
curl -i http://localhost/
curl -i http://localhost/health
curl -i http://localhost/version
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status
```

Required pass conditions:

- The application container is `Up` or `healthy`.
- `/health` returns HTTP `200` and the Flask JSON response.
- `/version` returns the expected application version.
- The CloudWatch Agent reports `running` and `configured`.

## Troubleshooting note: `/health` returned 404

During the build, one `curl http://localhost/health` request returned the nginx `404 Not Found` page. That proves the request reached a web server, but it does **not** prove the Flask health endpoint was working.

The likely path is:

```text
curl -> host port 80 -> nginx default server -> 404
```

The issue was resolved by validating the container path and the host port mapping. The final capture now shows the container as healthy and HTTP `200` from both `/health` and `/version`. These were the useful checks during diagnosis:

```bash
sudo ss -lntp | grep ':80 '
sudo docker compose ps
sudo docker compose logs --tail=50
curl -i http://127.0.0.1:8000/health
curl -i http://localhost/health
```

If port `8000` is healthy but port `80` returns the nginx page, either stop/disable the temporary nginx service and map Docker to port 80, or deliberately configure nginx as the reverse proxy. Document whichever design is actually used.

## Source/configuration evidence still needed

The repository should eventually contain the exact deployed, sanitized application files under `app/`. They should not be recreated from memory. Copy the real `app.py`, dependency file, `Dockerfile`, and Compose file from the instance after reviewing them for secrets.

## Evidence

![Healthy container, HTTP endpoints, and CloudWatch Agent](screenshots/03-session-and-health.png)

This is the final validation capture. It replaces the earlier nginx `404` and is the evidence used for the Phase 1 completion claim.
