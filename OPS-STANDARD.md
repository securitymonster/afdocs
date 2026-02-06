# AI-Friendly Operational Procedures Standard (AFOPS)

Version: 0.1
Status: Draft / Working Standard
Last updated: 2026-02-06
Author: Sebastian Mang
Companion to: AI-Friendly Architecture Documentation Standard (AFADS)

## 1. Purpose

This standard defines how to write, structure, and maintain operational procedures so they are:
- **human-executable** — clear enough for an engineer to follow without prior context
- **AI-parseable** — structured so an LLM can discover, interpret, validate, and assist with execution
- **consistent across repos** — every procedure follows the same format
- **composable** — procedures reference other procedures instead of duplicating steps
- **fail-safe** — every procedure includes rollback, abort criteria, and escalation paths

### 1.1 Scope

This standard covers **planned operational procedures**:
- deployments and upgrades
- backup and restore
- maintenance and patching
- scaling operations
- data migrations
- security patching
- certificate rotation

This standard does **not** cover:
- incident response (unplanned, reactive procedures)
- post-mortem templates
- on-call schedules or escalation policies (those belong in 06-ops.md per AFADS)

### 1.2 Relationship to AFADS

AFOPS is a companion standard to AFADS. It supersedes and extends:
- AFADS section 4.2 (`docs/runbook.md`) — AFOPS defines the full structure for runbooks
- AFADS section 5.7 (`docs/architecture/06-ops.md`) — AFOPS provides the detailed procedure format that 06-ops.md references

A component documented per AFADS stores its procedures as defined by AFOPS.

---

## 2. Core Principles

### 2.1 Procedures are code
Operational procedures are version-controlled, peer-reviewed, and tested artifacts — not wiki pages that rot.

### 2.2 Procedures are composable
A procedure MUST reference other procedures by `procedure_id` rather than duplicating their steps. A deployment procedure that requires a backup first should reference the backup procedure, not inline it.

### 2.3 Procedures are explicit about state
Every procedure MUST declare:
- **preconditions** — what must be true before starting
- **postconditions** — what is true after successful completion
- **invariants** — what must remain true throughout execution

### 2.4 Procedures are fail-safe
Every procedure MUST include:
- abort criteria (when to stop)
- rollback instructions (how to undo)
- escalation path (who to contact when stuck)

### 2.5 Procedures are testable
Every procedure MUST be executable in a non-production environment. If a procedure cannot be tested, it must document why and what compensating controls exist.

### 2.6 Procedures assume no prior context
A procedure must be self-contained enough that an engineer (or AI agent) encountering it for the first time can execute it. Do not assume the reader has institutional knowledge.

---

## 3. Procedure Types

Every procedure MUST be classified as one of these types:

| Type | Description | Example |
|------|-------------|---------|
| `deploy` | Deploy or upgrade a component | Deploy api-service v1.2.3 to production |
| `rollback` | Revert a deployment or change | Rollback api-service to previous version |
| `backup` | Create a backup of data or state | Backup PostgreSQL database |
| `restore` | Restore from a backup | Restore PostgreSQL from snapshot |
| `maintenance` | Planned maintenance task | Rotate TLS certificates |
| `scale` | Scale a component up or down | Scale worker pool from 3 to 6 replicas |
| `migrate` | Migrate data or configuration | Migrate database schema to v5 |
| `patch` | Apply a security or bug fix patch | Apply CVE-2026-XXXX patch |

The `type` field in procedure metadata MUST use one of these values.

---

## 4. File Layout and Naming

### 4.1 Component repositories

Procedures live alongside the component they operate on, inside the AFADS-required `docs/` directory:

```
docs/
  runbook.md              ← AFADS required: index of procedures
  procedures/
    deploy.md
    rollback.md
    backup.md
    restore.md
    scale.md
    ...
```

### 4.2 File naming

Procedure files MUST be named using the procedure type as prefix:

```
<type>.md                  ← if there is one procedure of this type
<type>-<qualifier>.md      ← if there are multiple (e.g., deploy-canary.md, deploy-blue-green.md)
```

### 4.3 The runbook.md index

The AFADS-required `docs/runbook.md` becomes an **index file** that:
- lists all procedures for the component
- provides a quick-reference table with procedure_id, type, and criticality
- links to individual procedure files

Example:

```markdown
# Runbook: api-service

| Procedure | Type | Criticality | File |
|-----------|------|-------------|------|
| deploy-api-service | deploy | high | [procedures/deploy.md](procedures/deploy.md) |
| rollback-api-service | rollback | critical | [procedures/rollback.md](procedures/rollback.md) |
| backup-api-db | backup | high | [procedures/backup.md](procedures/backup.md) |
| restore-api-db | restore | critical | [procedures/restore.md](procedures/restore.md) |
```

### 4.4 System-level procedures (docs hub repo)

Procedures that span multiple components live in the docs hub repo:

```
docs/
  procedures/
    full-system-backup.md
    cluster-upgrade.md
    disaster-recovery.md
    ...
  procedures.yaml          ← procedure registry (see section 12)
```

---

## 5. Procedure Metadata Schema

Every procedure MUST begin with a YAML frontmatter block. This block is the primary entry point for AI/LLM parsing.

### 5.1 Required fields

```yaml
---
procedure_id: deploy-api-service
name: Deploy API Service
type: deploy
component_id: api-service                # AFADS component_id
scope: [staging, prod]                    # environments where this applies
criticality: high                         # low | medium | high | critical
owner: platform-team
last_reviewed: 2026-02-06
requires_approval: true                   # human approval needed before execution
estimated_duration: 15-30min
---
```

### 5.2 Optional fields

```yaml
depends_on_procedures: [backup-api-db]    # must run before this procedure
supersedes: deploy-api-service-v1         # replaces an older procedure
tags: [zero-downtime, helm, kubernetes]
change_window: any                        # any | maintenance-only | business-hours
rollback_procedure_id: rollback-api-service
notification_channels: ["#prod-ops"]
```

### 5.3 Field reference

| Field | Required | Type | Description |
|-------|----------|------|-------------|
| `procedure_id` | Yes | slug | Stable unique identifier |
| `name` | Yes | string | Human-readable name |
| `type` | Yes | enum | One of the types from section 3 |
| `component_id` | Yes | slug | AFADS component_id this operates on. Use `system` for cross-component procedures |
| `scope` | Yes | list | Environments where this procedure applies |
| `criticality` | Yes | enum | `low` / `medium` / `high` / `critical` |
| `owner` | Yes | string | Team responsible for maintaining this procedure |
| `last_reviewed` | Yes | date | ISO date of last review |
| `requires_approval` | Yes | boolean | Whether human approval is needed before execution |
| `estimated_duration` | Yes | string | Time range (e.g., "15-30min", "1-2h") |
| `depends_on_procedures` | No | list | Procedure IDs that must complete first |
| `supersedes` | No | slug | Procedure ID this replaces |
| `tags` | No | list | Searchable tags |
| `change_window` | No | enum | `any` / `maintenance-only` / `business-hours` |
| `rollback_procedure_id` | No | slug | Separate rollback procedure if not inline |
| `notification_channels` | No | list | Where to post status updates |

---

## 6. Procedure Body Structure

After the metadata block, every procedure MUST include these sections in order:

```
## Purpose
## Prerequisites
## Pre-flight Checks
## Steps
## Verification
## Rollback
## Escalation
## Post-procedure Tasks
```

### 6.1 Purpose

One to three sentences describing what this procedure does and when to use it.

### 6.2 Prerequisites

Structured into three subsections:

```markdown
## Prerequisites

### Access Requirements
- kubectl access to cluster: prod-eu-west
- Helm >= 3.14
- IAM role: deployer-prod

### State Requirements
- No ongoing deployments to this component
- All health checks passing
- Backup completed within last 24h (procedure: backup-api-db)

### Approval
- Change ticket: required
- Peer review: required for production
```

### 6.3 Pre-flight Checks

A numbered list of checks that MUST pass before proceeding. Each check includes:
- the command to run
- the expected output
- what to do if the check fails

See section 7 for step format.

### 6.4 Steps

The main procedure body. See section 7 for step specification and section 8 for decision points.

### 6.5 Verification

Post-execution checks that confirm success. Uses the same format as pre-flight checks.

### 6.6 Rollback

See section 9 for rollback specification.

### 6.7 Escalation

See section 10 for escalation matrix.

### 6.8 Post-procedure Tasks

A table of follow-up tasks:

```markdown
## Post-procedure Tasks

| Task | Owner | Deadline | Required |
|------|-------|----------|----------|
| Update release notes | platform-team | same day | yes |
| Notify API consumers | api-team | same day | yes |
| Review monitoring dashboards | platform-team | within 1h | yes |
```

---

## 7. Step Specification

Steps are the atomic units of a procedure. Each step MUST follow this format:

### 7.1 Step structure

```markdown
### Step N: <descriptive title>

**Abort if:** <condition that means this step should not proceed>
**Time limit:** <maximum time for this step>
**Rollback:** <how to undo this specific step, or "see Rollback section">

1. <action description>
   ```bash
   <command>
   ```
   **Expected:** <what the output should look like>
   **If unexpected:** <what to do — abort, retry, escalate>

2. <next action>
   ...
```

### 7.2 Step rules

- Steps MUST be numbered sequentially within the procedure.
- Each step MUST have a descriptive title.
- Each step MUST declare an **abort condition** — the circumstance under which to stop.
- Each step SHOULD declare a **time limit**.
- Commands MUST include **expected output** so the operator (human or AI) can verify success.
- Commands MUST include **failure guidance** — what to do if the output is not as expected.
- Steps that modify state MUST include **rollback instructions** (inline or by reference).

### 7.3 Command blocks

Commands MUST be written as executable shell blocks:

```markdown
```bash
kubectl get pods -n api -l app=api-service
```
**Expected:** All pods show `Running` status, `READY` matches `DESIRED`
**If unexpected:** Do not proceed. Check pod events with `kubectl describe pod -n api <pod-name>`
```

Do not use pseudo-code or abbreviated commands. Every command must be copy-pasteable.

### 7.4 Variable substitution

When a procedure requires environment-specific values, use clear placeholder syntax:

```
${NAMESPACE}        ← environment variable (must be set in prerequisites)
<version>           ← value provided by operator at execution time
```

Document all variables in the Prerequisites section.

---

## 8. Decision Points

Decision points are structured branching points where the operator must choose a path. They are critical for AI execution because they define where human judgment is required.

### 8.1 Decision point format

```markdown
**Decision Point:** <question>

| Condition | Action |
|-----------|--------|
| <condition A> | Continue to Step N+1 |
| <condition B> | Abort → go to Rollback |
| <condition C> | Escalate to <role> |
| Uncertain | Escalate to <role> |
```

### 8.2 Decision point rules

- Every decision point MUST include an **"Uncertain"** path. This is the default when the operator cannot determine which condition is true.
- Decision points MUST reference specific next steps, rollback, or escalation — never "use your judgment."
- For AI execution: decision points with `requires_approval: true` in the procedure metadata MUST pause for human confirmation. See section 13.

---

## 9. Rollback Specification

### 9.1 Rollback section structure

Every procedure MUST include a Rollback section with this structure:

```markdown
## Rollback

### When to rollback
- Any step in the procedure fails and cannot be resolved within the time limit
- Verification checks fail after procedure completion
- Escalation path recommends rollback

### Rollback steps

1. <rollback action>
   ```bash
   <rollback command>
   ```
   **Expected:** <what success looks like>

2. <next rollback action>
   ...

### Verify rollback
Execute the Pre-flight Checks section. All checks must pass.
If checks fail after rollback, escalate immediately.
```

### 9.2 Rollback rules

- Rollback MUST restore the system to its pre-procedure state.
- Rollback MUST include its own verification steps.
- If rollback fails, the procedure MUST define an escalation path (not another rollback attempt).
- For composed procedures (section 11): rollback MUST be defined for the composition, not just individual sub-procedures.

### 9.3 Per-step rollback

For long procedures, individual steps MAY include inline rollback:

```markdown
**Rollback:** `helm rollback api-service 1 -n api`
```

This is in addition to (not a replacement for) the procedure-level Rollback section.

---

## 10. Escalation Matrix

Every procedure MUST include an escalation matrix.

### 10.1 Escalation matrix format

```markdown
## Escalation

| Condition | Action | Escalate To | Response Time |
|-----------|--------|-------------|---------------|
| Pre-flight check fails | Abort, do not start | On-call L1 | immediate |
| Step times out | Abort, rollback | On-call L2 | 5 min |
| Verification fails after deploy | Rollback immediately | On-call L2 | 5 min |
| Rollback fails | Stop all operations | On-call L3 | immediate |
| Uncertain about any decision point | Pause and consult | Procedure owner | 15 min |
```

### 10.2 Escalation rules

- Every escalation row MUST include a **condition**, an **action**, a **target**, and a **response time**.
- The matrix MUST cover at minimum: pre-flight failure, step failure, verification failure, and rollback failure.
- Escalation targets MUST be roles (e.g., "On-call L2"), not individual names.

---

## 11. Procedure Composition

Procedures often depend on other procedures. For example, a deployment may require a backup first.

### 11.1 Referencing other procedures

Use the `depends_on_procedures` metadata field to declare dependencies:

```yaml
depends_on_procedures: [backup-api-db]
```

In the procedure body, reference the dependent procedure by ID:

```markdown
### Step 1: Create backup

Execute procedure `backup-api-db` before continuing.
Confirm postconditions of `backup-api-db` are met before proceeding to Step 2.
```

### 11.2 Composition rules

- Never duplicate steps from another procedure. Always reference by `procedure_id`.
- The calling procedure MUST verify the postconditions of the called procedure before continuing.
- Rollback of a composed procedure MUST address rollback of sub-procedures in reverse order.
- Circular dependencies are not allowed.

---

## 12. Procedure Registry

The docs hub repo MUST contain a procedure registry, analogous to the AFADS component registry.

### 12.1 File location

```
docs/procedures.yaml
```

### 12.2 Schema

```yaml
procedures:
  - procedure_id: deploy-api-service
    name: Deploy API Service
    type: deploy
    component_id: api-service
    criticality: high
    repo: github.com/<org>/api-service
    ref: main
    path: docs/procedures/deploy.md

  - procedure_id: backup-api-db
    name: Backup API Database
    type: backup
    component_id: api-database
    criticality: high
    repo: github.com/<org>/api-service
    ref: main
    path: docs/procedures/backup.md

  - procedure_id: cluster-upgrade
    name: Upgrade Kubernetes Cluster
    type: maintenance
    component_id: system
    criticality: critical
    repo: github.com/<org>/platform-docs
    ref: main
    path: docs/procedures/cluster-upgrade.md
```

### 12.3 Registry rules

- `procedure_id` MUST match the ID in the procedure's metadata block.
- `component_id` MUST match an AFADS component_id, or be `system` for cross-component procedures.
- The registry SHOULD be validated in CI (e.g., check that referenced files exist and contain valid metadata).

---

## 13. AI/LLM Execution Model

This section defines how AI agents should interact with AFOPS procedures.

### 13.1 Procedure discovery

When an AI agent needs to perform an operational task, it SHOULD:

1. Read `docs/procedures.yaml` in the docs hub repo to find available procedures.
2. Filter by `component_id`, `type`, or `tags` to find the relevant procedure.
3. Read the procedure's metadata block to assess scope, criticality, and approval requirements.
4. Read the full procedure if the metadata indicates it is applicable.

### 13.2 Pre-execution validation

Before executing any step, the AI agent MUST:

1. **Check scope** — confirm the target environment is listed in the procedure's `scope` field.
2. **Check dependencies** — if `depends_on_procedures` is set, confirm those procedures have been completed.
3. **Validate preconditions** — execute all pre-flight checks and confirm they pass.
4. **Request approval** — if `requires_approval: true`, present the procedure summary to a human and wait for explicit approval before proceeding.

### 13.3 Step execution

For each step, the AI agent MUST:

1. **Check the abort condition** — if the abort condition is true, stop and follow the abort path.
2. **Execute the command** — run the command exactly as written.
3. **Compare output to expected** — verify the output matches the expected result.
4. **Handle unexpected output** — follow the "If unexpected" guidance. Do not improvise.
5. **Log the result** — record the step number, command, output, and outcome (see section 14).

### 13.4 Decision point handling

At decision points, the AI agent MUST:

1. Evaluate the conditions in the decision table.
2. If the procedure has `requires_approval: true`, present the decision and conditions to the human operator and wait for their choice.
3. If the AI cannot determine which condition is true, follow the **"Uncertain"** path (which always escalates to a human).
4. Never guess at a decision point. If in doubt, escalate.

### 13.5 Criticality-based behavior

The AI agent SHOULD adjust its behavior based on procedure criticality:

| Criticality | AI Behavior |
|-------------|-------------|
| `low` | May execute autonomously if preconditions pass |
| `medium` | Request approval before first mutating step |
| `high` | Request approval before execution and at every decision point |
| `critical` | Request approval at every step. Present each step's output for human review before continuing |

### 13.6 Abort and rollback behavior

If the AI agent encounters a failure:

1. Stop executing further steps immediately.
2. Present the failure details to the human operator.
3. If the procedure defines inline rollback for the failed step, propose it (do not execute without approval for `high`/`critical` procedures).
4. If the human approves rollback, execute the Rollback section.
5. After rollback, execute the rollback verification steps.
6. Log the entire sequence (see section 14).

---

## 14. Audit and Execution Logging

Every execution of a procedure MUST produce a structured execution record.

### 14.1 Execution record schema

```yaml
execution_record:
  procedure_id: deploy-api-service
  execution_id: exec-20260206-143000    # unique per execution
  executed_by: alice@example.com         # or "ai-agent:<session-id>"
  executed_at: 2026-02-06T14:30:00Z
  environment: prod
  component_id: api-service
  version_deployed: v1.2.3               # if applicable
  approval_given_by: bob@example.com     # if requires_approval
  steps_completed: 4
  steps_total: 4
  outcome: success                       # success | failed | rolled_back | aborted
  duration_seconds: 1245
  rollback_required: false
  rollback_outcome: null                 # success | failed | null
  escalation_triggered: false
  notes: "Smooth deployment, metrics stable after 5 min"
```

### 14.2 Logging rules

- Execution records MUST be stored in version control or an audit system.
- For AI-executed procedures, the execution record MUST include the AI session ID.
- Failed executions MUST include the step number where failure occurred and the error output.

---

## 15. Lifecycle and Review

### 15.1 Review triggers

A procedure MUST be reviewed when:

| Trigger | Review deadline |
|---------|----------------|
| 90 days since last review | within 2 weeks |
| Procedure execution failed | within 3 business days |
| Component architecture changed | before next execution |
| Dependency procedure changed | before next execution |
| Security vulnerability affects procedure | immediate |

### 15.2 Review process

1. Create a PR with proposed changes.
2. The PR description MUST explain what changed and why.
3. The procedure owner MUST approve the PR.
4. After merge, update `last_reviewed` in the procedure metadata.

### 15.3 Deprecation

To deprecate a procedure:
1. Add `status: deprecated` to the metadata.
2. Add a `superseded_by: <new-procedure-id>` field.
3. Do not delete the file until all references to it have been updated.

---

## 16. Definition of Done

A procedure is considered **compliant** when:

- [ ] Metadata block contains all required fields (section 5.1)
- [ ] All required body sections are present (section 6)
- [ ] Every step follows the step specification (section 7)
- [ ] Every decision point includes an "Uncertain" path (section 8)
- [ ] Rollback section is complete with verification (section 9)
- [ ] Escalation matrix covers minimum required conditions (section 10)
- [ ] Procedure is registered in `procedures.yaml` (section 12)
- [ ] Procedure has been tested in a non-production environment (principle 2.5)
- [ ] `last_reviewed` date is within 90 days

---

## 17. Relationship to AFADS

### 17.1 What AFOPS supersedes

| AFADS Section | AFOPS Replacement |
|---------------|-------------------|
| 4.2 `docs/runbook.md` | AFOPS section 4.3 — runbook.md becomes an index pointing to individual procedure files |
| 5.7 `docs/architecture/06-ops.md` | 06-ops.md remains as the system-level operations overview. It references procedures by `procedure_id` rather than inlining operational steps |

### 17.2 What AFOPS does not replace

- AFADS `docs/component.md` — component documentation remains unchanged
- AFADS component registry (`components.yaml`) — AFOPS adds `procedures.yaml` alongside it, not replacing it
- AFADS ADRs — decisions about operational procedures should still be recorded as ADRs

### 17.3 Cross-references

- Procedure metadata `component_id` MUST match an AFADS `component_id`.
- The AFADS `docs/runbook.md` file MUST follow the AFOPS index format (section 4.3).
- System-level `06-ops.md` SHOULD reference procedure IDs for all operational tasks it describes.

---

## 18. Appendix A: Example Procedure

The following is an abbreviated example showing all required elements. Comments in `<!-- -->` are annotations explaining which AFOPS rule is being applied.

```markdown
<!-- Metadata block per section 5 -->
---
procedure_id: deploy-api-service
name: Deploy API Service
type: deploy
component_id: api-service
scope: [staging, prod]
criticality: high
owner: platform-team
last_reviewed: 2026-02-06
requires_approval: true
estimated_duration: 15-30min
depends_on_procedures: [backup-api-db]
rollback_procedure_id: rollback-api-service
notification_channels: ["#prod-ops"]
tags: [zero-downtime, helm]
---

<!-- Section 6.1: Purpose -->
## Purpose
Deploy a new version of api-service to the target environment using Helm.

<!-- Section 6.2: Prerequisites -->
## Prerequisites

### Access Requirements
- kubectl configured for target cluster
- Helm >= 3.14
- IAM role: deployer-${ENVIRONMENT}

### State Requirements
- Procedure `backup-api-db` completed within last 1h
- No other deployments in progress for api-service
- All pre-flight checks passing

### Approval
- Change ticket: required for prod
- Peer review: required for prod

<!-- Section 6.3: Pre-flight Checks -->
## Pre-flight Checks

1. Cluster health
   ```bash
   kubectl get nodes -o wide
   ```
   **Expected:** All nodes `Ready`
   **If unexpected:** Abort. Escalate to On-call L2.

2. Current deployment healthy
   ```bash
   kubectl get deployment api-service -n ${NAMESPACE}
   ```
   **Expected:** `READY` matches `DESIRED`, no error conditions
   **If unexpected:** Abort. Investigate before deploying.

<!-- Section 6.4: Steps, formatted per section 7 -->
## Steps

### Step 1: Verify release artifacts

**Abort if:** Release tag does not exist or chart fails linting
**Time limit:** 5 min
**Rollback:** No state changed — nothing to rollback

1. Checkout and lint:
   ```bash
   git checkout <version>
   helm lint helm/charts/api-service
   ```
   **Expected:** `1 chart(s) linted, 0 chart(s) failed`
   **If unexpected:** Abort. Do not deploy a chart that fails linting.

<!-- Decision point per section 8 -->
**Decision Point:** Is the release artifact valid?

| Condition | Action |
|-----------|--------|
| Chart lints clean, tag matches release notes | Continue to Step 2 |
| Chart has warnings | Escalate to procedure owner |
| Chart fails linting | Abort |
| Uncertain | Escalate to procedure owner |

### Step 2: Deploy

**Abort if:** Step 1 took longer than 5 minutes
**Time limit:** 15 min
**Rollback:** `helm rollback api-service -n ${NAMESPACE}`

1. Upgrade Helm release:
   ```bash
   helm upgrade api-service helm/charts/api-service \
     -n ${NAMESPACE} \
     -f helm/values-${ENVIRONMENT}.yaml \
     --timeout 10m --wait
   ```
   **Expected:** `Release "api-service" has been upgraded`
   **If unexpected:** Abort and rollback immediately.

<!-- Section 6.5: Verification -->
## Verification

1. Pod readiness:
   ```bash
   kubectl get pods -n ${NAMESPACE} -l app=api-service
   ```
   **Expected:** All pods `Running`, `READY 1/1`
   **If unexpected:** Rollback immediately.

2. Health endpoint:
   ```bash
   curl -s https://api.${ENVIRONMENT}.example.com/health | jq .status
   ```
   **Expected:** `"ok"`
   **If unexpected:** Rollback immediately.

<!-- Section 6.6 / Section 9: Rollback -->
## Rollback

### When to rollback
- Any step fails and cannot be resolved within its time limit
- Verification checks fail

### Rollback steps

1. Rollback Helm release:
   ```bash
   helm rollback api-service -n ${NAMESPACE}
   ```
   **Expected:** Previous version restored

### Verify rollback
Re-execute the Pre-flight Checks section. All checks must pass.
If checks fail after rollback, escalate to On-call L3 immediately.

<!-- Section 6.7 / Section 10: Escalation -->
## Escalation

| Condition | Action | Escalate To | Response Time |
|-----------|--------|-------------|---------------|
| Pre-flight fails | Abort | On-call L1 | immediate |
| Step times out | Rollback | On-call L2 | 5 min |
| Verification fails | Rollback | On-call L2 | 5 min |
| Rollback fails | Stop all operations | On-call L3 | immediate |
| Uncertain at decision point | Pause | Procedure owner | 15 min |

<!-- Section 6.8: Post-procedure Tasks -->
## Post-procedure Tasks

| Task | Owner | Deadline | Required |
|------|-------|----------|----------|
| Post to #prod-ops | operator | immediately | yes |
| Update release notes | platform-team | same day | yes |
| Review metrics for 30 min | platform-team | within 1h | yes |
```

---

## 19. Summary

This standard provides:
- a **structured format** for operational procedures that both humans and AI can parse
- **explicit failure handling** with rollback, abort criteria, and escalation at every level
- **composability** through procedure references instead of duplication
- a **procedure registry** for discoverability across the system
- an **AI execution model** with approval gates and criticality-based autonomy
- **audit logging** for traceability and operational reviews
- a clear **relationship to AFADS** so both standards work together
