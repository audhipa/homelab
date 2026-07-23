# Account Guardrails

Phase 0 made the AWS account safe enough for low-cost experimentation before Phase 1 resources were deployed.

## Region

Chosen region:

```text
us-east-1 / US East (N. Virginia)
```

Reason:

- The Phase 1 resources are kept in `us-east-1`.
- Keeping one region reduces confusion and lowers the chance of losing track of resources.
- The region should stay consistent unless there is a specific reason to change.

## Root Account

Root usage policy:

- Root is not used for daily AWS work.
- Root is reserved for account recovery and root-required account tasks.

Root-required task completed:

- Enabled IAM user/role access to Billing and Cost Management information.

## Daily Admin Access

Normal AWS console work should use non-root admin access.

Observed admin identity:

```text
User/session: audhip-admin
Permission set/role: AdminAccess
```

Purpose:

- Used for normal AWS console administration.
- Avoids routine root usage.
- Creates a cleaner access model for lab operations.

## Billing Access Troubleshooting

Initial issue:

The non-root admin user initially saw an error in the AWS Console Cost and Usage widget.

Observed error:

```text
AccessDeniedException: IAM user access not activated
```

Cause:

- Billing and Cost Management console access for IAM users/roles had not yet been activated from the root account.

Resolution:

1. Signed in as root.
2. Enabled IAM User and Role Access to Billing Information.
3. Signed out of root.
4. Returned to the `audhip-admin` non-root admin session.

Why this matters:

- Billing visibility is a Phase 0 guardrail.
- The project should not deploy AWS resources until cost visibility and budget alerting are confirmed.
- This was a normal account-setup issue, not a project failure.

## Budget Controls

Monthly lab budget:

```text
$10/month
```

Configured alert points:

- `$1` actual spend.
- `$5` actual spend.
- `$10` actual spend.
- `$10` forecasted spend.
- Free Tier usage notifications enabled.

AWS Budgets sends warnings; it is not a hard spending cap. Resource cleanup remains the main cost control.

## Tagging Standard

Use these tags for AWS lab resources:

| Key | Value |
|---|---|
| Project | aws-cloud-ops-mini-platform |
| Owner | audhip |
| Environment | lab |
| CostControl | required |
| DeleteBy | Per-resource cleanup date in `YYYY-MM-DD` format |

## Known Cost Risks

Watch for:

- EC2 instances left running.
- EBS volumes left behind after instance deletion.
- Elastic IPs left unattached.
- CloudWatch log groups retained too long.
- S3 objects accumulating.
- NAT Gateway created accidentally.
- Load balancers created before they are needed.
- RDS, ECS/Fargate, or EKS created too early.
- Resources deployed in the wrong region.

## Cleanup Rule

All lab resources must have either:

- a documented reason to remain active, or
- a documented cleanup/destroy path.

Before ending a work session, check:

- EC2 instances.
- EBS volumes.
- Elastic IPs.
- S3 buckets.
- CloudWatch log groups.
- Current month cost.
