# AI-Friendly Roadmap Standard (AFRS)

Version: 0.1
Status: Draft / Working Standard
Last updated: 2026-02-11
Author: Sebastian Mang
Companion to: AI-Friendly Architecture Documentation Standard (AFADS),
              AI-Friendly Operational Procedures Standard (AFOPS),
              AI-Friendly Programming Standard (AFPS),
              AI-Friendly Security Standard (AFSS),
              AI-Friendly Compliance Standard (AFCS)

## 1. Purpose

This standard defines how to document, structure, and maintain roadmaps, initiatives, and work items so they are:
- **human-readable** — engineers and stakeholders can understand planned work, priorities, and progress
- **AI-parseable** — structured YAML metadata so an LLM can discover planned work, generate progress reports, and suggest priorities
- **traceable** — every work item maps to components (AFADS), procedures (AFOPS), conventions (AFPS), security controls (AFSS), or compliance requirements (AFCS)
- **hierarchical** — strategic initiatives decompose into tactical items with clear parent-child relationships
- **consistent across repos** — every roadmap artifact follows the same format
- **actionable** — every item has an owner, status, priority, and acceptance criteria

### 1.1 Scope

This standard covers:
- feature roadmaps (planned product or technical capabilities)
- technical debt registries (known debt with impact, effort, and remediation plans)
- security roadmaps (planned security improvements linked to AFSS controls and AFCS gaps)
- strategic initiatives (high-level goals that group related items)
- individual work items (features, improvements, debt items, security tasks)

### 1.2 What AFRS Is Not

AFRS is not a project management tool. It does not replace Jira, Linear, GitHub Issues, or any external tracker. It is a documentation standard for planning artifacts that AI agents and engineers can discover and act on without access to external tools.

AFRS is not a sprint planning framework. It does not define sprints, story points, velocity, or team capacity. Those concerns belong to the team's workflow tooling.

AFRS is not an incident tracker. Incidents are handled by AFOPS procedures and post-incident reviews.

### 1.3 Relationship to Other Standards

AFRS references all five existing standards:
- AFADS — roadmap items reference `component_id` to connect planned work to architecture
- AFOPS — roadmap items may reference `procedure_id` for operational improvements
- AFPS — roadmap items may reference `convention_id` for coding convention improvements
- AFSS — security roadmap items reference `control_id` and `threat_id` to connect planned security work to the control framework
- AFCS — security roadmap items may reference compliance gaps identified by AFCS mappings

---

## 2. Core Principles

### 2.1 Planned work is documented and traceable

Every roadmap item has a stable ID, maps to at least one component, and has acceptance criteria. If it is not documented, it is not planned.

### 2.2 Items have owners and status

Every item has a human or team owner and a status that reflects reality. Roadmaps without owners are wishlists.

### 2.3 Hierarchy is explicit

Roadmaps contain initiatives. Initiatives contain items. This three-level structure (roadmap → initiative → item) allows both strategic and tactical views of planned work.

### 2.4 Time is optional but supported

Target dates and time horizons are optional fields. Some items are time-bound (release milestones); others are priority-ordered without deadlines. The standard supports both without requiring either.

### 2.5 Roadmap metadata is machine-readable

All roadmap artifacts use YAML frontmatter, consistent with the pattern established by AFADS, AFOPS, AFPS, AFSS, and AFCS.

### 2.6 AI agents can discover and report on planned work

An AI agent should be able to read the roadmap artifacts and determine: what work is planned, what is in progress, what is blocked, what the priorities are, and how items connect to the architecture, security controls, and compliance posture.

---

## 3. Artifact Types

AFRS defines three artifact types:

| Artifact | Type value | Description | Scope |
|----------|-----------|-------------|-------|
| Roadmap | `roadmap` | Container document grouping related initiatives and items | System or Component |
| Initiative | (inline in roadmap) | Strategic grouping of related items within a roadmap | Roadmap |
| Roadmap Item | (inline in roadmap or standalone) | Individual actionable work item | Initiative or Roadmap |

Roadmaps have a subtype that determines their focus:

| Subtype | `roadmap_type` value | Description |
|---------|---------------------|-------------|
| Feature Roadmap | `feature` | Planned product or technical capabilities |
| Technical Debt Registry | `technical-debt` | Known debt with impact assessment and remediation plans |
| Security Roadmap | `security` | Planned security improvements linked to AFSS and AFCS |

Additionally, AFRS references these related artifacts from other standards:

| Artifact | Defined by | How AFRS uses it |
|----------|-----------|------------------|
| Component | AFADS | Roadmap items reference components via `component_id` |
| Procedure | AFOPS | Items for operational improvements reference `procedure_id` |
| Convention | AFPS | Items for convention changes reference `convention_id` |
| Security control | AFSS | Security items reference `control_id` and `threat_id` |
| Compliance mapping | AFCS | Security items reference compliance gaps from AFCS |

---

## 4. File Layout and Naming

### 4.1 System-level roadmaps (docs hub repo)

Roadmap documentation lives in the docs hub:

```
docs/
  roadmap/
    roadmaps.yaml                     ← roadmap registry (required)
    feature-2026-h1.md                ← one file per roadmap
    technical-debt.md
    security-roadmap.md
```

### 4.2 Component-level roadmaps

Components that maintain their own roadmaps (e.g., component-specific technical debt):

```
docs/
  roadmap/
    roadmaps.yaml                     ← component-level registry
    technical-debt.md                 ← component-specific debt registry
```

### 4.3 File naming

Roadmap files MUST be named using a descriptive kebab-case slug that matches the `roadmap_id`:

- Feature roadmaps: `<scope>-<period>.md` (e.g., `feature-2026-h1.md`, `feature-2026-q2.md`)
- Technical debt registries: `technical-debt.md` (or `technical-debt-<scope>.md` for scoped registries)
- Security roadmaps: `security-roadmap.md` (or `security-roadmap-<period>.md`)

### 4.4 Standalone item files (optional)

For large items that need their own document (e.g., an RFC or design doc attached to a roadmap item), create a file in a subdirectory:

```
docs/
  roadmap/
    items/
      feat-user-dashboard.md          ← standalone item with extended detail
      debt-migrate-orm.md
```

Standalone item files MUST be named using their `item_id`.

---

## 5. Roadmap Metadata Schema

Every roadmap artifact MUST begin with a YAML frontmatter block.

### 5.1 Required fields

```yaml
---
roadmap_id: feature-2026-h1
name: Feature Roadmap — 2026 H1
type: roadmap
roadmap_type: feature
status: active
owner: product-team
last_reviewed: 2026-02-11
---
```

### 5.2 Optional fields

```yaml
component_id: webapp
time_horizon: 2026-H1
tags: [frontend, api, infrastructure]
summary:
  total_items: 12
  completed: 3
  in_progress: 4
  planned: 3
  proposed: 2
  cancelled: 0
  completion_percent: 25
```

### 5.3 Field reference

| Field | Required | Type | Description |
|-------|----------|------|-------------|
| `roadmap_id` | Yes | slug | Stable unique identifier, kebab-case |
| `name` | Yes | string | Human-readable name |
| `type` | Yes | literal | Always `roadmap` |
| `roadmap_type` | Yes | enum | `feature` / `technical-debt` / `security` |
| `status` | Yes | enum | `active` / `draft` / `archived` |
| `owner` | Yes | string | Team or person responsible |
| `last_reviewed` | Yes | date | ISO date of last review |
| `component_id` | No | slug | AFADS component this roadmap is scoped to. Omit for system-level roadmaps |
| `time_horizon` | No | string | Time period this roadmap covers (e.g., `2026-H1`, `2026-Q2`, `ongoing`) |
| `tags` | No | list | Searchable tags |
| `summary` | No | object | Aggregate item statistics |
| `summary.total_items` | No | integer | Total items in this roadmap |
| `summary.completed` | No | integer | Items with status `completed` |
| `summary.in_progress` | No | integer | Items with status `in-progress` |
| `summary.planned` | No | integer | Items with status `planned` |
| `summary.proposed` | No | integer | Items with status `proposed` |
| `summary.cancelled` | No | integer | Items with status `cancelled` |
| `summary.completion_percent` | No | integer | Percentage of non-cancelled items completed |

---

## 6. Initiative Schema

Initiatives are defined inline within a roadmap document as second-level headings with a YAML metadata block.

### 6.1 Schema

```yaml
<!-- initiative -->
initiative_id: init-user-experience
name: User Experience Overhaul
status: in-progress
priority: high
owner: frontend-team
target_date: 2026-06-30
<!-- /initiative -->
```

### 6.2 Field reference

| Field | Required | Type | Description |
|-------|----------|------|-------------|
| `initiative_id` | Yes | slug | Stable unique identifier, kebab-case, prefixed with `init-` |
| `name` | Yes | string | Human-readable name |
| `status` | Yes | enum | `proposed` / `planned` / `in-progress` / `completed` / `cancelled` |
| `priority` | Yes | enum | `critical` / `high` / `medium` / `low` |
| `owner` | Yes | string | Team or person responsible |
| `target_date` | No | date | Target completion date (ISO format) |
| `completed_date` | No | date | Actual completion date (ISO format) |
| `depends_on` | No | list | Initiative IDs this initiative depends on |

---

## 7. Roadmap Item Schema

Items are defined inline within an initiative section or at the roadmap level (for roadmaps without initiatives, such as technical debt registries).

### 7.1 Required fields

```yaml
<!-- item -->
item_id: feat-user-dashboard
name: Build user dashboard
type: feature
status: in-progress
priority: high
owner: frontend-team
<!-- /item -->
```

### 7.2 Optional fields

```yaml
target_date: 2026-04-15
completed_date: 2026-04-10
component_id: webapp
initiative_id: init-user-experience
depends_on: [feat-api-user-endpoint]
control_id: auth-rls-user-profiles
threat_id: threat-disclosure-user-data-leak
procedure_id: deploy-webapp
convention_id: pattern-error-handling-load
framework_ref: OWASP-A01
effort: medium
tags: [frontend, dashboard]
```

### 7.3 Field reference

| Field | Required | Type | Description |
|-------|----------|------|-------------|
| `item_id` | Yes | slug | Stable unique identifier, kebab-case. Use type prefix: `feat-`, `debt-`, `sec-`, `imp-` |
| `name` | Yes | string | Human-readable name |
| `type` | Yes | enum | `feature` / `debt` / `security` / `improvement` |
| `status` | Yes | enum | `proposed` / `planned` / `in-progress` / `completed` / `cancelled` |
| `priority` | Yes | enum | `critical` / `high` / `medium` / `low` |
| `owner` | Yes | string | Team or person responsible |
| `target_date` | No | date | Target completion date |
| `completed_date` | No | date | Actual completion date |
| `component_id` | No | slug | AFADS component this item relates to |
| `initiative_id` | No | slug | Parent initiative (if not implied by document structure) |
| `depends_on` | No | list | Item IDs this item depends on |
| `control_id` | No | slug or list | AFSS control(s) this item relates to |
| `threat_id` | No | slug or list | AFSS threat(s) this item addresses |
| `procedure_id` | No | slug or list | AFOPS procedure(s) this item relates to |
| `convention_id` | No | slug or list | AFPS convention(s) this item relates to |
| `framework_ref` | No | string or list | AFCS compliance requirement(s) this item addresses (e.g., `OWASP-A01`) |
| `effort` | No | enum | `trivial` / `small` / `medium` / `large` / `xlarge` |
| `tags` | No | list | Searchable tags |

### 7.4 Item ID conventions

Item IDs MUST use a type prefix for discoverability:

| Type | Prefix | Example |
|------|--------|---------|
| `feature` | `feat-` | `feat-user-dashboard`, `feat-api-pagination` |
| `debt` | `debt-` | `debt-migrate-orm`, `debt-remove-legacy-auth` |
| `security` | `sec-` | `sec-add-rls-audit-table`, `sec-implement-csp` |
| `improvement` | `imp-` | `imp-ci-pipeline-speed`, `imp-monitoring-alerts` |

---

## 8. Roadmap Body Structure

After the metadata block, every roadmap MUST include these sections in order:

```
## Overview
## Initiatives (or ## Items for flat roadmaps)
## Progress Summary
```

### 8.1 Overview

A brief description of the roadmap's purpose, scope, and time horizon. Include context about strategic goals or constraints.

### 8.2 Initiatives

Each initiative is a second-level heading with its metadata block and contained items. See section 9.

For flat roadmaps (e.g., technical debt registries that do not need initiative grouping), use `## Items` instead and list items directly.

### 8.3 Progress Summary

A summary table showing progress by initiative (or by priority for flat roadmaps):

```markdown
| Initiative | Total | Completed | In Progress | Planned | Proposed |
|-----------|-------|-----------|-------------|---------|----------|
| User Experience Overhaul | 5 | 1 | 2 | 1 | 1 |
| API Platform | 4 | 2 | 1 | 1 | 0 |
| **Total** | **9** | **3** | **3** | **2** | **1** |
```

---

## 9. Initiative Body Structure

Each initiative within a roadmap uses the following structure:

```markdown
## <Initiative Name>

<!-- initiative -->
<initiative metadata>
<!-- /initiative -->

<Brief description of the initiative's goal and why it matters.>

### Items

<List of items belonging to this initiative>
```

### 9.1 Item listing within an initiative

Items within an initiative are listed as third-level headings:

```markdown
### feat-user-dashboard — Build user dashboard

<!-- item -->
item_id: feat-user-dashboard
name: Build user dashboard
type: feature
status: in-progress
priority: high
owner: frontend-team
component_id: webapp
target_date: 2026-04-15
<!-- /item -->

**Description:** Build a personalized dashboard showing user activity, recent projects, and notifications.

**Acceptance criteria:**
- [ ] Dashboard loads in under 2 seconds
- [ ] Shows last 10 user activities
- [ ] Responsive layout for mobile and desktop
- [ ] Covered by integration tests

**Dependencies:** `feat-api-user-endpoint`
```

---

## 10. Roadmap Item Body Structure

When items appear inline (section 9.1), they MUST include at minimum:

1. **Description** — what the item delivers
2. **Acceptance criteria** — checklist of conditions for completion

Items MAY also include:

3. **Dependencies** — item IDs or external dependencies that must be completed first
4. **Cross-references** — links to related controls, procedures, conventions, or compliance requirements
5. **Notes** — additional context, design decisions, or links to external documents

### 10.1 Standalone item files

For items that require extended documentation (design docs, RFCs, detailed analysis), create a standalone file in `docs/roadmap/items/`. The standalone file uses the same metadata schema (section 7) as YAML frontmatter and MAY include additional body sections:

```
## Description
## Context
## Proposed Solution
## Acceptance Criteria
## Dependencies
## Cross-References
## Open Questions
```

---

## 11. Technical Debt Specification

Technical debt items (`type: debt`) have additional requirements beyond the base item schema.

### 11.1 Additional fields for debt items

```yaml
<!-- item -->
item_id: debt-migrate-orm
name: Migrate from raw SQL to ORM
type: debt
status: planned
priority: medium
owner: backend-team
component_id: api-service
debt_category: architecture
impact: high
effort: large
code_refs:
  - src/db/queries/*.sql
  - src/models/legacy/*.ts
<!-- /item -->
```

### 11.2 Debt-specific field reference

| Field | Required | Type | Description |
|-------|----------|------|-------------|
| `debt_category` | Yes (for debt items) | enum | `architecture` / `code-quality` / `testing` / `documentation` / `dependency` / `infrastructure` / `performance` |
| `impact` | Yes (for debt items) | enum | `critical` / `high` / `medium` / `low` — how much this debt affects development velocity or system quality |
| `effort` | Yes (for debt items) | enum | `trivial` / `small` / `medium` / `large` / `xlarge` — estimated remediation effort |
| `code_refs` | No | list | File paths or glob patterns pointing to affected code |

### 11.3 Debt item body structure

Debt items MUST include these additional body sections:

```markdown
**Description:** <what the debt is and how it was incurred>

**Impact:** <how this debt affects development velocity, reliability, or maintainability>

**Remediation:** <high-level approach to resolving this debt>

**Acceptance criteria:**
- [ ] <conditions for this debt to be considered resolved>
```

---

## 12. Security Roadmap Specification

Security roadmap items (`type: security`) have additional requirements that connect them to AFSS and AFCS.

### 12.1 Additional fields for security items

```yaml
<!-- item -->
item_id: sec-add-rls-audit-table
name: Add RLS to audit_log table
type: security
status: planned
priority: critical
owner: platform-team
component_id: webapp
control_id: auth-rls-user-profiles
threat_id: threat-disclosure-user-data-leak
framework_ref: OWASP-A01
<!-- /item -->
```

### 12.2 Security-specific field reference

| Field | Required | Type | Description |
|-------|----------|------|-------------|
| `control_id` | Yes (for security items) | slug or list | AFSS control(s) this item creates or improves |
| `threat_id` | No | slug or list | AFSS threat(s) this item mitigates |
| `framework_ref` | No | string or list | AFCS compliance requirement(s) this item addresses |

### 12.3 Traceability to AFCS gaps

Security roadmap items SHOULD be created for every gap identified in AFCS compliance mappings (section 7.3, Gap Analysis) and AFCS risk assessments. The `framework_ref` field provides the traceability link from the compliance gap back to the planned remediation.

### 12.4 Security item body structure

Security items MUST include these additional body sections:

```markdown
**Description:** <what security improvement this item delivers>

**Threat context:** <which threats this addresses, referencing AFSS threat IDs>

**Acceptance criteria:**
- [ ] <conditions for this security improvement to be considered complete>
- [ ] AFSS control created or updated with control_id: <control_id>
- [ ] Control verified per AFSS verification procedure
```

---

## 13. Roadmap Registry

The docs hub (or component repo) MUST contain `docs/roadmap/roadmaps.yaml`. This is the entry point for AI agents to discover all roadmaps.

### 13.1 Schema

```yaml
roadmaps:
  - roadmap_id: feature-2026-h1
    name: Feature Roadmap — 2026 H1
    roadmap_type: feature
    path: docs/roadmap/feature-2026-h1.md
    status: active
    owner: product-team
    time_horizon: 2026-H1
    last_reviewed: 2026-02-11
    summary:
      total_items: 12
      completed: 3
      in_progress: 4
      planned: 3
      proposed: 2

  - roadmap_id: technical-debt
    name: Technical Debt Registry
    roadmap_type: technical-debt
    path: docs/roadmap/technical-debt.md
    status: active
    owner: engineering-team
    time_horizon: ongoing
    last_reviewed: 2026-02-11
    summary:
      total_items: 8
      completed: 2
      in_progress: 1
      planned: 3
      proposed: 2

  - roadmap_id: security-roadmap
    name: Security Roadmap
    roadmap_type: security
    path: docs/roadmap/security-roadmap.md
    status: active
    owner: security-team
    time_horizon: ongoing
    last_reviewed: 2026-02-11
    summary:
      total_items: 6
      completed: 1
      in_progress: 2
      planned: 2
      proposed: 1
```

### 13.2 Field reference

| Field | Required | Type | Description |
|-------|----------|------|-------------|
| `roadmap_id` | Yes | slug | Must match the roadmap document's `roadmap_id` |
| `name` | Yes | string | Human-readable name |
| `roadmap_type` | Yes | enum | `feature` / `technical-debt` / `security` |
| `path` | Yes | path | Relative path to the roadmap file |
| `status` | Yes | enum | `active` / `draft` / `archived` |
| `owner` | Yes | string | Team responsible |
| `time_horizon` | No | string | Time period or `ongoing` |
| `last_reviewed` | Yes | date | ISO date of last review |
| `summary` | No | object | Aggregate item statistics (same schema as section 5.2) |

---

## 14. AI/LLM Integration Model

### 14.1 Roadmap discovery

When an AI agent starts a session and needs to understand planned work, it MUST:

1. Read `docs/roadmap/roadmaps.yaml` to discover all roadmaps.
2. Read individual roadmap files relevant to the current task.
3. Cross-reference with AFADS `components.yaml` to understand which components have planned work.

### 14.2 Context-aware prioritization

When an AI agent is asked to work on a component, it SHOULD:

1. Check if there are roadmap items related to that component.
2. If there are `in-progress` items, consider whether the current task aligns with or conflicts with planned work.
3. Flag potential conflicts between the current task and roadmap priorities.

### 14.3 Progress reporting

When asked to generate a progress report, the AI agent SHOULD:

1. Read all active roadmaps.
2. Aggregate item statuses by initiative and by roadmap.
3. Identify items that are overdue (past `target_date` but not `completed`).
4. Identify items that are blocked (status `in-progress` with unmet dependencies).
5. Generate a summary with completion percentages and highlight risks.

### 14.4 Technical debt awareness

When generating or reviewing code, the AI agent SHOULD:

1. Check the technical debt registry for debt items related to the affected files.
2. If working in an area with known debt, note the debt item ID and avoid deepening the debt.
3. If a code change would naturally resolve a debt item, flag it for the human to update the roadmap.

### 14.5 Security roadmap awareness

When working on security-related code, the AI agent SHOULD:

1. Check the security roadmap for planned security improvements in the affected area.
2. Cross-reference with AFSS controls to understand if the work aligns with planned security posture improvements.
3. If a change addresses a security roadmap item, flag it so the item status can be updated.

### 14.6 Roadmap maintenance

When updating roadmap artifacts, the AI agent MUST:

1. Update only the metadata and status fields. Do not modify acceptance criteria or descriptions without explicit human approval.
2. Update the `summary` statistics in the roadmap metadata when item statuses change.
3. Update `roadmaps.yaml` when a roadmap's summary or status changes.
4. Never delete or cancel a roadmap item without explicit human approval.

---

## 15. Lifecycle and Review

### 15.1 Review triggers

A roadmap artifact MUST be reviewed when:

| Trigger | Review deadline |
|---------|----------------|
| 90 days since last review | within 2 weeks |
| New component added (AFADS) | within 1 week (assess roadmap impact) |
| Security incident | within 1 week (re-assess security roadmap) |
| AFCS compliance gap identified | within 2 weeks (add security roadmap item) |
| Quarterly planning cycle | at start of quarter |

### 15.2 Status transitions

Items follow this lifecycle:

```
proposed → planned → in-progress → completed
                                 → cancelled (from any status)
```

- `proposed` — idea or request, not yet committed
- `planned` — committed to, assigned owner and priority
- `in-progress` — actively being worked on
- `completed` — done, acceptance criteria met
- `cancelled` — no longer relevant (must include reason)

### 15.3 Archival

Roadmaps with a time horizon (e.g., `2026-H1`) SHOULD be archived after the period ends:

1. Set `status: archived` in the roadmap metadata.
2. Move incomplete items to the next period's roadmap or the backlog.
3. Do not delete archived roadmaps — they serve as historical record.

### 15.4 Deprecation of items

To cancel a roadmap item:
1. Set `status: cancelled`.
2. Add a note explaining why the item was cancelled.
3. If the item was a security item, verify that the associated AFSS threat is addressed by other means.

---

## 16. Definition of Done

A roadmap document is considered **compliant** when:

- [ ] Metadata block contains all required fields (section 5.1)
- [ ] All required body sections are present (section 8)
- [ ] Every initiative has an `initiative_id`, `status`, `priority`, and `owner` (section 6)
- [ ] Every item has an `item_id`, `type`, `status`, `priority`, and `owner` (section 7)
- [ ] Every item has a description and acceptance criteria (section 10)
- [ ] Item IDs use the correct type prefix (section 7.4)
- [ ] All referenced `component_id` values exist in AFADS `components.yaml`
- [ ] All referenced `control_id` values exist in AFSS `controls.yaml`
- [ ] All referenced `procedure_id` values exist in AFOPS `procedures.yaml`
- [ ] All referenced `convention_id` values exist in AFPS `conventions.yaml`
- [ ] `summary` statistics (if present) match actual item counts
- [ ] `last_reviewed` is within 90 days
- [ ] Roadmap is registered in `roadmaps.yaml`

A technical debt item is additionally **compliant** when:

- [ ] `debt_category` is specified (section 11.2)
- [ ] `impact` is specified (section 11.2)
- [ ] `effort` is specified (section 11.2)
- [ ] Debt-specific body sections are present: Description, Impact, Remediation, Acceptance criteria (section 11.3)

A security roadmap item is additionally **compliant** when:

- [ ] `control_id` references at least one AFSS control (section 12.2)
- [ ] Security-specific body sections are present: Description, Threat context, Acceptance criteria (section 12.4)
- [ ] Acceptance criteria include creating or updating the referenced AFSS control

A system is considered **roadmap-documented** when:

- [ ] At least one roadmap exists in `docs/roadmap/`
- [ ] `roadmaps.yaml` exists and lists all roadmaps
- [ ] Technical debt is tracked (either as a dedicated registry or items within a feature roadmap)
- [ ] Security improvements are tracked (either as a dedicated security roadmap or items within a feature roadmap)
- [ ] Every `in-progress` item has an owner
- [ ] Every `completed` item has acceptance criteria marked as done

---

## 17. Relationship to AFADS, AFOPS, AFPS, AFSS, and AFCS

### 17.1 What AFRS extends

| Standard | Section | AFRS Relationship |
|----------|---------|-------------------|
| AFADS | Section 4.2 (`component.md`) | Component documentation describes what exists; AFRS describes what is planned for that component |
| AFADS | Section 6 (ADRs) | Roadmap items that require architectural decisions SHOULD have an associated ADR |
| AFOPS | Section 3 (Procedure Types) | Roadmap items for operational improvements reference AFOPS procedures by `procedure_id` |
| AFPS | Section 3 (Convention Types) | Roadmap items for convention improvements reference AFPS conventions by `convention_id` |
| AFSS | Section 12 (Control Registry) | Security roadmap items reference controls to be created or improved by `control_id` |
| AFSS | Section 9 (Threat Model) | Security roadmap items reference threats by `threat_id` |
| AFCS | Section 7.3 (Gap Analysis) | AFCS compliance gaps SHOULD have corresponding security roadmap items |
| AFCS | Section 10 (Scorecard) | AFCS remediation plans SHOULD reference AFRS item IDs for traceability |

### 17.2 What AFRS does not replace

- AFADS component documentation — AFRS plans future work; AFADS documents current state
- AFOPS procedures — AFRS may plan procedure creation; AFOPS defines the procedure itself
- AFPS conventions — AFRS may plan convention changes; AFPS documents the conventions
- AFSS controls and policies — AFRS may plan control creation; AFSS defines the control
- AFCS compliance mappings — AFRS may plan gap remediation; AFCS documents the mapping

### 17.3 Cross-references

- Item metadata `component_id` MUST match an AFADS `component_id`.
- Item metadata `control_id` MUST match an AFSS `control_id` (or the ID of a control to be created).
- Item metadata `procedure_id` MUST match an AFOPS `procedure_id`.
- Item metadata `convention_id` MUST match an AFPS `convention_id`.
- Item metadata `framework_ref` MUST match a requirement ID from an AFCS-tracked framework.
- AFCS remediation plans (section 7.4) SHOULD include an `item_id` column referencing AFRS items.
- When an AFRS security item is completed, the corresponding AFSS control MUST be created or updated.

---

## 18. Appendix A: Example Feature Roadmap

```markdown
---
roadmap_id: feature-2026-h1
name: Feature Roadmap — 2026 H1
type: roadmap
roadmap_type: feature
status: active
owner: product-team
last_reviewed: 2026-02-11
time_horizon: 2026-H1
summary:
  total_items: 5
  completed: 1
  in_progress: 2
  planned: 1
  proposed: 1
  cancelled: 0
  completion_percent: 20
---

## Overview

This roadmap covers planned feature work for the first half of 2026.
Focus areas are user experience improvements and API platform
capabilities. All items reference the webapp and api-service components.

## Initiatives

## User Experience Overhaul

<!-- initiative -->
initiative_id: init-user-experience
name: User Experience Overhaul
status: in-progress
priority: high
owner: frontend-team
target_date: 2026-06-30
<!-- /initiative -->

Improve the core user experience across the web application, focusing on
dashboard, navigation, and performance.

### Items

### feat-user-dashboard — Build user dashboard

<!-- item -->
item_id: feat-user-dashboard
name: Build user dashboard
type: feature
status: in-progress
priority: high
owner: frontend-team
component_id: webapp
target_date: 2026-04-15
<!-- /item -->

**Description:** Build a personalized dashboard showing user activity,
recent projects, and notifications.

**Acceptance criteria:**
- [ ] Dashboard loads in under 2 seconds
- [ ] Shows last 10 user activities
- [ ] Responsive layout for mobile and desktop
- [ ] Covered by integration tests

**Dependencies:** `feat-api-user-endpoint`

### feat-navigation-redesign — Redesign main navigation

<!-- item -->
item_id: feat-navigation-redesign
name: Redesign main navigation
type: feature
status: completed
priority: high
owner: frontend-team
component_id: webapp
completed_date: 2026-01-20
<!-- /item -->

**Description:** Redesign the main navigation to support nested menu items
and responsive sidebar layout.

**Acceptance criteria:**
- [x] Sidebar navigation with collapsible sections
- [x] Mobile hamburger menu
- [x] Keyboard navigation support
- [x] Visual regression tests pass

### feat-performance-audit — Frontend performance audit

<!-- item -->
item_id: feat-performance-audit
name: Frontend performance audit
type: feature
status: proposed
priority: medium
owner: frontend-team
component_id: webapp
<!-- /item -->

**Description:** Audit frontend bundle size, rendering performance, and
identify optimization opportunities.

**Acceptance criteria:**
- [ ] Lighthouse score above 90 on all pages
- [ ] Bundle size under 200KB gzipped
- [ ] Performance monitoring baseline established

## API Platform

<!-- initiative -->
initiative_id: init-api-platform
name: API Platform
status: in-progress
priority: high
owner: backend-team
target_date: 2026-05-31
<!-- /initiative -->

Expand the API to support third-party integrations and public API access.

### Items

### feat-api-user-endpoint — User data API endpoint

<!-- item -->
item_id: feat-api-user-endpoint
name: User data API endpoint
type: feature
status: in-progress
priority: high
owner: backend-team
component_id: api-service
target_date: 2026-03-15
control_id: auth-rls-user-profiles
<!-- /item -->

**Description:** Create a RESTful API endpoint for user data that respects
RLS policies and supports pagination.

**Acceptance criteria:**
- [ ] GET /api/users/:id returns user data scoped by RLS
- [ ] Pagination with cursor-based navigation
- [ ] Rate limiting applied per AFSS control
- [ ] OpenAPI spec documented

**Cross-references:** AFSS control `auth-rls-user-profiles`

### feat-api-pagination — Generic pagination library

<!-- item -->
item_id: feat-api-pagination
name: Generic pagination library
type: feature
status: planned
priority: medium
owner: backend-team
component_id: api-service
target_date: 2026-04-30
<!-- /item -->

**Description:** Extract cursor-based pagination into a reusable library
for all API endpoints.

**Acceptance criteria:**
- [ ] Works with any Supabase table query
- [ ] Supports forward and backward pagination
- [ ] Unit tests with 100% branch coverage

## Progress Summary

| Initiative | Total | Completed | In Progress | Planned | Proposed |
|-----------|-------|-----------|-------------|---------|----------|
| User Experience Overhaul | 3 | 1 | 1 | 0 | 1 |
| API Platform | 2 | 0 | 1 | 1 | 0 |
| **Total** | **5** | **1** | **2** | **1** | **1** |
```

---

## 19. Appendix B: Example Technical Debt Registry

```markdown
---
roadmap_id: technical-debt
name: Technical Debt Registry
type: roadmap
roadmap_type: technical-debt
status: active
owner: engineering-team
last_reviewed: 2026-02-11
time_horizon: ongoing
summary:
  total_items: 3
  completed: 0
  in_progress: 1
  planned: 1
  proposed: 1
  cancelled: 0
  completion_percent: 0
---

## Overview

This registry tracks known technical debt across the system. Items are
prioritized by impact on development velocity and system quality. Each
item includes a remediation approach and effort estimate.

## Items

### debt-migrate-orm — Migrate from raw SQL to ORM

<!-- item -->
item_id: debt-migrate-orm
name: Migrate from raw SQL to ORM
type: debt
status: in-progress
priority: high
owner: backend-team
component_id: api-service
debt_category: architecture
impact: high
effort: large
code_refs:
  - src/db/queries/*.sql
  - src/models/legacy/*.ts
<!-- /item -->

**Description:** The API service uses raw SQL queries in 23 files instead
of the ORM. This makes schema changes error-prone and prevents type
safety at the query level.

**Impact:** Every schema migration requires manually updating SQL strings
across multiple files. Two production incidents in the last quarter were
caused by missed query updates.

**Remediation:** Migrate queries file-by-file to use the Drizzle ORM,
starting with the most frequently modified tables.

**Acceptance criteria:**
- [ ] All raw SQL files in src/db/queries/ replaced with ORM calls
- [ ] Legacy model files in src/models/legacy/ removed
- [ ] All existing tests pass with ORM implementation
- [ ] No raw SQL queries remain outside of migrations

### debt-test-coverage-api — Increase API test coverage

<!-- item -->
item_id: debt-test-coverage-api
name: Increase API test coverage
type: debt
status: planned
priority: medium
owner: backend-team
component_id: api-service
debt_category: testing
impact: medium
effort: medium
<!-- /item -->

**Description:** API endpoint test coverage is at 42%, below the team
target of 80%. Missing coverage is concentrated in error handling paths
and edge cases.

**Impact:** Low test coverage means regressions are caught late. The
team avoids refactoring due to fear of breaking untested paths.

**Remediation:** Add integration tests for all API endpoints, prioritizing
error handling and authorization edge cases.

**Acceptance criteria:**
- [ ] API test coverage reaches 80%
- [ ] All error handling paths have at least one test
- [ ] All authorization edge cases have dedicated tests

### debt-remove-legacy-auth — Remove legacy authentication module

<!-- item -->
item_id: debt-remove-legacy-auth
name: Remove legacy authentication module
type: debt
status: proposed
priority: low
owner: platform-team
component_id: webapp
debt_category: code-quality
impact: low
effort: small
control_id: auth-jwt-validation
code_refs:
  - src/auth/legacy/*.ts
<!-- /item -->

**Description:** The legacy authentication module (pre-Supabase) is still
in the codebase but unused. It adds confusion for new developers and
increases bundle size.

**Impact:** Minor confusion during onboarding. No runtime impact since
the module is not imported.

**Remediation:** Delete the legacy auth module and verify no imports
reference it.

**Acceptance criteria:**
- [ ] src/auth/legacy/ directory removed
- [ ] No import statements reference legacy auth module
- [ ] Build and all tests pass
- [ ] Bundle size reduced

## Progress Summary

| Priority | Total | Completed | In Progress | Planned | Proposed |
|----------|-------|-----------|-------------|---------|----------|
| Critical | 0 | 0 | 0 | 0 | 0 |
| High | 1 | 0 | 1 | 0 | 0 |
| Medium | 1 | 0 | 0 | 1 | 0 |
| Low | 1 | 0 | 0 | 0 | 1 |
| **Total** | **3** | **0** | **1** | **1** | **1** |
```

---

## 20. Summary

AFRS defines how to document and structure roadmaps, initiatives, and work items so they are human-readable, AI-parseable, and traceable to the architecture (AFADS), operations (AFOPS), conventions (AFPS), security controls (AFSS), and compliance requirements (AFCS).

Every roadmap artifact uses YAML metadata, follows a consistent format, and references other AFDOCS standards by their stable IDs. AI agents can discover planned work through `roadmaps.yaml`, generate progress reports, identify overdue items, and connect roadmap items to the broader documentation ecosystem.

The three roadmap types — feature, technical debt, and security — cover the most common planning scenarios while maintaining a consistent structure. The three-level hierarchy (roadmap → initiative → item) supports both strategic and tactical views of planned work.
