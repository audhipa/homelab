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

The evidence image proves the actual console settings without publishing the globally unique bucket name.

## CloudWatch collection

The CloudWatch Agent was recorded as running and configured on the EC2 host. Phase 1 evidence includes:

- default EC2 metrics in `AWS/EC2`;
- agent-collected memory and disk metrics in the configured custom namespace.

The documentation does not treat an installed agent as proof that telemetry arrived. The console capture shows recent datapoints for both host metrics.

## Cost controls

The monthly lab budget is `$10`, with notifications at:

- `$1` actual;
- `$5` actual;
- `$10` actual;
- `$10` forecasted.

Free Tier usage notifications are enabled. Budgets are warnings rather than hard caps, so cleanup checks remain part of each work session.

High-cost services deliberately left out of Phase 1 include NAT Gateway, Elastic Load Balancing, RDS, Fargate, and EKS.

## Evidence

### S3 controls

![S3 public-access block, versioning, and encryption](screenshots/04-s3-private-controls.png)

### CloudWatch telemetry

![Recent CloudWatch memory and disk metrics](screenshots/05-cloudwatch-evidence.png)

### Budget alerts

![AWS budget and alert thresholds](screenshots/06-budget-alerts.png)

Notification recipients are intentionally excluded from the public evidence.
