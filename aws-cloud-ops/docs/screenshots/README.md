# Phase 1 Evidence Gallery

This is a deliberately small evidence set, not a console-tour photo dump. Each image proves a configuration or validation point that the Markdown alone cannot prove.

| Evidence | What it proves | Why it is worth keeping |
|---|---|---|
| [EC2 overview](01-ec2-overview.png) | Running state, status checks, Availability Zone, instance type, security group, IAM role, and IMDSv2. | Connects compute placement, identity, and host security in one view. |
| [Network controls](02-network-controls.png) | Public HTTP on TCP `80` and no inbound SSH rule. | Shows the actual attack-surface decision. |
| [Session and health](03-session-and-health.png) | Healthy container, HTTP `200` from `/health` and `/version`, and a running/configured CloudWatch Agent. | Combines the highest-value runtime checks in one terminal capture. |
| [S3 private controls](04-s3-private-controls.png) | All four Block Public Access settings, versioning, and SSE-S3 encryption. | Proves storage privacy and data-protection controls without exposing the bucket name. |
| [CloudWatch evidence](05-cloudwatch-evidence.png) | Recent memory and disk datapoints with Average statistic, 5-minute period, and 1-hour range. | Proves telemetry reached CloudWatch; agent installation alone would not. |
| [Budget alerts](06-budget-alerts.png) | `$10` monthly budget and actual/forecast alert thresholds. | Proves cost guardrails existed before later phases add resources. |

## Capture requirements

- Use a desktop-sized capture and crop away unrelated browser chrome.
- Keep service names, states, ports, timestamps, metric names, and policy names readable.
- Use a consistent image width where practical.
- Do not draw large opaque boxes over half the screenshot. Crop first, then redact only the remaining sensitive fields.
- Do not use an incognito `AccessDenied` screenshot as separate evidence; the S3 permissions view is stronger and more compact.
- Do not add separate screenshots for Docker version, Compose version, every endpoint, every CloudWatch log group, or every VPC component.

## Redact or remove

- AWS account ID and ARN account-number segments.
- Email addresses, budget notification recipients, and billing details.
- Public and private IP addresses unless the private address is intentionally generalized.
- Globally unique S3 bucket names.
- Session IDs, request IDs, resource IDs, and browser URLs containing identifiers.
- Access keys, secret keys, session tokens, cookies, credentials, QR codes, or recovery codes. If any credential appears, do not merely blur it; revoke/rotate it and recapture the screen.
- Unrelated account names, bookmarks, tabs, desktop notifications, and local usernames.

Resource display names such as `cloud-ops-web-sg` and policy names such as `AmazonSSMManagedInstanceCore` are useful evidence and normally do not need redaction.

All six images were cropped, redacted, and reviewed before publication. Redactions remove identifiers rather than configuration outcomes, so the evidence remains useful without exposing account details.
