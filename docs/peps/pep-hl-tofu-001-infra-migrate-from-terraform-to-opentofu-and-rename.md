# PEP-HL-TOFU-001: Migrate from Terraform to OpenTofu and rename

**ID:** PEP-HL-TOFU-001  
**Title:** Migrate from Terraform to OpenTofu and rename  
**Author:** Timo Vlot  
**Status:** Draft  
**Type:** Infrastructure  
**Priority:** Medium  
**Created:** 2026-10-10  
**Updated:** 2026-10-10  
**Supersedes:** N/A  
**Superseded-By:** N/A  

## Abstract

Move this repo from Terraform to OpenTofu, and rename everything to match: the repo (`homelab-terraform` → `homelab-opentofu`), the `terraform/` directory, docs and README. Part of the vault project `homelab-vm-provisioning-revival`.

## Motivation

OpenTofu is the open-source fork of Terraform under the Linux Foundation, after HashiCorp moved Terraform to the BSL. It's drop-in compatible for this code, which hasn't changed since 2025-01-02. Renaming now, before the revival (PEP-HL-TOFU-002), means the new work starts on the final names.

## Specification

### Requirements

- `tofu` replaces `terraform` in every command, doc and script
- Directory `terraform/` renamed (e.g. `tofu/` or `infra/`)
- GitHub repo renamed to `homelab-opentofu`; local clone remote updated
- State carried over intact (today: local `terraform.tfstate`, untracked)
- Provider lock file regenerated with `tofu init`
- PEP codes: this repo already uses `PEP-HL-TOFU-NNN`

### Implementation Approach

1. Install OpenTofu; `tofu init` and `tofu plan` against the existing state; expect no changes
2. Rename the directory and update references
3. Rename the GitHub repo (GitHub redirects the old URL), then `git remote set-url origin git@github.com:Vlot-Ltd/homelab-opentofu.git`
4. Update vault notes and links that name `homelab-terraform`

### Success Criteria

- `tofu plan` runs clean with no unexpected changes
- No `terraform` command left in docs or scripts (provider and block names like `terraform {}` stay; that's OpenTofu syntax too)
- Repo, directory and docs all say OpenTofu

## Implementation Plan

### Phase 1: tool swap

1. Back up `terraform.tfstate`; `tofu init`; `tofu plan`

### Phase 2: rename

1. Directory, docs, README, pre-commit hooks
2. GitHub repo rename and remote update

## Testing Strategy

`tofu plan` before and after the rename shows the same result.

## Documentation Requirements

README, vault notes that mention `homelab-terraform`, the `.peprc` project name (already "Homelab OpenTofu").

## Risks and Mitigation

- State drift since 2025: the plan may show changes unrelated to the swap. Read it before applying anything.
- Old remote URL in other clones: GitHub redirects, but update them anyway.

**Backout:** keep the state backup; Terraform can still read the state if OpenTofu is dropped. The repo rename can be reversed in GitHub settings.

## References

- PEP-HL-TOFU-002 (revive provisioning)
- PEP-HL-PKR-001 (homelab-packer)
- Vault: `30-projects/homelab-vm-provisioning-revival.md`

## Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 0.1 | 2026-10-10 | Timo Vlot | Initial draft |
