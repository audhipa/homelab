# AWS Cloud Operations Mini-Platform

A small AWS-first cloud operations lab designed to translate physical homelab infrastructure skills into public cloud operations.

The goal is to build a cheap, understandable, interview-defensible AWS project that demonstrates account safety, IAM, networking, monitoring, logging, backup/restore thinking, cost controls, and eventually Terraform and CI/CD validation.

## Current Status

Phase 0: **account guardrails and project setup**.

Completed or started:

- AWS-first direction selected.
- Region selected: `us-east-2` / Ohio.
- Non-root admin access created and used for daily console work.
- Admin user/session observed as `audhip-admin`.
- Permission set/role observed as `AdminAccess`.
- Billing access issue for non-root admin was diagnosed and resolved through a root-required account setting.

Not yet claimed as complete:

- EC2 deployment.
- VPC/subnet/security group buildout.
- S3 backup path.
- CloudWatch alarms/logging.
- Terraform rebuild.
- GitHub Actions validation.
- Incident/restore drill.

## MVP Direction

Planned minimum architecture:

- One AWS account with Phase 0 guardrails.
- One region: `us-east-2` / Ohio.
- One VPC.
- One public subnet.
- One Ubuntu EC2 instance.
- One small Dockerized service or monitoring target.
- Minimal inbound security group rules.
- IAM role for the instance.
- S3 bucket for backups or artifacts.
- CloudWatch metrics, logs, and alarms.
- AWS Budget alert.

## Cost Control Baseline

Initial budget threshold:

```text
$5/month
```

Do not deploy lab resources until billing visibility and budget alerting are confirmed.

## Documentation

Current docs:

- [`docs/00-account-guardrails.md`](docs/00-account-guardrails.md)

Future docs should be added only after the corresponding work exists.

Recommended future order:

1. EC2 deployment notes.
2. Networking and security group notes.
3. Monitoring and logging notes.
4. Backup and restore notes.
5. Terraform workflow notes.
6. CI/CD validation notes.
7. Incident/restore drill notes.

## Interview Summary

> I built a small AWS cloud operations lab to translate my physical homelab experience into public cloud. Phase 0 focused on safe account setup: using non-root admin access, keeping root for root-only tasks, enabling billing visibility, setting a low budget threshold, and documenting the safety baseline before deploying infrastructure.
