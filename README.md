# Infrastructure Lab

## Goal

I built this repository to show how my infrastructure work progressed from a physical Ubuntu homelab into a small AWS cloud-operations environment.

The two projects share the same operating priorities: understand the request path, limit administrative exposure, collect useful telemetry, validate the system with direct evidence, and document unfinished work without presenting it as complete.

## Decisions

| Decision | Why I made it |
|---|---|
| One repository, two project tracks | Keeping the physical and cloud builds together makes the progression between them visible. |
| Physical infrastructure first | The OptiPlex lab gave me direct experience with Linux, Docker Compose, networking, monitoring, reverse proxying, and Ansible before I translated those patterns into AWS. |
| AWS as the cloud track | Focusing on one provider kept the next phase aligned with the cloud-operations roles I am targeting. |
| Manual cloud deployment before Terraform | I wanted to understand the AWS resources and failure paths before automating them. |
| Evidence before claims | I separated deployed and validated work from placeholders, scripts that still need testing, and future phases. |

## Build

| Project | Current state | What I built |
|---|---|---|
| [Homelab Infrastructure Platform](homelab-infra-platform/) | Deployed and documented | An Ubuntu monitoring host with Docker Compose, Caddy, Prometheus, Node Exporter, Grafana, Uptime Kuma, Tailscale access, and an Ansible host baseline. |
| [AWS Cloud Operations Mini-Platform](aws-cloud-ops/) | Phase 1 complete and documented | A manually deployed AWS environment with VPC networking, Ubuntu EC2, Session Manager, a Dockerized Flask service, private S3 storage, CloudWatch telemetry, and budget guardrails. |

The physical build established the local operations pattern:

```text
Laptop -> Tailscale -> Ubuntu OptiPlex -> Caddy -> monitoring services
```

That operating pattern then became the foundation for the AWS build:

```text
Browser -> VPC controls -> Ubuntu EC2 -> Dockerized service
Administrator -> Session Manager -> EC2
EC2 -> CloudWatch and private S3
```

The cloud project is not a copy of the homelab. In AWS, Tailscale and SSH administration gave way to IAM-controlled Session Manager, local host monitoring became CloudWatch telemetry, and a private S3 bucket replaced local storage concepts. Keeping the first cloud phase intentionally small made those differences visible.

## Validation

For the physical homelab, I captured Docker service state, Prometheus target health, a Grafana dashboard, and Uptime Kuma monitoring. The commands and evidence are linked from the [homelab documentation](homelab-infra-platform/README.md).

For the AWS environment, I validated the EC2 status checks, security-group rules, Session Manager access, Docker health, application endpoints, CloudWatch datapoints, S3 controls, and budget alerts. The full proof set is in the [AWS Phase 1 evidence gallery](aws-cloud-ops/docs/screenshots/README.md).

## Lessons learned

The physical lab taught me how service discovery, host ports, reverse proxying, firewall rules, and metrics collection interact on one machine. The AWS build forced me to separate those same concerns across cloud networking, IAM, instance metadata, managed access, object storage, and telemetry services.

Another lesson was the difference between an artifact and a validated capability. The homelab contains a backup script, a Terraform placeholder, and a workflow definition, but none supports a claim of tested recovery, Terraform-managed infrastructure, or active repository-level CI yet. Those capabilities become complete only after both the implementation path and evidence exist.

## Detailed documentation

- [Homelab Infrastructure Platform](homelab-infra-platform/README.md)
- [Homelab architecture](homelab-infra-platform/docs/architecture.md)
- [Homelab network and service map](homelab-infra-platform/docs/network-map.md)
- [Homelab operations runbook](homelab-infra-platform/docs/runbook.md)
- [Homelab troubleshooting record](homelab-infra-platform/docs/troubleshooting.md)
- [AWS Cloud Operations Mini-Platform](aws-cloud-ops/README.md)
