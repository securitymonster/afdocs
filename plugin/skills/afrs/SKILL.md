---
name: afrs
description: "AI-Friendly Roadmap Standard. Use when documenting roadmaps, tracking technical debt, planning security improvements, or managing initiatives and work items."
user-invocable: true
---

# AFRS — AI-Friendly Roadmap Standard

Use this skill to document roadmaps, technical debt registries, and security improvements with structured metadata and cross-references to all AFDOCS standards.

## When to Use

- Creating a feature roadmap for a project
- Tracking technical debt with impact and effort estimates
- Planning security improvements linked to AFSS controls
- Generating progress reports from structured roadmap data
- Connecting planned work to architecture, security, and compliance

## Key Deliverables

```
docs/
  roadmap/
    roadmaps.yaml                     ← roadmap registry (required)
    feature-2026-h1.md                ← feature roadmap
    technical-debt.md                 ← technical debt registry
    security-roadmap.md               ← security improvement plan
    items/                            ← standalone items (optional)
      feat-user-dashboard.md
```

## Hierarchy

**Roadmap → Initiative → Item** (three levels)

- **Roadmap** — container document (feature, technical-debt, or security)
- **Initiative** — strategic grouping of related items within a roadmap
- **Item** — individual actionable work item with acceptance criteria

## Roadmap Types

| Type | `roadmap_type` | Use for |
|------|---------------|---------|
| Feature Roadmap | `feature` | Product or technical capabilities |
| Technical Debt Registry | `technical-debt` | Known debt with remediation plans |
| Security Roadmap | `security` | Security improvements linked to AFSS/AFCS |

## Roadmap Metadata Schema

```yaml
---
roadmap_id: feature-2026-h1
name: Feature Roadmap — 2026 H1
type: roadmap
roadmap_type: feature              # feature | technical-debt | security
status: active                     # active | draft | archived
owner: product-team
last_reviewed: 2026-02-11
time_horizon: 2026-H1             # optional
component_id: webapp              # optional: omit for system-level
summary:                          # optional
  total_items: 12
  completed: 3
  in_progress: 4
  planned: 3
  proposed: 2
  completion_percent: 25
---
```

## Initiative Schema (inline in roadmap)

```html
<!-- initiative -->
initiative_id: init-user-experience
name: User Experience Overhaul
status: in-progress
priority: high
owner: frontend-team
target_date: 2026-06-30
<!-- /initiative -->
```

## Item Schema (inline in initiative or roadmap)

```html
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
```

### Item ID Prefixes

| Type | Prefix | Example |
|------|--------|---------|
| `feature` | `feat-` | `feat-user-dashboard` |
| `debt` | `debt-` | `debt-migrate-orm` |
| `security` | `sec-` | `sec-add-rls-audit-table` |
| `improvement` | `imp-` | `imp-ci-pipeline-speed` |

### Status Lifecycle

```
proposed → planned → in-progress → completed
                                 → cancelled (from any status)
```

### Priority Levels

`critical` | `high` | `medium` | `low` (consistent with AFSS criticality)

## Item Body Structure

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
<!-- /item -->

**Description:** What this item delivers.

**Acceptance criteria:**
- [ ] Dashboard loads in under 2 seconds
- [ ] Covered by integration tests

**Dependencies:** `feat-api-user-endpoint`

**Cross-references:** AFSS control `auth-rls-user-profiles`
```

## Technical Debt Items (additional fields)

```html
<!-- item -->
item_id: debt-migrate-orm
type: debt
debt_category: architecture      # architecture | code-quality | testing | documentation | dependency | infrastructure | performance
impact: high                     # how much it affects velocity
effort: large                    # trivial | small | medium | large | xlarge
code_refs:
  - src/db/queries/*.sql
<!-- /item -->
```

Extra body sections: **Impact**, **Remediation**

## Security Items (additional fields)

```html
<!-- item -->
item_id: sec-add-rls-audit-table
type: security
control_id: auth-rls-user-profiles    # AFSS control (required)
threat_id: threat-disclosure-data-leak # AFSS threat
framework_ref: OWASP-A01              # AFCS requirement
<!-- /item -->
```

Extra body section: **Threat context**

## Roadmap Registry (roadmaps.yaml)

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
```

## Roadmap Body Structure

```markdown
## Overview
Purpose, scope, strategic context.

## Initiatives
(Each initiative heading with items inside)

## Progress Summary

| Initiative | Total | Completed | In Progress | Planned | Proposed |
|-----------|-------|-----------|-------------|---------|----------|
| UX Overhaul | 5 | 1 | 2 | 1 | 1 |
| **Total** | **5** | **1** | **2** | **1** | **1** |
```

## Core Principles

- **Traceable** — every item maps to components, controls, procedures, or conventions
- **Owned** — every item has an owner and status reflecting reality
- **Hierarchical** — roadmap → initiative → item for strategic + tactical views
- **Time-optional** — dates supported but not required
- **AI-discoverable** — agents read `roadmaps.yaml`, generate reports, flag conflicts

## Cross-References

- `component_id` → AFADS component
- `control_id` / `threat_id` → AFSS control or threat
- `procedure_id` → AFOPS procedure
- `convention_id` → AFPS convention
- `framework_ref` → AFCS compliance requirement
- AFCS remediation plans SHOULD reference AFRS `item_id` values

## Full Standard

https://github.com/securitymonster/afdocs/blob/main/AFRS.md
