# AGENTS.md

## Project Context

This is my homelab project for moving from help desk into cloud, DevOps, infrastructure automation, and AI infrastructure.

Primary repo:
- homelab-infra-platform/

Main goals:
- Build a low-cost, resume-worthy infrastructure automation homelab.
- Prioritize Ansible, Docker Compose, GitHub Actions, documentation, and safe operational workflows.
- Avoid fake resume claims; separate completed work from planned work.

Current hardware:
- Dell OptiPlex running Ubuntu.
- Accessed remotely from laptop using Tailscale/SSH.
- Repo is developed from the OptiPlex terminal.

## Safety Rules

- Do not run destructive commands.
- Do not delete files unless explicitly approved.
- Prefer small, reviewable changes.
- Always show `git diff` before asking me to commit.

## Repo Layout

Important path:
- homelab-infra-platform/

Expected structure:
- README.md: project overview and resume-facing explanation.
- docs/: architecture, network map, runbook, troubleshooting.
- ansible/: inventory examples, playbooks, group vars.
- docker/: compose file and environment examples.
- scripts/: healthcheck, deploy, backup scripts.
- .github/workflows/: validation CI.

## Current Priorities

1. Fix repo hygiene:
   - root `.gitignore`
   - ignore local inventory files
   - ignore Docker volumes/backups/secrets
2. Validate Ansible baseline.
3. Validate Docker Compose.
4. Improve scripts.
5. Improve documentation and README resume value.

## Definition of Done

For every task:
- Explain the change.
- Make the smallest safe edit.
- Run safe validation commands when applicable.
- Show `git status`.
- Show `git diff`.
- Summarize what changed and what remains.
