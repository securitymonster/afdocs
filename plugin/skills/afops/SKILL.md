---
name: afops
description: "AI-Friendly Operational Procedures Standard. Use when documenting deployments, rollbacks, backups, restores, scaling, maintenance, migrations, or patching procedures."
user-invocable: true
---

# AFOPS — AI-Friendly Operational Procedures Standard

Use this skill to document operational procedures that are fail-safe, composable, and executable by humans or AI agents.

## When to Use

- Writing deployment, rollback, or scaling procedures
- Documenting backup and restore processes
- Creating maintenance or patching runbooks
- Setting up operational procedure registries
- Defining escalation matrices and approval workflows

## Key Deliverables

```
docs/
  runbook.md              ← index of all procedures (AFADS required)
  procedures/
    deploy.md             ← one file per procedure
    rollback.md
    backup.md
    restore.md
    scale.md
    ...
  procedures.yaml         ← procedure registry
```

## Procedure Types

| Type | Description |
|------|-------------|
| `deploy` | Deploy or upgrade a component |
| `rollback` | Revert a deployment or change |
| `backup` | Create a backup of data or state |
| `restore` | Restore from a backup |
| `maintenance` | Planned maintenance task (cert rotation, etc.) |
| `scale` | Scale a component up or down |
| `migrate` | Migrate data or configuration |
| `patch` | Apply a security or bug fix patch |

## Procedure Metadata Schema

```yaml
---
procedure_id: deploy-api-service
name: Deploy API Service
type: deploy
component_id: api-service              # AFADS component_id
scope: [staging, prod]
criticality: high                      # low | medium | high | critical
owner: platform-team
last_reviewed: 2026-02-06
requires_approval: true
estimated_duration: 15-30min
depends_on_procedures: [backup-api-db] # optional: must run first
rollback_procedure_id: rollback-api-service  # optional
change_window: any                     # any | maintenance-only | business-hours
notification_channels: ["#prod-ops"]   # optional
---
```

## Required Body Sections

Every procedure MUST include these sections in order:

```markdown
## Purpose
One to three sentences: what this does and when to use it.

## Prerequisites

### Access Requirements
- kubectl access to cluster: prod
- Helm >= 3.14

### Dependencies
- Procedure `backup-api-db` must complete first

### Approval
- Requires sign-off from: on-call lead

## Pre-flight Checks
1. Verify cluster is healthy: `kubectl get nodes`
   **Expected:** All nodes `Ready`
   **Abort if:** Any node `NotReady`

## Steps

### Step 1: <title>
**Abort if:** <condition>
**Time limit:** <duration>
**Rollback:** <how to undo this step>

1. <action>
   ```bash
   <command>
   ```
   **Expected:** <output>
   **If unexpected:** <guidance>

### Step 2: <title>
...

## Verification
1. Check endpoint health
   ```bash
   curl https://api.example.com/health
   ```
   **Expected:** HTTP 200

## Rollback
1. Revert to previous version
   ```bash
   helm rollback api-service
   ```

## Escalation
| Condition | Action | Escalate to | Response time |
|-----------|--------|-------------|---------------|
| Step fails after retry | Page on-call | #incident-channel | 15 min |
| Data loss suspected | Stop all changes | Engineering lead | Immediate |

## Post-procedure Tasks
- [ ] Update deployment log
- [ ] Notify stakeholders
- [ ] Verify monitoring dashboards
```

## Procedure Registry (procedures.yaml)

```yaml
procedures:
  - procedure_id: deploy-api-service
    name: Deploy API Service
    type: deploy
    component_id: api-service
    path: docs/procedures/deploy.md
    criticality: high
    scope: [staging, prod]
    owner: platform-team
    last_reviewed: 2026-02-06
```

## Core Principles

- **Procedures are code** — version-controlled and peer-reviewed, not wiki pages
- **Composable** — reference other procedures by `procedure_id`, don't duplicate steps
- **Fail-safe** — every step has abort criteria, rollback, and escalation
- **Explicit about state** — declare preconditions, postconditions, and invariants
- **Self-contained** — executable by someone (or an AI agent) with no prior context
- **Testable** — must be executable in non-production environments

## Cross-References

- `component_id` MUST match an AFADS component
- AFSS controls may reference procedures via `verification_procedure_id`
- AFRS roadmap items may reference procedures via `procedure_id`

## Full Standard

https://github.com/securitymonster/afdocs/blob/main/OPS-STANDARD.md
