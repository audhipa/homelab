# Phase 1 Architecture

## Goal

I designed Phase 1 as a small manual deployment that connected AWS networking, compute, identity, containers, storage, monitoring, and cost controls without adding managed services that did not support the first operations story.

## Decisions

I used a single VPC, public subnet, EC2 instance, and Availability Zone. This kept the request path visible and the monthly cost low.

I chose Session Manager for administration instead of public SSH. I used an EC2 instance role so the host could reach Systems Manager and CloudWatch without static AWS credentials. I kept S3 outside the public request path and blocked public bucket access.

I did not add a load balancer, private application subnet, database, autoscaling group, NAT Gateway, or container orchestrator. Those services would have introduced cost and new failure modes before I had validated the base system.

## Build

```mermaid
flowchart TD
    internet["Internet"] --> igw["Internet gateway"]
    igw --> route["Public route table<br/>0.0.0.0/0"]
    route --> subnet["Public subnet<br/>10.0.1.0/24"]
    subnet --> sg["Web security group"]
    sg --> ec2["Ubuntu EC2"]
    ec2 --> app["Dockerized Flask app"]

    ssm["Systems Manager"] -->|"IAM-authorized shell"| ec2
    ec2 --> cw["CloudWatch logs + metrics"]
    ec2 --> s3["Private S3 storage"]
```

| Component | Role in my build |
|---|---|
| VPC `10.0.0.0/16` | Created the network boundary and room for later subnet separation. |
| Public subnet `10.0.1.0/24` | Hosted the Phase 1 EC2 instance. |
| Internet gateway and route table | Provided public HTTP access and outbound package retrieval. |
| Security group | Allowed application traffic on TCP `80` without allowing public SSH. |
| Ubuntu EC2 | Ran Docker, the Flask application, and the CloudWatch Agent. |
| EC2 instance role | Supplied SSM and CloudWatch permissions without stored access keys. |
| Session Manager | Provided administrative shell access. |
| Private S3 bucket | Stored test artifacts with public access blocked. |
| CloudWatch | Received host metrics and application logs. |
| AWS Budgets | Warned when actual or forecasted spend crossed my lab thresholds. |

## Validation

I confirmed the instance was running, both EC2 status checks passed, the expected Availability Zone and instance type were visible, an IAM role was attached, and IMDSv2 was required.

![EC2 instance overview](screenshots/01-ec2-overview.png)

I then validated the architecture through the request path and control plane: public HTTP reached port `80`, Session Manager reached the host without SSH, the container served the Flask endpoints, CloudWatch received telemetry, and the S3 bucket remained private.

## Lessons learned

A route to an internet gateway does not expose a workload by itself. The request still has to pass the security group and reach a process listening on the mapped host port.

Keeping the first architecture small made troubleshooting clearer. When the health check failed, I could isolate the issue among nginx, the host listener, Docker's port mapping, and the Flask route instead of debugging through a load balancer or orchestration layer.
