# Phase 1 Evidence Gallery

## Goal

I kept the evidence set small and focused on claims that configuration files or prose could not prove by themselves. Each image records an actual deployment state or validation result from Phase 1.

## Decisions

I chose six screenshots that cover compute, network exposure, runtime health, storage controls, telemetry, and cost alerts. I cropped repeated browser chrome and removed account IDs, IP addresses, resource IDs, ARNs, email addresses, session identifiers, internal hostnames, and globally unique bucket names.

I retained service names, states, ports, metric names, policy names, and timestamps because they are the parts that support the technical story.

## Evidence

| Evidence | What I validated |
|---|---|
| [EC2 overview](01-ec2-overview.png) | The instance was running, passed both status checks, used the expected Availability Zone and instance type, had the security group and IAM role attached, and required IMDSv2. |
| [Network controls](02-network-controls.png) | The security group allowed public HTTP on TCP `80` and had no inbound SSH rule. |
| [Session and health](03-session-and-health.png) | The container was healthy, `/health` and `/version` returned HTTP `200`, and the CloudWatch Agent was running and configured. |
| [S3 private controls](04-s3-private-controls.png) | All four Block Public Access settings were enabled, versioning was enabled, and default encryption used SSE-S3. |
| [CloudWatch telemetry](05-cloudwatch-evidence.png) | Recent memory and disk datapoints reached CloudWatch with the Average statistic, 5-minute period, and 1-hour range. |
| [Budget alerts](06-budget-alerts.png) | The `$10` monthly budget and actual/forecast alert thresholds were configured. |

## Lessons learned

A screenshot is useful only when it proves a meaningful claim. I did not keep separate images for Docker versions, every endpoint, each CloudWatch log group, or every VPC component because those would repeat evidence without strengthening the project story.

I also learned to preserve evidence integrity while sanitizing it. I removed identifiers that created unnecessary exposure, but kept the configuration outcome readable. The result is enough to verify the Phase 1 claims without publishing account-specific details.
