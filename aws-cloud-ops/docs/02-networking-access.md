# Networking and Administrative Access

## Goal

I wanted a public application path that was easy to trace while keeping the administrative path off the public SSH port.

## Decisions

I used a `10.0.0.0/16` VPC and a `10.0.1.0/24` public subnet so I could add more subnet tiers later without redesigning the VPC. I allowed public TCP `80` for the test application and left TCP `22` closed.

I chose Systems Manager Session Manager for shell access. This removed SSH key distribution and source-IP allowlist maintenance from the first phase, while keeping access dependent on IAM permissions, the EC2 role, and the SSM agent.

## Build

The public request path was:

```text
Browser -> public IPv4 address -> internet gateway -> public route table
        -> security group TCP 80 -> EC2 host -> container port 8000
```

The network configuration was:

| Item | Value |
|---|---|
| VPC CIDR | `10.0.0.0/16` |
| Public subnet CIDR | `10.0.1.0/24` |
| Public route | `0.0.0.0/0` to the internet gateway |
| Application ingress | TCP `80` |
| SSH ingress | None |

For administration, I attached the SSM-managed instance permissions to the EC2 role and connected through Session Manager. The session ran as `ssm-user` on the Ubuntu host.

## Validation

I checked the network path in layers:

1. The route table was associated with the public subnet.
2. The security group allowed the intended source and TCP port `80`.
3. No inbound SSH rule existed.
4. The host listened on the published application port.
5. The Docker container was running and healthy.
6. The request returned the Flask response rather than the nginx default site.

![Security-group inbound rules](screenshots/02-network-controls.png)

The security-group evidence shows public HTTP on TCP `80` and no inbound SSH rule.

![Session Manager application validation](screenshots/03-session-and-health.png)

The terminal evidence shows the healthy container, successful endpoint checks, and the CloudWatch Agent state.

## Lessons learned

Security groups are stateful, so I did not need a separate inbound rule for response traffic. I also learned to separate routing from exposure: the internet gateway and public route made a path possible, but the security group and listening process determined whether the service was reachable.

Session Manager simplified key management, but it did not remove access controls. A working session still depended on the operator's IAM permissions, the EC2 instance role, and a functioning SSM agent path.
