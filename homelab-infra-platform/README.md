# Homelab Infrastructure Platform

Welcome to the **Homelab Infrastructure Platform**—a low-cost DevOps/AI infrastructure portfolio project. This repository is designed to showcase your ability to assemble and operate a small-scale platform using common automation tools. None of the code here should expose secrets or private resources; instead, it provides a safe starting point for building out your homelab.

## Objective

The goal of this project is to set up a reproducible environment where you can experiment with monitoring, alerting, and deployment workflows using inexpensive hardware. You'll use familiar tools like Ansible, Docker Compose, Terraform, and GitHub Actions to orchestrate a collection of services. The emphasis is on **learning** and **demonstrating** skills rather than on production-ready scalability.

## Suggested Hardware

While you can adapt these instructions to your own devices, a typical setup might include:

- **Mini PC or retired desktop** for running Docker services and automation.
- **Old laptop or small server** acting as a central management node for Ansible and Terraform.
- **Home router/switch** for basic network segmentation and DHCP reservations.

Your hardware choices are flexible; the key is to keep costs low while ensuring the system stays responsive.

## Architecture Overview

This homelab uses a modular architecture:

1. **Networking** - A documented home-lab network with management notes in `docs/network-map.md`.
2. **Provisioning** - Ansible inventories and playbooks under `ansible/` to configure hosts and deploy services.
3. **Containers** - `docker/compose.yml` defines a monitoring stack with uptime-kuma, Prometheus, Grafana, and Node Exporter.
4. **Infrastructure as Code** - `terraform/` is reserved for future cloud, VM, or network infrastructure definitions.
5. **Automation** - Shell scripts in `scripts/` support health checks, deployment, and backups.
6. **Validation** - GitHub Actions in `.github/workflows/validate.yml` checks YAML, shell scripts, and Docker Compose syntax.

## Roadmap

1. Document the current hardware, network, and constraints.
2. Copy `ansible/inventory.example.ini` to a private `inventory.ini` and add real hosts locally.
3. Expand `ansible/site.yml` from placeholder tasks into safe host configuration.
4. Customize `docker/compose.yml` for the monitoring stack.
5. Add Prometheus scrape configuration and Grafana dashboards.
6. Add Terraform only when there is an actual cloud, VM, or network resource to manage.
7. Keep every change small, reviewable, and validated by CI.

## Validation

The GitHub Actions workflow validates the repository without requiring secrets. It checks:

- YAML syntax using `yamllint`.
- Shell scripts using `shellcheck`.
- Docker Compose syntax using `docker compose config`.

Local equivalents can be run before opening a pull request.

## Resume Value

This project demonstrates practical experience with infrastructure documentation, Ansible, Docker Compose, monitoring, backup scripting, and CI validation. A strong resume bullet after implementation could be:

> Built a low-cost homelab infrastructure platform using Ansible, Docker Compose, Prometheus, Grafana, uptime-kuma, shell automation, and GitHub Actions to demonstrate repeatable DevOps operations and monitoring workflows.

Keep real passwords, tokens, private IPs, and personal information out of version control.
