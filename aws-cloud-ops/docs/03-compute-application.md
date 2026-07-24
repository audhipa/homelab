# Compute and Dockerized Application

## Goal

I wanted a small workload that made the entire runtime path inspectable: Ubuntu on EC2, Docker Compose, Gunicorn, Flask, container health, host-port publishing, application logs, and HTTP validation.

## Decisions

I used Ubuntu 24.04 LTS because it matched my existing Linux experience. I used Flask for a minimal service and Gunicorn as the application server. The container listens on port `8000`, and Docker Compose publishes it on host port `80`.

I added explicit `/health` and `/version` endpoints so I could distinguish basic network reachability from application health and deployed version. I configured the container to restart unless stopped and added a 30-second health check against the internal Flask endpoint.

## Build

The application exposes three endpoints:

| Endpoint | Response |
|---|---|
| `/` | Service name, environment, version, hostname, and UTC timestamp |
| `/health` | Healthy status and service name |
| `/version` | Current application version |

The image uses `python:3.12-slim`, installs pinned Flask and Gunicorn versions, and starts two Gunicorn workers on `0.0.0.0:8000`. Docker Compose maps `80:8000`, sets the lab environment values, sends container logs to the CloudWatch Logs group, and runs the internal health check.

The exact deployed files are included in the repository:

- [`app.py`](../app/app.py)
- [`requirements.txt`](../app/requirements.txt)
- [`Dockerfile`](../app/Dockerfile)
- [`compose.yml`](../app/compose.yml)

## Validation

I validated the workload from the application directory with:

```bash
sudo docker compose ps
curl -i http://localhost/
curl -i http://localhost/health
curl -i http://localhost/version
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status
```

The final result showed:

- the `ops-demo` container in a healthy state;
- HTTP `200` from `/health`;
- HTTP `200` and version `0.1.0` from `/version`;
- the CloudWatch Agent in `running` and `configured` states.

![Healthy container, HTTP endpoints, and CloudWatch Agent](screenshots/03-session-and-health.png)

## Lessons learned

My first `curl http://localhost/health` request returned nginx's `404 Not Found` page. That response proved only that port `80` reached nginx; it did not prove that Flask was healthy.

I diagnosed the path by checking the port listener, Docker container state, recent container logs, the Flask endpoint on port `8000`, and the published endpoint on port `80`:

```bash
sudo ss -lntp | grep ':80 '
sudo docker compose ps
sudo docker compose logs --tail=50
curl -i http://127.0.0.1:8000/health
curl -i http://localhost/health
```

The key lesson was to validate each boundary separately: host listener, Docker mapping, container process, and application route. The final HTTP `200` responses replaced the earlier nginx `404` as the completion evidence.
