# PEP-HL-TOFU-002: Revive Proxmox VM provisioning

**ID:** PEP-HL-TOFU-002  
**Title:** Revive Proxmox VM provisioning  
**Author:** Timo Vlot  
**Status:** Draft  
**Type:** Infrastructure  
**Priority:** Medium  
**Created:** 2026-10-10  
**Updated:** 2026-10-10  
**Supersedes:** N/A  
**Superseded-By:** N/A  

## Abstract

Get the Proxmox VM module building VMs from the Packer templates again, with Salt and Vault doing configuration and secrets, so a VM can be created from code, and later by JARVIS through a controlled path. Part of the vault project `homelab-vm-provisioning-revival`.

## Motivation

The code stopped on 2025-01-02. What exists: a `proxmox-vm` module (Telmate provider `3.0.1-rc6`), an example `test-vm` module (Telmate `2.9.11`, older), a `postgres` server module that never worked ("Fiddling postgres server terraform (unsuccessfully)"), and a `salt-minion` file pushed by the module. The vault note `terraform-and-packer-fixes` lists the original plan: fix the module, add the Salt minion install, build Postgres/Zabbix/Vault/NetBox modules, then use Salt/Vault for data and configs.

## Specification

### Requirements

- One provider, pinned. Decide between Telmate (still on an RC) and `bpg/proxmox`
- Remote state, not a local file (options: Postgres backend on `postgres`, S3-compatible store, or OpenTofu's encrypted local state as a first step)
- Proxmox credentials from Vault
- New VM joins Salt automatically; Salt does all config (no config in OpenTofu beyond the VM itself)
- New VMs get the PEP-HL-SLT-018 accounts, not `proxmox`
- A JARVIS-safe entry point: JARVIS never runs `tofu apply` directly. Options: JARVIS opens a change (proposal), Timo applies; or a Salt runner wraps a fixed set of VM definitions. See vault `jarvis-access-model`.

### Implementation Approach

1. After PEP-HL-TOFU-001 and PEP-HL-PKR-001
2. Pick the provider; rewrite `proxmox-vm` against it; delete the outdated example
3. Build one throwaway VM end to end: clone template, boot, minion accepted, highstate
4. Then the server modules, starting with one that's easy to rebuild

### Success Criteria

- `tofu apply` creates a VM from `tpl-ubuntu-2404` that highstates clean with no manual steps
- `tofu destroy` removes it cleanly
- No secrets in code, state stored remotely or encrypted

## Implementation Plan

### Phase 1: module and state

### Phase 2: throwaway VM end to end

### Phase 3: server modules

### Phase 4: JARVIS entry point (design only until the JARVIS access model is settled)

## Testing Strategy

Throwaway VM per change: apply, highstate, destroy. Never test against an existing VM.

## Documentation Requirements

README with the build flow (template → tofu → Salt); vault project note.

## Risks and Mitigation

- Importing existing VMs by mistake: new VMs only, with a separate VM ID range.
- Provider switch rewrites resources: only matters for VMs managed by OpenTofu, which today is none.

**Backout:** `tofu destroy` on anything this PEP created; existing VMs are untouched.

## References

- PEP-HL-TOFU-001, PEP-HL-PKR-001
- PEP-HL-SLT-018 (users), PEP-HL-SLT-009 (Salt API) in homelab-saltstack
- Vault: `30-projects/homelab-vm-provisioning-revival.md`, `30-projects/jarvis/jarvis-access-model.md`, `20-areas/homelab/terraform-and-packer-fixes.md`

## Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 0.1 | 2026-10-10 | Timo Vlot | Initial draft |
