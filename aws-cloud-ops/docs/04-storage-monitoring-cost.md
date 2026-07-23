# Storage, Monitoring, and Cost Controls

## Private S3 storage

The Phase 1 bucket is for test backups or artifacts, not public website content.

Expected controls in the deployed configuration:

| Control | Phase 1 setting |
|---|---|
| Block Public Access | All four settings enabled |
| Object Ownership | Bucket owner enforced; ACLs disabled |
| Versioning | Enabled |
| Default encryption | SSE-S3 |
| Public bucket policy | None |

The screenshot must prove the actual console settings. Do not publish the globally unique bucket name; it is not needed to explain the control design.

## CloudWatch collection

The CloudWatch Agent was recorded as running and configured on the EC2 host. Phase 1 monitoring should make the following evidence visible:

- default EC2 metrics in `AWS/EC2`;
- agent-collected memory and disk metrics in the configured custom namespace;
- system or application log groups;
- a basic EC2 status-check alarm if it was created.

The documentation does not treat an installed agent as proof that telemetry arrived. The console screenshot must show recent datapoints or recent log events.

## Cost controls

The monthly lab budget is `$10`, with notifications at:

- `$1` actual;
- `$5` actual;
- `$10` actual;
- `$10` forecasted.

Free Tier usage notifications are enabled. Budgets are warnings rather than hard caps, so cleanup checks remain part of each work session.

High-cost services deliberately left out of Phase 1 include NAT Gateway, Elastic Load Balancing, RDS, Fargate, and EKS.

## Evidence placeholders

Add these sanitized screenshots:

```text
docs/screenshots/04-s3-private-controls.png
docs/screenshots/05-cloudwatch-evidence.png
docs/screenshots/06-budget-alerts.png
```

The screenshot checklist explains the minimum useful fields and the redactions required before publication.
