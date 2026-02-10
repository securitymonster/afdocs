# AI-Friendly Compliance Standard (AFCS)

Version: 0.1
Status: Draft / Working Standard
Last updated: 2026-02-10
Author: Sebastian Mang
Companion to: AI-Friendly Architecture Documentation Standard (AFADS),
              AI-Friendly Operational Procedures Standard (AFOPS),
              AI-Friendly Programming Standard (AFPS),
              AI-Friendly Security Standard (AFSS)

## 1. Purpose

This standard defines how to document, structure, and maintain compliance mappings, checklists, risk assessments, and compliance scorecards so they are:
- **human-readable** — auditors and engineers can read and verify compliance posture
- **AI-parseable** — structured YAML metadata so an LLM can discover framework coverage and gaps
- **traceable** — every compliance requirement maps bidirectionally to AFSS controls and policies
- **framework-agnostic** — the same artifact format works for OWASP, NIS2, ISO 27001, SOC 2, or any future framework
- **scoreable** — quantitative risk and compliance scoring with defined methodologies
- **consistent across repos** — every compliance artifact follows the same format

### 1.1 Scope

This standard covers:
- compliance framework registration (which external frameworks the system tracks)
- compliance mappings (framework requirement → AFSS control/policy bidirectional mapping)
- compliance checklists (actionable per-framework verification checklists)
- risk assessments (likelihood × impact matrices, CVSS-based scoring, or custom methodologies)
- compliance scorecards (quantitative coverage and maturity scoring)

### 1.2 What AFCS Is Not

AFCS is not a security control framework. Security controls, policies, and threat models are defined by AFSS. AFCS maps externally-defined compliance requirements to internally-documented AFSS controls.

AFCS is not a certification body or audit process. It documents the evidence and mappings that support those processes.

AFCS is not a legal interpretation of any regulation. For regulatory frameworks (e.g., NIS2), AFCS provides a structured mapping format. Legal interpretation must come from qualified counsel.

### 1.3 Relationship to AFSS and Other Standards

AFSS defines security controls and policies. AFCS maps those to external compliance frameworks.

AFSS's optional `compliance_refs` field (section 5.2) provides a lightweight cross-reference. AFCS provides the full bidirectional mapping with coverage analysis. AFCS is the authoritative source for compliance mappings; `compliance_refs` is a convenient shorthand.

AFOPS procedures may be referenced for operational compliance requirements (e.g., NIS2 incident response, patching).

AFPS patterns may be referenced for code-level compliance requirements (e.g., OWASP input validation patterns).

---

## 2. Core Principles

### 2.1 Compliance is mapped, not duplicated

AFCS maps external framework requirements to existing AFSS controls. It does not re-document the controls. If a mapping reveals a gap (no control exists for a requirement), the gap is documented in AFCS and a new control should be created in AFSS.

### 2.2 Framework requirements are canonical

Each framework requirement is represented exactly once, with its official identifier and text. AFCS does not paraphrase or interpret framework requirements.

### 2.3 Coverage is quantifiable

Every mapping includes a coverage status. Coverage gaps are explicit. System-level compliance scores are computable from the mappings.

### 2.4 Risk is scored, not just categorized

AFCS extends AFSS's categorical risk levels (low / medium / high / critical) with numeric scoring using established methodologies (likelihood × impact, CVSS). The categorical values remain as human-friendly summaries; numeric scores enable prioritization and trending.

### 2.5 Compliance metadata is machine-readable

All compliance artifacts use YAML frontmatter, consistent with the pattern established by AFADS, AFOPS, AFPS, and AFSS.

### 2.6 AI agents can assess compliance posture

An AI agent should be able to read the compliance artifacts and determine: which frameworks are tracked, what the current coverage is, where the gaps are, and what the risk priorities are.

---

## 3. Artifact Types

AFCS defines five artifact types:

| Artifact | Type value | Description | Scope |
|----------|-----------|-------------|-------|
| Framework Registration | `compliance-framework` | Registers a compliance framework the system tracks | System |
| Compliance Mapping | `compliance-mapping` | Maps one framework's requirements to AFSS controls/policies | System |
| Compliance Checklist | `compliance-checklist` | Actionable verification checklist for a framework | System or Component |
| Risk Assessment | `risk-assessment` | Likelihood × impact analysis for threats or compliance gaps | System or Component |
| Compliance Scorecard | `compliance-scorecard` | Quantitative coverage and maturity scoring | System |

Additionally, AFCS references these related artifacts from other standards:

| Artifact | Defined by | How AFCS uses it |
|----------|-----------|------------------|
| Security control | AFSS | AFCS maps framework requirements to controls |
| Security policy | AFSS | AFCS maps framework requirements to policies |
| Threat model | AFSS | Risk assessments reference threats from the threat model |
| Procedure | AFOPS | Operational compliance requirements reference procedures |
| Pattern | AFPS | Code-level compliance requirements reference patterns |

---

## 4. File Layout and Naming

### 4.1 System-level compliance (docs hub repo)

Compliance documentation lives in the docs hub:

```
docs/
  compliance/
    frameworks.yaml                    ← framework registry (required)
    mappings/
      owasp-web-2021.md               ← one mapping file per framework
      owasp-api-2023.md
      owasp-mobile-2024.md
      owasp-llm-2025.md
      nis2-article-21.md
    checklists/
      owasp-web-2021-checklist.md      ← one checklist per framework
      owasp-api-2023-checklist.md
      owasp-mobile-2024-checklist.md
      owasp-llm-2025-checklist.md
      nis2-article-21-checklist.md
    risk-assessments/
      system-risk-assessment.md        ← system-level risk assessment
    scorecards/
      compliance-scorecard.md          ← system-level scorecard
    scorecards.yaml                    ← scorecard registry (optional)
```

### 4.2 Component-level compliance

Components that need component-specific compliance artifacts (e.g., a web frontend needs an OWASP Web checklist, an API service needs an OWASP API checklist):

```
docs/
  compliance/
    checklists/
      owasp-web-2021-checklist.md      ← component-specific checklist
    risk-assessments/
      component-risk-assessment.md     ← component-specific risk assessment
```

### 4.3 File naming

- Framework mapping files: `<framework-slug>.md`
- Checklist files: `<framework-slug>-checklist.md`
- Risk assessment files: `<scope>-risk-assessment.md`
- Scorecard files: `compliance-scorecard.md`

Framework slugs MUST use kebab-case and include the version or year: `owasp-web-2021`, `owasp-api-2023`, `owasp-mobile-2024`, `owasp-llm-2025`, `nis2-article-21`.

---

## 5. Framework Registration Schema

The docs hub MUST contain `docs/compliance/frameworks.yaml`. This is the entry point for AI agents to discover which frameworks the system tracks.

### 5.1 Schema

```yaml
frameworks:
  - framework_id: owasp-web-2021
    name: OWASP Top 10 Web Application Security Risks (2021)
    version: "2021"
    type: industry-standard
    url: https://owasp.org/Top10/
    requirements_count: 10
    mapping_path: docs/compliance/mappings/owasp-web-2021.md
    checklist_path: docs/compliance/checklists/owasp-web-2021-checklist.md
    status: active
    last_reviewed: 2026-02-10

  - framework_id: owasp-api-2023
    name: OWASP API Security Top 10 (2023)
    version: "2023"
    type: industry-standard
    url: https://owasp.org/API-Security/
    requirements_count: 10
    mapping_path: docs/compliance/mappings/owasp-api-2023.md
    checklist_path: docs/compliance/checklists/owasp-api-2023-checklist.md
    status: active
    last_reviewed: 2026-02-10

  - framework_id: owasp-mobile-2024
    name: OWASP Mobile Top 10 (2024)
    version: "2024"
    type: industry-standard
    url: https://owasp.org/www-project-mobile-top-10/
    requirements_count: 10
    mapping_path: docs/compliance/mappings/owasp-mobile-2024.md
    checklist_path: docs/compliance/checklists/owasp-mobile-2024-checklist.md
    status: active
    last_reviewed: 2026-02-10

  - framework_id: owasp-llm-2025
    name: OWASP Top 10 for LLM Applications (2025)
    version: "2025"
    type: industry-standard
    url: https://genai.owasp.org/resource/owasp-top-10-for-llm-applications-2025/
    requirements_count: 10
    mapping_path: docs/compliance/mappings/owasp-llm-2025.md
    checklist_path: docs/compliance/checklists/owasp-llm-2025-checklist.md
    status: active
    last_reviewed: 2026-02-10

  - framework_id: nis2-article-21
    name: NIS2 Directive — Article 21 Cybersecurity Risk-Management Measures
    version: "2022/2555"
    type: regulation
    url: https://eur-lex.europa.eu/eli/dir/2022/2555
    requirements_count: 10
    mapping_path: docs/compliance/mappings/nis2-article-21.md
    checklist_path: docs/compliance/checklists/nis2-article-21-checklist.md
    status: active
    last_reviewed: 2026-02-10
```

### 5.2 Field reference

| Field | Required | Type | Description |
|-------|----------|------|-------------|
| `framework_id` | Yes | slug | Stable unique identifier, kebab-case with version/year |
| `name` | Yes | string | Official framework name |
| `version` | Yes | string | Framework version or year |
| `type` | Yes | enum | `regulation` / `industry-standard` / `internal` |
| `url` | Yes | string | Official URL for the framework |
| `requirements_count` | Yes | integer | Number of top-level requirements |
| `mapping_path` | Yes | path | Path to the compliance mapping file |
| `checklist_path` | No | path | Path to the checklist file |
| `status` | Yes | enum | `active` / `planned` / `deprecated` |
| `last_reviewed` | Yes | date | ISO date of last review |

---

## 6. Compliance Mapping Metadata Schema

Every compliance mapping artifact MUST begin with a YAML frontmatter block.

### 6.1 Required fields

```yaml
---
mapping_id: owasp-web-2021
name: OWASP Top 10 (2021) Compliance Mapping
type: compliance-mapping
framework_id: owasp-web-2021
scope: system
status: active
owner: security-team
last_reviewed: 2026-02-10
coverage_summary:
  total_requirements: 10
  fully_covered: 7
  partially_covered: 2
  not_covered: 1
  not_applicable: 0
  coverage_percent: 80
---
```

### 6.2 Optional fields

```yaml
tags: [owasp, web-security, compliance]
supersedes: owasp-web-2017
applicable_components: [webapp, api-service]
```

### 6.3 Field reference

| Field | Required | Type | Description |
|-------|----------|------|-------------|
| `mapping_id` | Yes | slug | Stable unique identifier |
| `name` | Yes | string | Human-readable name |
| `type` | Yes | literal | Always `compliance-mapping` |
| `framework_id` | Yes | slug | References `frameworks.yaml` |
| `scope` | Yes | string | `system` or list of `component_id`s |
| `status` | Yes | enum | `active` / `draft` / `deprecated` |
| `owner` | Yes | string | Team responsible |
| `last_reviewed` | Yes | date | ISO date |
| `coverage_summary` | Yes | object | Aggregate coverage statistics |
| `coverage_summary.total_requirements` | Yes | integer | Total framework requirements |
| `coverage_summary.fully_covered` | Yes | integer | Requirements with full coverage |
| `coverage_summary.partially_covered` | Yes | integer | Requirements with partial coverage |
| `coverage_summary.not_covered` | Yes | integer | Requirements with no coverage |
| `coverage_summary.not_applicable` | Yes | integer | Requirements that do not apply |
| `coverage_summary.coverage_percent` | Yes | integer | Coverage % (excludes N/A) |
| `tags` | No | list | Searchable tags |
| `supersedes` | No | slug | Previous mapping this replaces |
| `applicable_components` | No | list | Component IDs this mapping is relevant to |

---

## 7. Compliance Mapping Body Structure

After the metadata block, every compliance mapping MUST include these sections in order:

```
## Framework Overview
## Requirement Mapping Table
## Gap Analysis
## Remediation Plan
```

### 7.1 Framework Overview

Brief description of the framework, its purpose, and why it applies to this system. Include the official source URL and version.

### 7.2 Requirement Mapping Table

The core of the mapping. A table with one row per framework requirement:

```markdown
| Req ID | Requirement | AFSS Controls | AFSS Policies | Coverage | Notes |
|--------|-------------|---------------|---------------|----------|-------|
| A01:2021 | Broken Access Control | auth-rls-user-profiles, authz-supabase-policies | authorization | full | |
| A02:2021 | Cryptographic Failures | secrets-env-separation, infra-tls-all-endpoints | secrets-management | full | |
| A03:2021 | Injection | input-validation-api, db-parameterized-queries | input-validation | full | |
```

Coverage values:
- `full` — all aspects of the requirement are addressed by existing controls
- `partial` — some aspects addressed, gaps documented in section 7.3
- `none` — no controls address this requirement
- `not-applicable` — requirement does not apply to this system (with justification)

### 7.3 Gap Analysis

For every requirement with `partial` or `none` coverage, document:
- What specific aspect of the requirement is not covered
- Why it is not covered (accepted risk, planned, architectural limitation)
- Recommended remediation (new control to create in AFSS, new procedure in AFOPS)

### 7.4 Remediation Plan

A prioritized table of actions to close coverage gaps:

```markdown
| Priority | Req ID | Gap | Remediation | Target Date | Owner |
|----------|--------|-----|-------------|-------------|-------|
| 1 | A08:2021 | No integrity checks on CI/CD pipeline | Create control `infra-ci-integrity` | 2026-Q2 | platform-team |
| 2 | A09:2021 | Logging coverage incomplete | Extend control `infra-logging` | 2026-Q2 | platform-team |
```

---

## 8. Compliance Checklist Specification

Checklists are actionable verification artifacts. They translate framework requirements into specific yes/no checks that can be executed during security reviews or audits.

### 8.1 Checklist metadata schema

```yaml
---
checklist_id: owasp-web-2021-checklist
name: OWASP Top 10 (2021) Compliance Checklist
type: compliance-checklist
framework_id: owasp-web-2021
mapping_id: owasp-web-2021
scope: system
component_id: system
status: active
owner: security-team
last_reviewed: 2026-02-10
last_executed: 2026-02-01
execution_frequency: quarterly
---
```

### 8.2 Optional fields

```yaml
tags: [owasp, web-security, audit]
supersedes: owasp-web-2017-checklist
```

### 8.3 Field reference

| Field | Required | Type | Description |
|-------|----------|------|-------------|
| `checklist_id` | Yes | slug | Stable unique identifier |
| `name` | Yes | string | Human-readable name |
| `type` | Yes | literal | Always `compliance-checklist` |
| `framework_id` | Yes | slug | References `frameworks.yaml` |
| `mapping_id` | Yes | slug | Corresponding mapping artifact |
| `scope` | Yes | string | `system` or `component` |
| `component_id` | Yes | slug | AFADS component_id, or `system` |
| `status` | Yes | enum | `active` / `draft` / `deprecated` |
| `owner` | Yes | string | Team responsible |
| `last_reviewed` | Yes | date | ISO date |
| `last_executed` | Yes | date | ISO date of last checklist execution |
| `execution_frequency` | Yes | string | How often the checklist is executed (e.g., `quarterly`, `monthly`) |
| `tags` | No | list | Searchable tags |
| `supersedes` | No | slug | Previous checklist this replaces |

### 8.4 Checklist body structure

After the metadata block, every checklist MUST include:

```
## Purpose
## Checklist
## Execution Record
```

### 8.5 Checklist format

Checklists are organized by framework requirement, with check items under each. Every check item MUST be specific enough that a human or AI can determine pass/fail.

```markdown
## Checklist

### A01:2021 — Broken Access Control

Related controls: `auth-rls-user-profiles`, `authz-supabase-policies`
Related policy: `authorization`

- [ ] RLS is enabled on every table containing user data
- [ ] RLS policies are tested with at least 2 user roles
- [ ] No use of service role key in client-accessible code
- [ ] API routes verify user permissions before data access
- [ ] Vertical privilege escalation tests pass
- [ ] Horizontal privilege escalation tests pass
- [ ] CORS is restricted to known origins
- [ ] Directory listing is disabled on all web servers

### A02:2021 — Cryptographic Failures

Related controls: `secrets-env-separation`, `infra-tls-all-endpoints`
Related policy: `secrets-management`

- [ ] All data in transit uses TLS 1.2+
- [ ] No sensitive data transmitted in URL parameters
- [ ] Passwords are hashed with bcrypt/argon2 (or delegated to auth provider)
- [ ] No hardcoded secrets in source code
- [ ] Secret rotation procedure exists and has been tested
- [ ] No deprecated cryptographic algorithms in use (MD5, SHA-1, DES)
```

### 8.6 Execution record

After each checklist execution, append an execution record:

```markdown
## Execution Record

| Date | Executor | Passed | Failed | N/A | Notes |
|------|----------|--------|--------|-----|-------|
| 2026-02-01 | security-team | 42 | 3 | 5 | 3 failures tracked in remediation plan |
| 2025-11-01 | security-team | 40 | 5 | 5 | |
```

Each execution that produces failures MUST reference the remediation plan in the corresponding compliance mapping.

---

## 9. Risk Assessment Specification

Risk assessments provide quantitative scoring for threats and compliance gaps.

### 9.1 Risk assessment metadata schema

```yaml
---
assessment_id: system-risk-assessment-2026q1
name: System Risk Assessment Q1 2026
type: risk-assessment
scope: system
methodology: likelihood-impact
risk_scale: 5x5
status: active
owner: security-team
assessment_date: 2026-01-15
next_assessment: 2026-04-15
last_reviewed: 2026-02-10
---
```

### 9.2 Optional fields

```yaml
component_id: webapp
framework_id: owasp-web-2021
tags: [risk, quarterly]
```

### 9.3 Field reference

| Field | Required | Type | Description |
|-------|----------|------|-------------|
| `assessment_id` | Yes | slug | Stable unique identifier |
| `name` | Yes | string | Human-readable name |
| `type` | Yes | literal | Always `risk-assessment` |
| `scope` | Yes | string | `system` or a `component_id` |
| `methodology` | Yes | enum | `likelihood-impact` / `cvss` / `custom` |
| `risk_scale` | Yes | string | Scale description (e.g., `5x5`, `3x3`, `cvss-v3.1`) |
| `status` | Yes | enum | `active` / `draft` / `deprecated` |
| `owner` | Yes | string | Team responsible |
| `assessment_date` | Yes | date | ISO date the assessment was performed |
| `next_assessment` | Yes | date | ISO date of next scheduled assessment |
| `last_reviewed` | Yes | date | ISO date of last review |
| `component_id` | No | slug | AFADS component_id for component-level assessments |
| `framework_id` | No | slug | If the assessment is tied to a specific framework |
| `tags` | No | list | Searchable tags |

### 9.4 Risk assessment body structure

After the metadata block, every risk assessment MUST include:

```
## Methodology
## Risk Matrix Definition
## Risk Register
## Risk Heatmap
## Treatment Plan
```

### 9.5 Methodology

Document the risk scoring methodology used. AFCS defines two built-in methodologies; organizations may also define a `custom` methodology.

#### Methodology A: Likelihood × Impact (5×5)

**Likelihood Scale**

| Score | Level | Definition |
|-------|-------|------------|
| 1 | Rare | < 1% chance per year; no known exploits |
| 2 | Unlikely | 1–10% chance per year; theoretical exploits exist |
| 3 | Possible | 10–50% chance per year; exploits exist in the wild |
| 4 | Likely | 50–90% chance per year; actively exploited in similar systems |
| 5 | Almost Certain | > 90% chance per year; actively targeted |

**Impact Scale**

| Score | Level | Definition |
|-------|-------|------------|
| 1 | Negligible | No user impact, no data exposure, no service disruption |
| 2 | Minor | Limited user impact, no sensitive data exposed, brief disruption |
| 3 | Moderate | Service degradation, limited data exposure, partial outage |
| 4 | Major | Service outage, sensitive data exposure, significant user impact |
| 5 | Severe | Complete compromise, regulatory impact, widespread data breach |

**Risk Score Calculation**

Risk Score = Likelihood × Impact (range: 1–25)

**Score-to-Category Mapping**

| Score Range | Risk Category | AFSS Criticality Equivalent |
|-------------|---------------|----------------------------|
| 1–4 | Low | low |
| 5–9 | Medium | medium |
| 10–16 | High | high |
| 17–25 | Critical | critical |

This mapping ensures risk scores are compatible with AFSS criticality levels, enabling consistent prioritization across standards.

#### Methodology B: CVSS-Based

For organizations that prefer CVSS scoring:

- Use CVSS v3.1 or v4.0 base scores
- Document any temporal or environmental adjustments
- Map CVSS scores to AFSS criticality using the FIRST severity rating:

| CVSS Score | Severity | AFSS Criticality Equivalent |
|------------|----------|----------------------------|
| 0.0 | None | — |
| 0.1–3.9 | Low | low |
| 4.0–6.9 | Medium | medium |
| 7.0–8.9 | High | high |
| 9.0–10.0 | Critical | critical |

### 9.6 Risk register

The risk register is a table with one row per identified risk:

```markdown
## Risk Register

| Risk ID | Threat ID | Description | L | I | Score | Category | Treatment | Control IDs | Owner |
|---------|-----------|-------------|---|---|-------|----------|-----------|-------------|-------|
| RISK-001 | threat-disclosure-user-data-leak | Unauthorized access to user data | 2 | 5 | 10 | High | Mitigate | auth-rls-user-profiles | platform-team |
| RISK-002 | threat-tampering-sql-injection | SQL injection via user input | 1 | 5 | 5 | Medium | Mitigate | input-validation-api | platform-team |
| RISK-003 | threat-dos-api-flood | API overwhelmed by requests | 3 | 3 | 9 | Medium | Mitigate | api-rate-limiting | platform-team |
```

Risk ID format: `RISK-NNN` (sequential). Threat ID references the AFSS threat model (section 9).

Treatment values:
- `mitigate` — reduce risk through controls
- `accept` — risk accepted with documented justification
- `transfer` — risk transferred via insurance or contract
- `avoid` — eliminate the risk source

### 9.7 Risk heatmap

A visual heatmap rendered as a markdown table:

```markdown
## Risk Heatmap

|                          | Negligible (1) | Minor (2) | Moderate (3) | Major (4) | Severe (5) |
|--------------------------|:-:|:-:|:-:|:-:|:-:|
| **Almost Certain (5)**   | 5 | 10 | 15 | 20 | **25** |
| **Likely (4)**           | 4 | 8 | 12 | 16 | **20** |
| **Possible (3)**         | 3 | 6 | **RISK-003** (9) | 12 | 15 |
| **Unlikely (2)**         | 2 | 4 | 6 | 8 | **RISK-001** (10) |
| **Rare (1)**             | 1 | 2 | 3 | 4 | **RISK-002** (5) |

Legend: Bold = critical/high zone. Risks are plotted by their ID at the (L, I) intersection.
```

### 9.8 Treatment plan

A prioritized list of actions for risks not fully mitigated:

```markdown
## Treatment Plan

| Priority | Risk ID | Current Score | Treatment | Action | Target Score | Target Date | Owner |
|----------|---------|---------------|-----------|--------|--------------|-------------|-------|
| 1 | RISK-001 | 10 (High) | Mitigate | Add RLS verification in CI pipeline | 4 (Low) | 2026-Q2 | platform-team |
| 2 | RISK-003 | 9 (Medium) | Mitigate | Implement adaptive rate limiting | 6 (Medium) | 2026-Q2 | platform-team |
```

---

## 10. Compliance Scorecard Specification

Scorecards provide a quantitative, point-in-time view of compliance posture across all tracked frameworks.

### 10.1 Scorecard metadata schema

```yaml
---
scorecard_id: compliance-scorecard-2026q1
name: Compliance Scorecard Q1 2026
type: compliance-scorecard
scope: system
status: active
owner: security-team
assessment_date: 2026-02-10
next_assessment: 2026-05-10
last_reviewed: 2026-02-10
---
```

### 10.2 Optional fields

```yaml
tags: [compliance, quarterly-review]
```

### 10.3 Field reference

| Field | Required | Type | Description |
|-------|----------|------|-------------|
| `scorecard_id` | Yes | slug | Stable unique identifier |
| `name` | Yes | string | Human-readable name |
| `type` | Yes | literal | Always `compliance-scorecard` |
| `scope` | Yes | string | `system` |
| `status` | Yes | enum | `active` / `draft` / `deprecated` |
| `owner` | Yes | string | Team responsible |
| `assessment_date` | Yes | date | ISO date the scorecard was created |
| `next_assessment` | Yes | date | ISO date of next scheduled assessment |
| `last_reviewed` | Yes | date | ISO date of last review |
| `tags` | No | list | Searchable tags |

### 10.4 Scorecard body structure

After the metadata block, every scorecard MUST include:

```
## Summary
## Per-Framework Scores
## Maturity Assessment
## Trend
## Action Items
```

### 10.5 Per-framework scores

```markdown
## Per-Framework Scores

| Framework | Total | Fully Covered | Partially Covered | Not Covered | N/A | Coverage % | Maturity |
|-----------|-------|---------------|-------------------|-------------|-----|------------|----------|
| OWASP Web 2021 | 10 | 7 | 2 | 1 | 0 | 80% | Managed |
| OWASP API 2023 | 10 | 6 | 3 | 1 | 0 | 75% | Defined |
| OWASP Mobile 2024 | 10 | 3 | 2 | 0 | 5 | 100%* | Initial |
| OWASP LLM 2025 | 10 | 4 | 4 | 2 | 0 | 60% | Initial |
| NIS2 Art. 21 | 10 | 5 | 3 | 2 | 0 | 65% | Defined |
```

*Coverage % excludes N/A requirements.

### 10.6 Maturity model

AFCS defines a five-level maturity model for compliance posture:

| Level | Name | Definition |
|-------|------|------------|
| 1 | Initial | Some controls exist but no systematic mapping to the framework |
| 2 | Defined | All requirements are mapped; gaps are identified and documented |
| 3 | Managed | All gaps have remediation plans with deadlines and owners |
| 4 | Measured | Coverage is tracked over time; metrics drive prioritization decisions |
| 5 | Optimized | Continuous improvement; automated compliance verification in CI/CD |

### 10.7 Trend tracking

Track compliance scores over time:

```markdown
## Trend

| Period | OWASP Web | OWASP API | OWASP Mobile | OWASP LLM | NIS2 Art.21 |
|--------|-----------|-----------|--------------|-----------|-------------|
| Q4 2025 | 70% | 60% | — | — | 50% |
| Q1 2026 | 80% | 75% | 100%* | 60% | 65% |
```

### 10.8 Action items

Prioritized list of actions to improve compliance scores, derived from the gap analyses in the individual mapping files.

---

## 11. Integration with AFSS `compliance_refs`

### 11.1 AFSS `compliance_refs` is the lightweight pointer

The `compliance_refs` field in AFSS control and policy metadata remains as a quick-reference list of framework requirement IDs. Example:

```yaml
compliance_refs: ["OWASP-A01", "OWASP-API1", "NIS2-Art21-2a"]
```

### 11.2 AFCS is the authoritative source

AFCS compliance mappings are the authoritative source for which controls map to which requirements. If `compliance_refs` in an AFSS control and the AFCS mapping table disagree, the AFCS mapping is correct and the AFSS `compliance_refs` should be updated.

### 11.3 Canonical reference ID format

AFCS defines the following reference ID formats for use in `compliance_refs`:

| Framework | Format | Examples |
|-----------|--------|---------|
| OWASP Top 10 Web 2021 | `OWASP-A{NN}` | `OWASP-A01`, `OWASP-A10` |
| OWASP API Security 2023 | `OWASP-API{N}` | `OWASP-API1`, `OWASP-API10` |
| OWASP Mobile 2024 | `OWASP-M{N}` | `OWASP-M1`, `OWASP-M10` |
| OWASP LLM 2025 | `OWASP-LLM{NN}` | `OWASP-LLM01`, `OWASP-LLM10` |
| NIS2 Article 21 | `NIS2-Art21-{N}{sub}` | `NIS2-Art21-2a`, `NIS2-Art21-2j` |

These IDs are designed to be concise for use in YAML metadata while remaining unambiguous. The full requirement text is documented in the AFCS mapping file and in Appendix E.

---

## 12. Compliance Registry

### 12.1 Registry file locations

The docs hub MUST contain:

```
docs/compliance/frameworks.yaml        ← framework registry (required)
docs/compliance/scorecards.yaml        ← scorecard registry (optional)
```

### 12.2 Registry rules

- `framework_id` MUST be unique and kebab-case with version/year.
- `mapping_id` in a mapping file MUST correspond to a registered `framework_id`.
- `checklist_id` in a checklist MUST reference a valid `framework_id` and `mapping_id`.
- Referenced file paths MUST exist and contain valid YAML frontmatter.
- `control_id` values referenced in mapping tables MUST match entries in AFSS `controls.yaml`.
- `policy_id` values referenced in mapping tables MUST match entries in AFSS `policies.yaml`.
- Registries SHOULD be validated in CI (e.g., check that all referenced files exist and contain valid metadata, and that all control/policy references resolve).

---

## 13. AI/LLM Integration Model

### 13.1 Compliance discovery

When an AI agent starts a session and needs to understand compliance posture, it MUST:

1. Read `docs/compliance/frameworks.yaml` to discover tracked frameworks.
2. Read individual mapping files for frameworks applicable to the current task.
3. Read the compliance scorecard for a quantitative summary.
4. Cross-reference with AFSS `controls.yaml` to understand control coverage.

### 13.2 Compliance-aware code generation

When generating or modifying code, the AI agent SHOULD:

1. Identify which framework requirements are relevant to the code being written (e.g., OWASP Web for web app code, OWASP API for API routes, OWASP LLM for AI integrations).
2. Read the corresponding checklist items.
3. Verify the generated code does not introduce compliance regressions.
4. Reference specific requirement IDs (e.g., `OWASP-A01`) when flagging potential compliance issues.

### 13.3 Compliance gap identification

When reviewing security posture, the AI agent SHOULD:

1. Read the mapping files and identify `partial` or `none` coverage.
2. Suggest specific AFSS controls that could be created to close gaps.
3. Estimate the impact on the compliance scorecard.

### 13.4 Risk assessment assistance

When performing or updating risk assessments, the AI agent SHOULD:

1. Read the risk assessment methodology from section 9.5.
2. Help score likelihood and impact using the defined scales.
3. Cross-reference the AFSS threat model for threat IDs.
4. Never override a human-assigned risk score without explicit approval.

### 13.5 Checklist execution assistance

When helping execute a compliance checklist, the AI agent SHOULD:

1. Read each check item and determine whether it can be verified through code inspection or automated testing.
2. For items it can verify, perform the verification and report pass/fail with evidence.
3. For items it cannot verify (e.g., physical security, contractual obligations), flag them as requiring human verification.

---

## 14. Lifecycle and Review

### 14.1 Review triggers

A compliance artifact MUST be reviewed when:

| Trigger | Review deadline |
|---------|----------------|
| Framework updated (new version released) | within 30 days |
| 180 days since last scorecard assessment | within 2 weeks |
| New AFSS control added | within 1 week (update affected mappings) |
| AFSS control deprecated | within 3 business days (update affected mappings) |
| Security incident affecting compliance posture | within 1 week (re-assess risk) |
| Pre-audit preparation | 4 weeks before audit |

### 14.2 Scorecard assessment schedule

Compliance scorecards MUST be updated at least quarterly. Organizations with regulatory obligations (e.g., NIS2) SHOULD assess monthly.

### 14.3 Framework version management

When a compliance framework releases a new version:

1. Register the new version in `frameworks.yaml` with status `active`.
2. Create a new mapping file (do not overwrite the old one).
3. Create a new checklist.
4. Set the old framework version's status to `deprecated`.
5. Update the scorecard.
6. Allow a transition period (recommended: 90 days) during which both versions are tracked.

### 14.4 Risk assessment frequency

Risk assessments MUST be performed on a schedule:

| Scope | Frequency |
|-------|-----------|
| System-level | Quarterly |
| Critical components | Quarterly |
| Non-critical components | Semi-annually |
| Post-incident | Within 1 week of incident closure |

---

## 15. Definition of Done

A compliance mapping is considered **compliant** when:

- [ ] Metadata block contains all required fields (section 6.1)
- [ ] All required body sections are present (section 7)
- [ ] Every framework requirement has an entry in the mapping table
- [ ] Coverage values are accurate (`full` / `partial` / `none` / `not-applicable`)
- [ ] All referenced `control_id` values exist in AFSS `controls.yaml`
- [ ] All referenced `policy_id` values exist in AFSS `policies.yaml`
- [ ] Gap analysis is complete for all `partial` and `none` entries
- [ ] Remediation plan has prioritized entries for all gaps
- [ ] `coverage_summary` in metadata matches the mapping table
- [ ] `last_reviewed` is within 180 days
- [ ] Framework is registered in `frameworks.yaml`

A compliance checklist is considered **compliant** when:

- [ ] Metadata block contains all required fields (section 8.1)
- [ ] Every framework requirement has a checklist section with check items
- [ ] Every check item cross-references at least one AFSS control or policy
- [ ] Check items are specific enough for pass/fail determination
- [ ] Execution record exists with at least one entry
- [ ] `last_executed` is within the `execution_frequency` period

A risk assessment is considered **compliant** when:

- [ ] Metadata block contains all required fields (section 9.1)
- [ ] Methodology is documented (section 9.5)
- [ ] Risk register contains all identified risks
- [ ] Every risk references a threat ID from the AFSS threat model
- [ ] Risk heatmap is present and accurate
- [ ] Treatment plan covers all risks not fully mitigated
- [ ] `assessment_date` is within the assessment frequency (section 14.4)

A system is considered **compliance-documented** when:

- [ ] All applicable compliance frameworks are registered in `frameworks.yaml`
- [ ] Every registered framework has a mapping file
- [ ] Every registered framework has a checklist
- [ ] A system-level risk assessment exists and is current
- [ ] A compliance scorecard exists and is current (within 90 days)
- [ ] Compliance scorecard is reviewed at least quarterly

---

## 16. Relationship to AFADS, AFOPS, AFPS, and AFSS

### 16.1 What AFCS extends

| Standard | Section | AFCS Relationship |
|----------|---------|-------------------|
| AFSS | Section 5.2 (`compliance_refs`) | AFCS provides the full mapping; `compliance_refs` is a lightweight shorthand |
| AFSS | Section 9 (Threat Model) | Risk assessments reference AFSS threat IDs |
| AFSS | Section 12 (Control Registry) | AFCS mappings reference controls by `control_id` |
| AFSS | Section 6 (Policy Schema) | AFCS mappings reference policies by `policy_id` |
| AFADS | Section 5.1 (`00-orientation.md`) | Compliance frameworks should be listed as constraints |
| AFOPS | Procedures of type `patch`, `maintenance` | NIS2 operational requirements map to AFOPS procedures |
| AFPS | Conventions of type `pattern` | OWASP code-level requirements map to AFPS patterns |

### 16.2 What AFCS does not replace

- AFSS controls and policies — AFCS maps to them, does not define them
- AFSS threat models — AFCS risk assessments extend but do not replace threat models
- AFADS architecture documentation
- AFOPS operational procedures
- AFPS coding conventions

### 16.3 Cross-references

- AFCS `control_id` references in mapping tables MUST match AFSS `controls.yaml`.
- AFCS `policy_id` references MUST match AFSS `policies.yaml`.
- AFCS risk assessment `Threat ID` references MUST match AFSS threat model threat IDs.
- AFCS `procedure_id` references (for NIS2 operational requirements) MUST match AFOPS `procedures.yaml`.
- AFCS checklist items that reference code patterns SHOULD cite the corresponding AFPS `convention_id`.

---

## 17. Appendix A: Example Compliance Mapping (OWASP Web 2021, abbreviated)

```markdown
---
mapping_id: owasp-web-2021
name: OWASP Top 10 (2021) Compliance Mapping
type: compliance-mapping
framework_id: owasp-web-2021
scope: system
status: active
owner: security-team
last_reviewed: 2026-02-10
coverage_summary:
  total_requirements: 10
  fully_covered: 7
  partially_covered: 2
  not_covered: 1
  not_applicable: 0
  coverage_percent: 80
---

## Framework Overview

The OWASP Top 10 (2021) is the most widely recognized awareness document
for web application security. It represents a broad consensus about the
most critical security risks to web applications. Version 2021 includes
three new categories (A04, A08, A10) and renamed/restructured several
existing categories.

Source: https://owasp.org/Top10/

## Requirement Mapping Table

| Req ID | Requirement | AFSS Controls | AFSS Policies | Coverage | Notes |
|--------|-------------|---------------|---------------|----------|-------|
| A01:2021 | Broken Access Control | auth-rls-user-profiles, authz-supabase-policies | authorization | full | RLS + server-side auth checks |
| A02:2021 | Cryptographic Failures | secrets-env-separation, infra-tls-all-endpoints | secrets-management | full | TLS enforced, no hardcoded secrets |
| A03:2021 | Injection | input-validation-api, db-parameterized-queries | input-validation | full | Supabase client handles parameterization; Zod on all inputs |
| A04:2021 | Insecure Design | — | — | partial | Threat model exists but not all features have design reviews |
| A05:2021 | Security Misconfiguration | infra-hardened-containers, csp-script-nonce | browser-security | full | CSP, security headers, container hardening |
| A06:2021 | Vulnerable and Outdated Components | deps-vulnerability-scanning | dependency-security | full | Automated scanning via Dependabot |
| A07:2021 | Identification and Authentication Failures | auth-jwt-validation, auth-session-middleware | authentication | full | Supabase Auth handles auth; server-side JWT verification |
| A08:2021 | Software and Data Integrity Failures | — | — | none | No CI/CD pipeline integrity checks yet |
| A09:2021 | Security Logging and Monitoring Failures | infra-logging | — | partial | Basic logging exists but no alerting on security events |
| A10:2021 | Server-Side Request Forgery (SSRF) | input-validation-api | input-validation | full | No user-supplied URL fetching in current architecture |

## Gap Analysis

### A04:2021 — Insecure Design (partial)

A system-level threat model exists per AFSS section 9, but there is no
formal secure design review process for new features. Design review
checklists and sign-off requirements need to be established.

**Recommended:** Create an AFOPS procedure `secure-design-review` that is
triggered before feature implementation begins.

### A08:2021 — Software and Data Integrity Failures (none)

The CI/CD pipeline does not currently include integrity verification for
build artifacts, dependencies, or deployment images.

**Recommended:** Create AFSS control `infra-ci-integrity` covering signed
commits, dependency lock file verification, and container image signing.

### A09:2021 — Security Logging and Monitoring Failures (partial)

Application logging exists but lacks security-specific alerting. No
automated detection of authentication failures, access control
violations, or input validation failures.

**Recommended:** Extend AFSS control `infra-logging` to include security
event alerting rules and create an AFOPS procedure for log review.

## Remediation Plan

| Priority | Req ID | Gap | Remediation | Target Date | Owner |
|----------|--------|-----|-------------|-------------|-------|
| 1 | A08:2021 | No CI/CD integrity checks | Create control `infra-ci-integrity` | 2026-Q2 | platform-team |
| 2 | A09:2021 | No security event alerting | Extend `infra-logging` with alerting | 2026-Q2 | platform-team |
| 3 | A04:2021 | No formal design review process | Create procedure `secure-design-review` | 2026-Q3 | platform-team |
```

---

## 18. Appendix B: Example Compliance Checklist (OWASP Web 2021, abbreviated)

```markdown
---
checklist_id: owasp-web-2021-checklist
name: OWASP Top 10 (2021) Compliance Checklist
type: compliance-checklist
framework_id: owasp-web-2021
mapping_id: owasp-web-2021
scope: system
component_id: system
status: active
owner: security-team
last_reviewed: 2026-02-10
last_executed: 2026-02-01
execution_frequency: quarterly
---

## Purpose

This checklist verifies compliance with the OWASP Top 10 (2021)
requirements. Execute this checklist quarterly as part of the security
review process. Each check item maps to an AFSS control for traceability.

## Checklist

### A01:2021 — Broken Access Control

Related controls: `auth-rls-user-profiles`, `authz-supabase-policies`
Related policy: `authorization`

- [ ] RLS is enabled on every table containing user data
- [ ] RLS policies are tested with at least 2 user roles (run test suite)
- [ ] No use of service role key in client-accessible code (grep codebase)
- [ ] API routes verify user permissions before data access
- [ ] Vertical privilege escalation tests pass (non-admin cannot access admin routes)
- [ ] Horizontal privilege escalation tests pass (user A cannot access user B data)
- [ ] CORS is restricted to known origins (check security headers)
- [ ] Directory listing is disabled on all web servers

### A02:2021 — Cryptographic Failures

Related controls: `secrets-env-separation`, `infra-tls-all-endpoints`
Related policy: `secrets-management`

- [ ] All data in transit uses TLS 1.2+ (verify with SSL Labs or equivalent)
- [ ] No sensitive data transmitted in URL parameters
- [ ] Passwords are hashed with bcrypt/argon2 (or delegated to auth provider)
- [ ] No hardcoded secrets in source code (run secret scanner)
- [ ] Secret rotation procedure exists and has been tested within the last quarter
- [ ] No deprecated cryptographic algorithms in use (MD5, SHA-1, DES)
- [ ] Sensitive data at rest is encrypted

### A03:2021 — Injection

Related controls: `input-validation-api`, `db-parameterized-queries`
Related policy: `input-validation`

- [ ] All user input is validated server-side (Zod schemas on all endpoints)
- [ ] SQL queries use parameterized statements (no string concatenation)
- [ ] No `eval()`, `Function()`, or equivalent dynamic code execution on user input
- [ ] Template engines use auto-escaping for HTML output
- [ ] File upload types are validated and restricted
- [ ] File upload sizes are limited

## Execution Record

| Date | Executor | Passed | Failed | N/A | Notes |
|------|----------|--------|--------|-----|-------|
| 2026-02-01 | security-team | 18 | 2 | 1 | A02 secret rotation not tested, A01 directory listing not checked |
| 2025-11-01 | security-team | 16 | 4 | 1 | |
```

---

## 19. Appendix C: Example Risk Assessment (abbreviated)

```markdown
---
assessment_id: system-risk-assessment-2026q1
name: System Risk Assessment Q1 2026
type: risk-assessment
scope: system
methodology: likelihood-impact
risk_scale: 5x5
status: active
owner: security-team
assessment_date: 2026-01-15
next_assessment: 2026-04-15
last_reviewed: 2026-02-10
---

## Methodology

This assessment uses the Likelihood × Impact (5×5) methodology defined
in AFCS section 9.5. Risk scores range from 1 to 25 and map to AFSS
criticality levels: Low (1–4), Medium (5–9), High (10–16),
Critical (17–25).

## Risk Matrix Definition

### Likelihood Scale

| Score | Level | Definition |
|-------|-------|------------|
| 1 | Rare | < 1% chance per year |
| 2 | Unlikely | 1–10% chance per year |
| 3 | Possible | 10–50% chance per year |
| 4 | Likely | 50–90% chance per year |
| 5 | Almost Certain | > 90% chance per year |

### Impact Scale

| Score | Level | Definition |
|-------|-------|------------|
| 1 | Negligible | No user impact, no data exposure |
| 2 | Minor | Limited user impact, no sensitive data |
| 3 | Moderate | Service degradation, limited data exposure |
| 4 | Major | Service outage, sensitive data exposure |
| 5 | Severe | Complete compromise, regulatory impact |

## Risk Register

| Risk ID | Threat ID | Description | L | I | Score | Category | Treatment | Control IDs | Owner |
|---------|-----------|-------------|---|---|-------|----------|-----------|-------------|-------|
| RISK-001 | threat-disclosure-user-data-leak | Unauthorized access to user data via broken access control | 2 | 5 | 10 | High | Mitigate | auth-rls-user-profiles, authz-supabase-policies | platform-team |
| RISK-002 | threat-tampering-sql-injection | SQL injection via unvalidated form input | 1 | 5 | 5 | Medium | Mitigate | input-validation-api, db-parameterized-queries | platform-team |
| RISK-003 | threat-dos-api-flood | API overwhelmed by excessive request volume | 3 | 3 | 9 | Medium | Mitigate | api-rate-limiting | platform-team |
| RISK-004 | threat-integrity-ci-pipeline | Malicious code injected via compromised CI/CD pipeline | 2 | 5 | 10 | High | Accept | — | platform-team |
| RISK-005 | threat-disclosure-logging-gap | Security events not detected due to insufficient monitoring | 3 | 4 | 12 | High | Mitigate | infra-logging | platform-team |

## Risk Heatmap

|                          | Negligible (1) | Minor (2) | Moderate (3) | Major (4) | Severe (5) |
|--------------------------|:-:|:-:|:-:|:-:|:-:|
| **Almost Certain (5)**   | 5 | 10 | 15 | 20 | **25** |
| **Likely (4)**           | 4 | 8 | 12 | 16 | **20** |
| **Possible (3)**         | 3 | 6 | RISK-003 (9) | RISK-005 (12) | 15 |
| **Unlikely (2)**         | 2 | 4 | 6 | 8 | RISK-001 (10), RISK-004 (10) |
| **Rare (1)**             | 1 | 2 | 3 | 4 | RISK-002 (5) |

## Treatment Plan

| Priority | Risk ID | Current Score | Treatment | Action | Target Score | Target Date | Owner |
|----------|---------|---------------|-----------|--------|--------------|-------------|-------|
| 1 | RISK-005 | 12 (High) | Mitigate | Add security event alerting to logging | 6 (Medium) | 2026-Q2 | platform-team |
| 2 | RISK-004 | 10 (High) | Mitigate | Implement CI/CD integrity checks | 4 (Low) | 2026-Q2 | platform-team |
| 3 | RISK-003 | 9 (Medium) | Mitigate | Implement adaptive rate limiting | 6 (Medium) | 2026-Q3 | platform-team |
```

---

## 20. Appendix D: Example Compliance Scorecard (abbreviated)

```markdown
---
scorecard_id: compliance-scorecard-2026q1
name: Compliance Scorecard Q1 2026
type: compliance-scorecard
scope: system
status: active
owner: security-team
assessment_date: 2026-02-10
next_assessment: 2026-05-10
last_reviewed: 2026-02-10
---

## Summary

Overall compliance posture: **Defined** (maturity level 2). Coverage
ranges from 60% (OWASP LLM) to 100% (OWASP Mobile, excluding N/A).
Three frameworks have active remediation plans.

## Per-Framework Scores

| Framework | Total | Fully Covered | Partially | Not Covered | N/A | Coverage % | Maturity |
|-----------|-------|---------------|-----------|-------------|-----|------------|----------|
| OWASP Web 2021 | 10 | 7 | 2 | 1 | 0 | 80% | Managed |
| OWASP API 2023 | 10 | 6 | 3 | 1 | 0 | 75% | Defined |
| OWASP Mobile 2024 | 10 | 3 | 2 | 0 | 5 | 100%* | Initial |
| OWASP LLM 2025 | 10 | 4 | 4 | 2 | 0 | 60% | Initial |
| NIS2 Art. 21 | 10 | 5 | 3 | 2 | 0 | 65% | Defined |

*Coverage % excludes N/A requirements.

## Maturity Assessment

| Framework | Current Level | Target Level | Target Date |
|-----------|---------------|--------------|-------------|
| OWASP Web 2021 | 3 — Managed | 4 — Measured | 2026-Q3 |
| OWASP API 2023 | 2 — Defined | 3 — Managed | 2026-Q3 |
| OWASP Mobile 2024 | 1 — Initial | 2 — Defined | 2026-Q3 |
| OWASP LLM 2025 | 1 — Initial | 2 — Defined | 2026-Q3 |
| NIS2 Art. 21 | 2 — Defined | 3 — Managed | 2026-Q4 |

## Trend

| Period | OWASP Web | OWASP API | OWASP Mobile | OWASP LLM | NIS2 Art.21 |
|--------|-----------|-----------|--------------|-----------|-------------|
| Q3 2025 | 60% | 50% | — | — | 40% |
| Q4 2025 | 70% | 60% | — | — | 50% |
| Q1 2026 | 80% | 75% | 100%* | 60% | 65% |

## Action Items

| Priority | Framework | Action | Impact | Target Date | Owner |
|----------|-----------|--------|--------|-------------|-------|
| 1 | OWASP Web | Close A08 gap (CI/CD integrity) | +10% coverage | 2026-Q2 | platform-team |
| 2 | NIS2 Art. 21 | Implement incident response procedure | +10% coverage | 2026-Q2 | platform-team |
| 3 | OWASP LLM | Create prompt injection controls | +10% coverage | 2026-Q2 | ai-team |
| 4 | OWASP API | Implement API inventory management | +5% coverage | 2026-Q3 | platform-team |
```

---

## 21. Appendix E: Framework Requirement Reference Tables

This appendix provides canonical reference tables for all five frameworks covered by this standard. These tables serve as a quick reference so that mapping authors can use official requirement IDs without consulting external sources.

### E.1 OWASP Top 10 — Web Applications (2021)

Source: https://owasp.org/Top10/

| Req ID | Name | Description |
|--------|------|-------------|
| A01:2021 | Broken Access Control | Failures in enforcing access restrictions, allowing unauthorized actions or data access |
| A02:2021 | Cryptographic Failures | Weaknesses in cryptography or its absence, exposing sensitive data |
| A03:2021 | Injection | Untrusted data sent to an interpreter as part of a command or query (SQL, NoSQL, OS, LDAP) |
| A04:2021 | Insecure Design | Missing or ineffective security controls due to design and architectural flaws |
| A05:2021 | Security Misconfiguration | Missing security hardening, unnecessary features enabled, default accounts, overly informative errors |
| A06:2021 | Vulnerable and Outdated Components | Using components with known vulnerabilities or unsupported/outdated software |
| A07:2021 | Identification and Authentication Failures | Weaknesses in authentication allowing identity compromise (credential stuffing, weak passwords, session issues) |
| A08:2021 | Software and Data Integrity Failures | Code and infrastructure that does not protect against integrity violations (unsigned updates, insecure CI/CD, untrusted deserialization) |
| A09:2021 | Security Logging and Monitoring Failures | Insufficient logging, monitoring, and alerting that delays breach detection and incident response |
| A10:2021 | Server-Side Request Forgery (SSRF) | Application fetches remote resources without validating user-supplied URLs, enabling access to internal systems |

### E.2 OWASP API Security Top 10 (2023)

Source: https://owasp.org/API-Security/

| Req ID | Name | Description |
|--------|------|-------------|
| API1:2023 | Broken Object Level Authorization | APIs exposing object IDs without proper authorization checks, allowing access to other users' objects |
| API2:2023 | Broken Authentication | Flawed authentication mechanisms allowing attackers to compromise tokens or assume other identities |
| API3:2023 | Broken Object Property Level Authorization | APIs exposing or accepting object properties without proper authorization, enabling data leakage or mass assignment |
| API4:2023 | Unrestricted Resource Consumption | APIs without limits on request size, frequency, or resource usage, enabling DoS or cost exploitation |
| API5:2023 | Broken Function Level Authorization | Complex access control with different roles and groups leading to authorization flaws at the function level |
| API6:2023 | Unrestricted Access to Sensitive Business Flows | APIs exposing business flows without controls to prevent automated abuse (scraping, scalping, spam) |
| API7:2023 | Server-Side Request Forgery | APIs fetching remote resources without validating user-supplied URIs |
| API8:2023 | Security Misconfiguration | Misconfigured APIs and supporting systems due to complex configurations, missing patches, or unnecessary features |
| API9:2023 | Improper Inventory Management | APIs with outdated documentation, exposed debug endpoints, or deprecated/unpatched API versions |
| API10:2023 | Unsafe Consumption of APIs | Trusting data from third-party APIs without validation, creating indirect attack vectors |

### E.3 OWASP Mobile Top 10 (2024)

Source: https://owasp.org/www-project-mobile-top-10/

| Req ID | Name | Description |
|--------|------|-------------|
| M1:2024 | Improper Credential Usage | Hardcoded credentials, insecure credential transmission, or insecure credential storage in mobile applications |
| M2:2024 | Inadequate Supply Chain Security | Vulnerabilities introduced through third-party libraries, SDKs, or compromised development tools |
| M3:2024 | Insecure Authentication/Authorization | Weak authentication mechanisms or improper authorization checks in mobile applications |
| M4:2024 | Insufficient Input/Output Validation | Failure to properly validate input and output, leading to injection attacks or data corruption |
| M5:2024 | Insecure Communication | Inadequate encryption of data in transit, improper certificate validation, cleartext transmission |
| M6:2024 | Inadequate Privacy Controls | Excessive permissions, improper data collection, insufficient user consent, or PII mishandling |
| M7:2024 | Insufficient Binary Protections | Lack of code obfuscation, anti-tampering measures, or runtime application self-protection (RASP) |
| M8:2024 | Security Misconfiguration | Improper platform-specific security settings, debug features left enabled, excessive permissions |
| M9:2024 | Insecure Data Storage | Sensitive data stored insecurely on device (logs, caches, unencrypted databases, shared preferences) |
| M10:2024 | Insufficient Cryptography | Use of weak or deprecated cryptographic algorithms, improper key management, or missing encryption |

### E.4 OWASP Top 10 for LLM Applications (2025)

Source: https://genai.owasp.org/resource/owasp-top-10-for-llm-applications-2025/

| Req ID | Name | Description |
|--------|------|-------------|
| LLM01:2025 | Prompt Injection | Manipulating LLM inputs to override instructions, extract sensitive information, or trigger unintended behaviors |
| LLM02:2025 | Sensitive Information Disclosure | LLMs unintentionally revealing PII, system credentials, proprietary data, or confidential business information |
| LLM03:2025 | Supply Chain | Compromised foundation models, poisoned training data, vulnerable plugins, or insecure third-party model APIs |
| LLM04:2025 | Data and Model Poisoning | Corrupting LLM behavior by manipulating training data, fine-tuning datasets, or RAG data sources |
| LLM05:2025 | Improper Output Handling | Neglecting to validate or sanitize LLM outputs, leading to downstream code execution or data exposure |
| LLM06:2025 | Excessive Agency | Granting LLMs unchecked autonomy with overly broad permissions, insufficient oversight, or inadequate guardrails |
| LLM07:2025 | System Prompt Leakage | Exposure of system prompts containing sensitive instructions, API keys, connection strings, or access control logic |
| LLM08:2025 | Vector and Embedding Weaknesses | Vulnerabilities in vector databases and embedding systems enabling data poisoning or unauthorized access |
| LLM09:2025 | Misinformation | LLMs producing false or misleading information that appears credible, including hallucinations and fabricated citations |
| LLM10:2025 | Unbounded Consumption | Excessive or uncontrolled resource usage causing DoS, financial exploitation via API costs, or unauthorized model replication |

### E.5 NIS2 Directive — Article 21 Cybersecurity Risk-Management Measures

Source: Directive (EU) 2022/2555 — Article 21(2)(a)–(j)

| Req ID | Measure | Description |
|--------|---------|-------------|
| Art.21-2a | Risk analysis and information system security policies | Policies for risk analysis and overall information system security |
| Art.21-2b | Incident handling | Procedures for preventing, detecting, and responding to cybersecurity incidents |
| Art.21-2c | Business continuity and crisis management | Backup management, disaster recovery, and crisis management procedures |
| Art.21-2d | Supply chain security | Security aspects concerning relationships between the entity and its direct suppliers or service providers |
| Art.21-2e | Security in network and information systems acquisition, development, and maintenance | Security in the acquisition, development, and maintenance of systems, including vulnerability handling and disclosure |
| Art.21-2f | Policies and procedures for assessing effectiveness | Policies and procedures to assess the effectiveness of cybersecurity risk-management measures |
| Art.21-2g | Basic cyber hygiene practices and cybersecurity training | Cyber hygiene practices (patching, configuration, password management) and awareness training |
| Art.21-2h | Policies and procedures regarding the use of cryptography | Cryptographic policies including encryption implementation and key management |
| Art.21-2i | Human resources security, access control, and asset management | Personnel security, access control policies, and asset management |
| Art.21-2j | Use of multi-factor authentication or continuous authentication | Multi-factor authentication, continuous authentication, secured voice/video/text, and secured emergency communications |

---

## 22. Summary

This standard provides:
- a **compliance mapping framework** where every external requirement is mapped bidirectionally to AFSS controls and policies
- a **framework registration system** that tracks which compliance frameworks are applicable and their current state
- **actionable checklists** organized by framework requirement with cross-references to AFSS controls
- a **risk assessment specification** with two built-in scoring methodologies (likelihood × impact 5×5 and CVSS-based) that integrate with AFSS criticality levels
- a **compliance scorecard** with quantitative coverage tracking and a five-level maturity model
- a **canonical reference ID format** for compliance framework requirements, usable in AFSS `compliance_refs`
- an **AI integration model** that enables AI agents to discover compliance posture, identify gaps, and assist with risk assessments
- **lifecycle management** including framework version handling, review triggers, and assessment schedules
- clear **relationship to AFADS, AFOPS, AFPS, and AFSS** so all five standards work together
- **reference tables** for all 50 requirements across five frameworks: OWASP Web (2021), OWASP API (2023), OWASP Mobile (2024), OWASP LLM (2025), and NIS2 Article 21
