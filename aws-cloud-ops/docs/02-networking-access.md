# Networking and Administrative Access

## Network design

| Item | Phase 1 value | Purpose |
|---|---|---|
| VPC CIDR | `10.0.0.0/16` | Leaves room for later subnet separation without changing the VPC. |
| Public subnet CIDR | `10.0.1.0/24` | Hosts the manually deployed EC2 instance. |
| Public route | `0.0.0.0/0` to the internet gateway | Enables public HTTP testing and outbound package retrieval. |
| Application ingress | TCP `80` | Public test path to the web service. |
| SSH ingress | None | Administration uses Session Manager. |

Security groups are stateful, so response traffic for an allowed connection does not require a separate inbound rule. The public route alone does not expose the instance; traffic still has to pass the security group and reach a listening process.

## Request path

```text
Browser -> public IPv4 address -> internet gateway -> public route table
        -> security group TCP 80 -> EC2 host -> container port 8000
```

Each hop is checked separately during troubleshooting:

1. Confirm the route table is associated with the subnet.
2. Confirm the security group allows the intended port and source.
3. Confirm the host is listening on the mapped port.
4. Confirm the container is running and healthy.
5. Confirm the request is reaching the Flask service rather than an nginx default site.

## Session Manager access

Recorded Phase 1 output:

```text
whoami
ssm-user

hostname
ip-10-0-1-171
```

Session Manager is the normal administration path. This avoids a public SSH rule, SSH key distribution, and source-IP maintenance. It does not make access permissionless: the operator still needs the appropriate IAM permissions, and the instance needs the SSM-managed instance policy and a working SSM agent path.

## Evidence placeholders

Add these sanitized screenshots:

```text
docs/screenshots/02-network-controls.png
docs/screenshots/03-session-and-health.png
```

`02-network-controls.png` should show the inbound security-group rules and enough route-table context to prove the public path. `03-session-and-health.png` should show the Session Manager shell plus the validation commands listed in the compute document.
