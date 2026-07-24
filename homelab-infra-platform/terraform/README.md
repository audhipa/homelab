# Terraform Boundary

## Goal

This directory marks where infrastructure as code can enter the project once there is a real provider-backed resource to manage.

## Decisions

No placeholder `.tf` files or claims of Terraform-managed infrastructure appear here. The current homelab services run through Docker Compose, and Ansible manages the Ubuntu host baseline. Terraform becomes useful when the project adds resources such as cloud infrastructure, virtual machines, DNS records, or provider-supported network controls.

The future Terraform safety model is also separate from local configuration:

- provider credentials will stay outside the repository;
- environment values will not be committed in real `.tfvars` files;
- `terraform plan` will be reviewed before an apply;
- state storage and locking will be selected before collaborative or remote use;
- modules will be introduced only when repeated infrastructure justifies them.

## Build

There is no Terraform implementation in the current phase. The expected structure is:

```text
terraform/
├── environments/
│   └── dev/
├── modules/
└── README.md
```

## Validation

Because the directory contains no Terraform configuration, there is no `terraform fmt`, `terraform validate`, plan, apply, or state evidence to report yet.

When the first managed resource is added, completion will require at least:

```bash
terraform fmt -check -recursive
terraform init
terraform validate
terraform plan
```

An apply will not count as reproducible until the test resource can be destroyed or otherwise removed and rebuilt from the committed configuration.

## Lessons Learned

Creating a Terraform directory is not infrastructure as code. The proof begins when a provider-backed resource is represented in configuration, validated, planned, applied, and reconciled with its actual state.

Deferring Terraform here also keeps tool ownership clear: Compose defines the containers, Ansible defines the current host baseline, and Terraform currently manages nothing.
