# Terraform Placeholder

This directory is reserved for future Terraform code.

Use Terraform only when there is an actual infrastructure target to manage, such as:

- Cloud resources.
- Virtual machines.
- DNS records.
- Firewall or network resources with provider support.

## Safety Notes

- Do not commit `.tfvars` files containing real values.
- Do not commit provider credentials.
- Use `terraform plan` before any apply.
- Keep modules small and documented.

## Future Structure

```text
terraform/
├── environments/
│   └── dev/
├── modules/
└── README.md
```
