# Storage, Monitoring, and Cost Controls

## Goal

I wanted the lab to include three operational controls beyond simply running an EC2 instance: private object storage, telemetry that proved the host was observable, and budget warnings that made cost visible.

## Decisions

I used S3 for test artifacts rather than public website content. I blocked all public access, enforced bucket ownership, enabled versioning, and used SSE-S3 default encryption.

I used the CloudWatch Agent because default EC2 metrics do not include the host memory and disk measurements I wanted. I kept the monthly budget at `$10` and excluded higher-cost services from Phase 1.

## Build

### Private S3 storage

I configured the bucket with:

| Control | Setting |
|---|---|
| Block Public Access | All four settings enabled |
| Object Ownership | Bucket owner enforced; ACLs disabled |
| Versioning | Enabled |
| Default encryption | SSE-S3 |
| Public bucket policy | None |

### CloudWatch telemetry

I installed and configured the CloudWatch Agent on the EC2 host. The final setup combined default EC2 metrics with agent-collected memory and disk metrics. Docker Compose also used the `awslogs` driver to send application logs to CloudWatch Logs in `us-east-1`.

### Cost controls

I configured a `$10` monthly budget with notifications at:

- `$1` actual spend;
- `$5` actual spend;
- `$10` actual spend;
- `$10` forecasted spend.

I also enabled Free Tier usage notifications and omitted NAT Gateway, Elastic Load Balancing, RDS, Fargate, and EKS from this phase.

## Validation

### S3 controls

![S3 public-access block, versioning, and encryption](screenshots/04-s3-private-controls.png)

The console evidence shows all four Block Public Access settings, versioning, and SSE-S3 encryption without exposing the bucket name.

### CloudWatch telemetry

![Recent CloudWatch memory and disk metrics](screenshots/05-cloudwatch-evidence.png)

I confirmed recent memory and disk datapoints using the Average statistic, a 5-minute period, and a 1-hour view. This proved that telemetry reached CloudWatch rather than merely showing that the agent was installed.

### Budget alerts

![AWS budget and alert thresholds](screenshots/06-budget-alerts.png)

The budget evidence shows the monthly limit and actual/forecast thresholds while excluding notification recipients.

## Lessons learned

Monitoring had two separate success conditions: the agent had to be running on the host, and CloudWatch had to show recent datapoints. I did not consider the setup complete until both were true.

Versioning and encryption improved the S3 baseline, but they did not make the bucket private on their own. Blocking public access and avoiding a public bucket policy were separate controls.

The budget reduced the chance of silent cost growth, but it was not a hard cap. Cleanup and deliberate service selection remained the real controls.
