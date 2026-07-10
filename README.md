# Infrastructure Lab

A public portfolio repo for practical infrastructure work across two tracks:

1. **Physical homelab** — Ubuntu, Docker Compose, monitoring, reverse proxying, Ansible, runbooks, and validation.
2. **AWS cloud operations lab** — account guardrails, IAM, networking, cost controls, monitoring, backup/restore, Terraform, and CI/CD validation as the project progresses.

The goal is to show a realistic progression from local infrastructure operations to public cloud operations without overstating what has been completed.

## Project Tracks

| Track | Status | Location | Purpose |
|---|---|---|---|
| Physical Homelab | Active / documented | [`homelab-infra-platform/`](homelab-infra-platform/) | Proves Linux, Docker Compose, monitoring, reverse proxy, Ansible, and operational documentation skills. |
| AWS Cloud Operations | Phase 0 started | [`aws-cloud-ops/`](aws-cloud-ops/) | Translates homelab infrastructure patterns into AWS with account guardrails, cost controls, IAM, networking, monitoring, and later Terraform/CI validation. |

## Current Focus

The current focus is the AWS Cloud Operations Mini-Platform.

Phase 0 is focused on safety before deployment:

- Use AWS instead of splitting focus across multiple cloud platforms.
- Use non-root admin access for normal AWS work.
- Keep root reserved for root-required account tasks.
- Confirm billing visibility before creating resources.
- Use a low initial budget threshold of `$5`.
- Document decisions as they become true instead of creating large placeholder documentation.

## Documentation Rule

This repo should stay lean.

New documentation should be added only when there is real progress to document, such as:

- a deployed EC2 instance,
- a VPC or security group design,
- a CloudWatch alarm,
- an S3 backup/restore path,
- a Terraform rebuild,
- a GitHub Actions validation workflow,
- or a completed incident/restore drill.

Planned work should be labeled as planned. Completed work should be backed by commands, screenshots, runbooks, or configuration files.

## Portfolio Story

This repo is meant to support the following interview narrative:

> I started by building and documenting a physical Ubuntu-based infrastructure homelab, then began translating those same operations patterns into AWS. The goal was not just to deploy services, but to secure them, monitor them, control cost, document recovery paths, and eventually manage the infrastructure with Terraform and CI validation.

## Important Boundaries

This is a lab and portfolio repo, not a production environment.

Do not commit:

- AWS credentials,
- private keys,
- local inventory files,
- `.env` files,
- Terraform state,
- screenshots containing sensitive account details,
- or local-only AI/agent instructions.
