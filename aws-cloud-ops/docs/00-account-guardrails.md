# Account and Cost Guardrails

## Goal

Before deploying the lab, I wanted enough account and cost visibility to experiment without relying on memory to prevent unexpected charges.

## Decisions

Keeping every Phase 1 resource in `us-east-1` made the environment easier to find, review, and remove from one region. The root account remained reserved for recovery and root-required settings, while normal console work used a non-root administrator identity.

The monthly lab budget was set to `$10`. Because AWS Budgets provides warnings rather than a hard spending cap, resource cleanup remained the primary cost control.

## Build

Three guardrail layers came before the main deployment:

1. MFA protected the account, and the root identity stayed out of routine use.
2. From the root account, I enabled IAM user and role access to Billing and Cost Management.
3. Budget notifications covered `$1`, `$5`, and `$10` of actual spend plus a `$10` forecast alert, with Free Tier usage notifications enabled as well.

Lab resources received a consistent tag set:

| Key | Value |
|---|---|
| Project | `aws-cloud-ops-mini-platform` |
| Owner | `audhip` |
| Environment | `lab` |
| CostControl | `required` |
| DeleteBy | Per-resource cleanup date |

The main cost risks were running EC2 instances, orphaned EBS volumes, unattached Elastic IPs, retained CloudWatch logs, accumulated S3 objects, and resources created in the wrong region. To limit that exposure, Phase 1 deliberately excluded NAT Gateway, load balancers, RDS, Fargate, and EKS.

## Validation

My first billing check from the non-root administrator session failed with:

```text
AccessDeniedException: IAM user access not activated
```

Tracing the error led to the account-level billing access setting. After enabling IAM access to billing from the root account and signing out, I confirmed the billing view from the non-root session.

The final budget evidence shows the `$10` monthly limit and all four alert thresholds:

![AWS budget and alert thresholds](screenshots/06-budget-alerts.png)

## Lessons learned

Administrator permissions alone did not activate the Billing console for IAM identities. The account-level root setting was a separate dependency.

The budget also cannot be described as a spending cap; it only warns me after actual or forecasted thresholds are crossed. The practical control is still a cleanup routine that checks EC2, EBS, Elastic IPs, S3, CloudWatch logs, and current-month cost after lab work.
