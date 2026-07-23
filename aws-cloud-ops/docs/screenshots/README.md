# Phase 1 Screenshot Checklist

The goal is six useful screenshots, not a console-tour photo dump. Each image must prove a configuration or validation point that the Markdown alone cannot prove.

Do not upload a screenshot until it has been reviewed in the documentation chat.

| File | Capture | Why it is worth keeping |
|---|---|---|
| `01-ec2-overview.png` | EC2 instance Summary/Details showing running state, status checks, Availability Zone, VPC/subnet, security group, and IAM role. | Proves the compute resource and ties together its identity, network placement, and role. |
| `02-network-controls.png` | Security-group inbound rules. Include the associated public route in the same image only if it remains readable. | Proves the exposed ports and, most importantly, the absence of public SSH. |
| `03-session-and-health.png` | Session Manager terminal after running `docker compose ps`, `curl -i /health`, `curl -i /version`, and the CloudWatch Agent status command. | One terminal capture proves keyless access, container state, application health, version, and agent state. |
| `04-s3-private-controls.png` | S3 Permissions/Properties showing Block Public Access, versioning, and default encryption. A two-panel composite is acceptable if labels remain readable. | Proves storage privacy and data-protection controls without needing the bucket name. |
| `05-cloudwatch-evidence.png` | Recent custom memory/disk datapoints or log events. Prefer one view that shows timestamps and the namespace/log group. | Proves telemetry reached CloudWatch; an installed agent alone is not enough. |
| `06-budget-alerts.png` | AWS Budget detail showing the `$10` budget and notification thresholds. | Proves cost guardrails existed before later project phases add resources. |

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

## Before replacing a placeholder

1. Capture the image.
2. Crop it to the proof being documented.
3. Apply redactions.
4. Send the redacted image to the documentation chat for a second review.
5. Replace the pending filename in this directory only after that review.
