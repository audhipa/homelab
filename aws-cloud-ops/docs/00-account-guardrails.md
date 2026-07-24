# Account and Cost Guardrails

## Goal

Before deploying the lab, I wanted enough account and cost visibility to experiment without relying on memory to prevent unexpected charges.

## Decisions

I kept every Phase 1 resource in `us-east-1` so I could find, review, and remove the environment from one region. I reserved the root account for recovery and root-required settings, and I used a non-root administrator identity for normal console work.

I set the monthly lab budget to `$10`. AWS Budgets provides warnings rather than a hard spending cap, so I treated resource cleanup as the primary cost control.

## Build

I completed three guardrail layers before the main deployment:

1. I enabled MFA and avoided routine root-account use.
2. I enabled IAM user and role access to Billing and Cost Management from the root account.
3. I created budget notifications at `$1`, `$5`, and `$10` of actual spend, plus a `$10` forecast alert. I also enabled Free Tier usage notifications.

I tagged lab resources consistently:

| Key | Value |
|---|---|
| Project | `aws-cloud-ops-mini-platform` |
| Owner | `audhip` |
| Environment | `lab` |
| CostControl | `required` |
| DeleteBy | Per-resource cleanup date |

The main cost risks I tracked were running EC2 instances, orphaned EBS volumes, unattached Elastic IPs, retained CloudWatch logs, accumulated S3 objects, and resources created in the wrong region. I deliberately excluded NAT Gateway, load balancers, RDS, Fargate, and EKS from Phase 1.

## Validation

My first billing check from the non-root administrator session failed with:

```text
AccessDeniedException: IAM user access not activated
```

I traced the error to the account-level billing access setting, enabled IAM access to billing from the root account, signed out of root, and confirmed the billing view from the non-root session.

The final budget evidence shows the `$10` monthly limit and all four alert thresholds:

![AWS budget and alert thresholds](screenshots/06-budget-alerts.png)

## Lessons learned

Administrator permissions alone did not activate the Billing console for IAM identities. The account-level root setting was a separate dependency.

I also learned not to describe a budget as a spending cap. It only warns me after actual or forecasted thresholds are crossed. The practical control is still a cleanup routine that checks EC2, EBS, Elastic IPs, S3, CloudWatch logs, and current-month cost after lab work.
