# AI-Friendly Security Standard (AFSS)

Version: 0.1
Status: Draft / Working Standard
Last updated: 2026-02-07
Author: Sebastian Mang
Companion to: AI-Friendly Architecture Documentation Standard (AFADS),
              AI-Friendly Operational Procedures Standard (AFOPS),
              AI-Friendly Programming Standard (AFPS),
              AI-Friendly Compliance Standard (AFCS),
              AI-Friendly Roadmap Standard (AFRS)

## 1. Purpose

This standard defines how to document, structure, and maintain security controls and policies so they are:
- **human-readable** — clear enough for any engineer to assess, implement, and verify
- **AI-parseable** — structured so an LLM can discover, interpret, and enforce security controls when generating or reviewing code
- **traceable** — every control maps to threats, policies, and verification steps
- **consistent across repos** — every security artifact follows the same format
- **verifiable** — every control has explicit verification steps that can be executed by a human or automated system

### 1.1 Scope

This standard covers **application and infrastructure security**:
- authentication and session management
- authorization and access control
- input validation and output encoding
- secrets management and key rotation
- dependency security and supply chain
- API security (rate limiting, request validation)
- browser security (CORS, CSP, security headers)
- database security (RLS, connection security, migration safety)
- infrastructure hardening (container security, network policies)
- security review process and threat modeling

### 1.2 What AFSS Is Not

AFSS is not a penetration testing methodology. It is not a compliance framework (SOC 2, ISO 27001, GDPR). It is a documentation standard for security controls, policies, and review processes that may support those frameworks. For compliance framework mappings, checklists, risk scoring, and compliance scorecards, see the AI-Friendly Compliance Standard (AFCS).

AFSS is not an incident response plan. Incident response belongs in operational procedures (AFOPS) and the architecture ops document (AFADS `06-ops.md`).

### 1.3 Relationship to AFADS, AFOPS, and AFPS

AFSS is a companion to all three existing standards:
- AFADS section 5.6 (`05-security.md`) — AFSS provides the detailed control framework that `05-security.md` summarizes at the architecture level
- AFADS section 4.3 (`component.md`) body section 8 (Known risks) — component risks should reference AFSS threat IDs and control IDs
- AFOPS — security patching, certificate rotation, secret rotation, and vulnerability response are operational procedures defined per AFOPS. AFSS defines the security controls; AFOPS defines how to execute them operationally
- AFPS — code-level security conventions (input validation patterns, auth patterns) are AFPS patterns that implement AFSS controls

---

## 2. Core Principles

### 2.1 Security controls are documented and traceable

Every security control has a stable ID, maps to one or more threats, and has verification steps. If it is not documented, it is not a control.

### 2.2 Security lives close to the code

Each repository documents its own security controls. System-wide security policies live in the docs hub. Component-level controls reference system policies.

### 2.3 Security metadata is machine-readable

Security control artifacts use YAML metadata so AI agents and CI tooling can discover, verify, and enforce them without parsing prose.

### 2.4 Defense in depth is explicit

For every asset or data flow, the standard requires documenting multiple layers of defense. A single control is never sufficient. The defense layers (network, application, data, identity) must be traceable.

### 2.5 Threat models drive controls

Security controls are justified by threats. Every control references the threat(s) it mitigates. Controls without a threat justification should be questioned.

### 2.6 AI agents are security-aware

When an AI agent generates or reviews code, it must consult the security controls and verify compliance. AI agents must never weaken a security control, even if asked to.

---

## 3. Artifact Types

AFSS defines two primary artifact types:

| Artifact | Description | Scope | Example |
|----------|-------------|-------|---------|
| `security-policy` | System-wide security policy covering a domain | System | Authentication policy, secrets management policy |
| `security-control` | Specific, verifiable security measure applied to a component or system | Component or system | RLS enabled on `user_profiles` table, CORS restricted to app domain |

Additionally, AFSS references these related artifacts from other standards:

| Artifact | Defined by | How AFSS uses it |
|----------|------------|------------------|
| Threat model | AFSS section 9 | Threat models identify threats; controls mitigate them |
| Security review | AFSS section 10 | Review records document security assessments |
| Procedure | AFOPS | Security operations (patching, rotation) are AFOPS procedures |
| Pattern | AFPS | Code-level security patterns are AFPS pattern conventions |

---

## 4. File Layout and Naming

### 4.1 Component repositories

Security documentation lives inside the AFADS-required `docs/` directory:

```
docs/
  security.md                 ← component security overview (required)
  security/
    controls.yaml             ← machine-readable control index (required)
    threat-model.md           ← component-level threat model (if applicable)
    controls/
      auth-rls-user-data.md   ← one file per control
      input-validation-api.md
      ...
```

### 4.2 File naming

Control files MUST be named using a descriptive kebab-case slug that matches the `control_id`:

```
<domain>-<description>.md
```

Where domain is one of: `auth`, `authz`, `input`, `secrets`, `deps`, `api`, `cors`, `csp`, `db`, `infra`, `network`.

### 4.3 The security.md overview

Every repository MUST contain `docs/security.md`. This file provides a human-readable overview of the component's security posture:

- Lists all security controls for the component in a summary table
- References the component's threat model (if it has one)
- Links to individual control files
- Cross-references the system-level security policy

Example:

```markdown
# Security: webapp

| Control | Domain | Criticality | Status | File |
|---------|--------|-------------|--------|------|
| auth-rls-user-data | db | critical | verified | [controls/auth-rls-user-data.md](security/controls/auth-rls-user-data.md) |
| input-validation-api | input | high | implemented | [controls/input-validation-api.md](security/controls/input-validation-api.md) |
| csp-script-policy | csp | high | implemented | [controls/csp-script-policy.md](security/controls/csp-script-policy.md) |

Threat model: [security/threat-model.md](security/threat-model.md)
System security policy: See docs hub `docs/security/policies/`
```

### 4.4 System-level security (docs hub repo)

System-wide security policies and the system threat model live in the docs hub:

```
docs/
  security/
    policies/
      authentication.md
      authorization.md
      secrets-management.md
      dependency-security.md
      network-security.md
      data-classification.md
      ...
    threat-model/
      system-threat-model.md
      stride-analysis.md
      trust-boundaries.md
    controls.yaml              ← system-level control registry
    policies.yaml              ← policy registry
    reviews/
      2026-Q1-review.md        ← periodic security review records
```

### 4.5 Relationship between policies and controls

Policies are system-wide rules. Controls are specific implementations of those rules at the component level. A policy may spawn many controls across many components. Every control MUST reference the policy it implements via `policy_id`.

---

## 5. Security Control Metadata Schema

Every security control artifact MUST begin with a YAML frontmatter block. This block is the primary entry point for AI/LLM parsing.

### 5.1 Required fields

```yaml
---
control_id: auth-rls-user-profiles
name: Row-Level Security on user_profiles table
domain: db
type: security-control
component_id: webapp                   # AFADS component_id
policy_id: authorization               # AFSS policy this implements
criticality: critical                  # low | medium | high | critical
status: implemented                    # proposed | implemented | verified | deprecated
threats_mitigated:
  - unauthorized-data-access
  - privilege-escalation
owner: platform-team
last_reviewed: 2026-02-07
last_verified: 2026-02-01
---
```

### 5.2 Optional fields

```yaml
verification_procedure_id: verify-rls-policies    # AFOPS procedure ID
related_controls: [authz-supabase-policies]
enforced_by: [supabase-rls, postgres]
compliance_refs: []                                # e.g., ["SOC2-CC6.1", "OWASP-A01"] — see AFCS section 11.3 for canonical ID formats
tags: [rls, postgres, supabase, authorization]
supersedes: auth-rls-user-profiles-v1
adr_link: docs/adrs/0005-rls-strategy.md
defense_layer: data                                # network | application | data | identity
```

### 5.3 Field reference

| Field | Required | Type | Description |
|-------|----------|------|-------------|
| `control_id` | Yes | slug | Stable unique identifier, kebab-case |
| `name` | Yes | string | Human-readable name |
| `domain` | Yes | enum | `auth` / `authz` / `input` / `secrets` / `deps` / `api` / `cors` / `csp` / `db` / `infra` / `network` |
| `type` | Yes | literal | Always `security-control` |
| `component_id` | Yes | slug | AFADS component_id, or `system` for cross-component |
| `policy_id` | Yes | slug | AFSS policy this control implements |
| `criticality` | Yes | enum | `low` / `medium` / `high` / `critical` |
| `status` | Yes | enum | `proposed` / `implemented` / `verified` / `deprecated` |
| `threats_mitigated` | Yes | list | Threat IDs from the threat model |
| `owner` | Yes | string | Team responsible |
| `last_reviewed` | Yes | date | ISO date of last review |
| `last_verified` | Yes | date | ISO date of last verification (test or audit) |
| `verification_procedure_id` | No | slug | AFOPS procedure ID for verifying this control |
| `related_controls` | No | list | Other control IDs that work together with this one |
| `enforced_by` | No | list | Tooling or infrastructure that enforces this control |
| `compliance_refs` | No | list | Compliance framework references (SOC 2, OWASP, etc.) |
| `tags` | No | list | Searchable tags |
| `supersedes` | No | slug | Control ID this replaces |
| `adr_link` | No | path | ADR justifying this control |
| `defense_layer` | No | enum | `network` / `application` / `data` / `identity` |

---

## 6. Security Policy Metadata Schema

Security policies are system-wide. They have a simpler schema than controls.

### 6.1 Required fields

```yaml
---
policy_id: authentication
name: Authentication Policy
type: security-policy
scope: system
status: active                         # active | draft | deprecated
owner: platform-team
last_reviewed: 2026-02-07
---
```

### 6.2 Optional fields

```yaml
compliance_refs: ["SOC2-CC6.1"]
tags: [auth, supabase, jwt]
supersedes: authentication-v1
```

### 6.3 Field reference

| Field | Required | Type | Description |
|-------|----------|------|-------------|
| `policy_id` | Yes | slug | Stable unique identifier, kebab-case |
| `name` | Yes | string | Human-readable name |
| `type` | Yes | literal | Always `security-policy` |
| `scope` | Yes | string | `system` or a list of component_ids |
| `status` | Yes | enum | `active` / `draft` / `deprecated` |
| `owner` | Yes | string | Team responsible |
| `last_reviewed` | Yes | date | ISO date of last review |
| `compliance_refs` | No | list | Compliance framework references |
| `tags` | No | list | Searchable tags |
| `supersedes` | No | slug | Policy ID this replaces |

---

## 7. Security Control Body Structure

After the metadata block, every security control MUST include these sections in order:

```
## Description
## Threat Context
## Implementation
## Verification
## Failure Mode
## AI Guidance
```

### 7.1 Description

One to three sentences describing what this control does and what it protects.

### 7.2 Threat Context

Which threats this control mitigates, with references to the threat model. A brief explanation of the attack scenario this control defends against.

### 7.3 Implementation

How the control is implemented. Includes code snippets, configuration blocks, SQL statements, or infrastructure definitions. Must be specific enough that someone (or an AI) can verify the control is correctly implemented.

### 7.4 Verification

How to verify the control is working. Includes:
- Automated tests (with code)
- Manual verification steps
- Reference to an AFOPS verification procedure if one exists

Each verification step MUST include the command or action, the expected result, and what to do if verification fails.

### 7.5 Failure Mode

What happens if this control fails or is misconfigured:
- Blast radius (what is exposed)
- Detection method (how the failure is discovered)
- Compensating controls (what other layers of defense remain)

### 7.6 AI Guidance

Instructions for AI agents on how to maintain this control when generating or modifying code. What the AI must do and what it must never do.

---

## 8. Security Policy Body Structure

After the metadata block, every security policy MUST include these sections in order:

```
## Purpose
## Scope
## Policy Statement
## Requirements
## Controls Inventory
## Exceptions
## Review Schedule
```

### 8.1 Purpose

Why this policy exists and what risk it addresses at the system level.

### 8.2 Scope

Which components, environments, and teams this policy applies to.

### 8.3 Policy Statement

The policy itself, in clear declarative statements using RFC 2119 language (MUST, SHOULD, MAY).

### 8.4 Requirements

A numbered list of specific requirements that components must satisfy to comply with this policy.

### 8.5 Controls Inventory

Table of all controls that implement this policy, with `control_id`, `component_id`, and `status`. This is the traceability link from policy to controls.

### 8.6 Exceptions

Documented exceptions with justification and compensating controls. If there are no exceptions, state "No exceptions."

### 8.7 Review Schedule

How often this policy is reviewed and by whom.

---

## 9. Threat Model Specification

### 9.1 System-level threat model

The docs hub MUST contain a system-level threat model. STRIDE is the recommended methodology but not mandated.

### 9.2 Threat model structure

The system-level threat model MUST include:

```
## System Overview
## Assets
## Threat Actors
## Trust Boundaries
## Threats
## Risk Assessment
## Control Mapping
```

### 9.3 Threat ID format

Each threat MUST have a stable ID:

```
threat-<category>-<description>
```

Examples:
- `threat-spoofing-jwt-forgery`
- `threat-tampering-sql-injection`
- `threat-disclosure-user-data-leak`
- `threat-elevation-privilege-escalation`
- `threat-dos-api-flood`

### 9.4 Threat-to-control mapping

The threat model MUST include a mapping table:

| Threat ID | Threat | Controls | Coverage |
|-----------|--------|----------|----------|
| threat-disclosure-user-data-leak | Unauthorized access to user data | auth-rls-user-profiles, authz-supabase-policies | full |
| threat-tampering-sql-injection | SQL injection via user input | input-validation-api, db-parameterized-queries | full |
| threat-spoofing-jwt-forgery | Forged or expired JWT accepted | auth-jwt-validation, auth-session-middleware | full |
| threat-dos-api-flood | API overwhelmed by request volume | api-rate-limiting | partial |

Coverage values: `full` (all known attack vectors covered), `partial` (some vectors covered, accepted risk documented), `planned` (controls not yet implemented).

### 9.5 Component-level threat models

Components with complex security requirements MAY have their own threat model (`docs/security/threat-model.md`) that extends the system model. Component threat models reference the system model and add component-specific threats.

---

## 10. Security Review Process

### 10.1 Review types

| Type | Trigger | Scope | Output |
|------|---------|-------|--------|
| `periodic` | Scheduled (quarterly) | Full system | Security review record |
| `change-driven` | New component, major refactor | Affected components | Updated controls |
| `incident-driven` | Security incident | Affected components | Incident ADR + updated controls |
| `dependency` | Vulnerability alert | Affected dependencies | Patch procedure (AFOPS) |

### 10.2 Security review checklist

Every review MUST use a standard checklist organized by domain:

```markdown
## Authentication
- [ ] All endpoints require authentication (unless explicitly public)
- [ ] JWT validation is server-side, not client-side
- [ ] Token expiry is configured and enforced
- [ ] Refresh token rotation is enabled

## Authorization
- [ ] RLS is enabled on all tables with user data
- [ ] RLS policies are tested with multiple user roles
- [ ] API routes verify user permissions before data access
- [ ] No use of service role key in client-accessible code

## Input Validation
- [ ] All user input is validated server-side
- [ ] File uploads are type-checked and size-limited
- [ ] SQL queries use parameterized statements (Supabase client handles this)
- [ ] Form actions validate with schema (e.g., Zod) before processing

## Secrets
- [ ] No secrets in source code or environment files committed to git
- [ ] Secrets are managed through environment configuration or vault
- [ ] Service role key is never exposed to the client
- [ ] API keys are scoped to minimum required permissions

## Dependencies
- [ ] No known critical vulnerabilities in dependencies
- [ ] Dependency audit passes (e.g., `npm audit`)
- [ ] No dependencies with problematic licenses

## Headers / CORS / CSP
- [ ] CORS is restricted to known origins
- [ ] CSP is configured and blocks inline scripts (or uses nonces)
- [ ] Security headers are set (X-Frame-Options, X-Content-Type-Options, etc.)
- [ ] HTTPS is enforced on all endpoints
```

### 10.3 Security review records

Each review produces a record stored in `docs/security/reviews/`. The record MUST include:
- Date and reviewer
- Scope (which components were reviewed)
- Findings (issues discovered, with severity)
- Remediation actions (with deadlines and owners)
- Links to resulting control changes or ADRs

---

## 11. Security Domains

This section provides domain-specific guidance. Each subsection corresponds to a `domain` enum value from the control metadata.

### 11.1 Authentication (`auth`)

Covers: authentication provider configuration (e.g., Supabase Auth), JWT handling, session management, multi-factor authentication, OAuth providers.

Key controls to document:
- Token validation (server-side JWT verification)
- Session expiry and refresh token handling
- Auth middleware/hooks that protect routes
- OAuth provider configuration

### 11.2 Authorization (`authz`)

Covers: row-level security, role-based access control, permission models, API authorization.

Key controls to document:
- RLS policies per table
- Role definitions and permission mappings
- Server-side permission checks in routes and API endpoints
- Service role key usage restrictions

### 11.3 Input Validation (`input`)

Covers: server-side validation, schema validation (e.g., Zod), file upload validation, output encoding/sanitization.

Key controls to document:
- Validation schemas on all form actions and API endpoints
- File upload type and size restrictions
- HTML output encoding to prevent XSS

### 11.4 Secrets Management (`secrets`)

Covers: environment variables, vault/secret store, secret rotation, key management.

Key controls to document:
- Where secrets are stored (never in code)
- Rotation procedures (cross-reference AFOPS)
- Access controls on secrets
- Client vs server secret separation

### 11.5 Dependency Security (`deps`)

Covers: vulnerability scanning, automated updates, license compliance, supply chain security.

Key controls to document:
- Automated vulnerability scanning (npm audit, Dependabot/Renovate)
- Update and patching policy (cross-reference AFPS dependency convention)
- Lock file integrity

### 11.6 API Security (`api`)

Covers: rate limiting, request size limits, API versioning security, webhook validation.

Key controls to document:
- Rate limiting configuration and thresholds
- Request body size limits
- Webhook signature validation

### 11.7 CORS (`cors`)

Covers: cross-origin resource sharing configuration.

Key controls to document:
- Allowed origins list
- Credential handling (whether cookies are sent cross-origin)
- Preflight caching

### 11.8 Content Security Policy (`csp`)

Covers: CSP headers, script loading policy, reporting.

Key controls to document:
- CSP header configuration (e.g., in SvelteKit hooks)
- Nonce-based or hash-based script allowlisting
- CSP reporting endpoint

### 11.9 Database Security (`db`)

Covers: RLS, connection security, migration safety, backup encryption.

Key controls to document:
- RLS enabled on every table with user data
- SSL/TLS for database connections
- Migration review process (no destructive migrations without approval)
- Backup encryption

### 11.10 Infrastructure (`infra`)

Covers: server/container hardening, deployment pipeline security, runtime security.

Key controls to document:
- Minimal container images, non-root execution
- Signed deployments and image scanning
- Resource limits and isolation

### 11.11 Network Security (`network`)

Covers: network policies, ingress configuration, TLS, DNS security.

Key controls to document:
- Namespace isolation (Kubernetes network policies)
- TLS on all external and internal endpoints
- Ingress rules and IP restrictions

---

## 12. Security Control Registry

The docs hub repo MUST contain a security control registry and a policy registry, analogous to the AFADS component registry and AFOPS procedure registry.

### 12.1 Control registry file location

```
docs/security/controls.yaml
```

### 12.2 Control registry schema

```yaml
controls:
  - control_id: auth-rls-user-profiles
    name: Row-Level Security on user_profiles
    domain: db
    component_id: webapp
    policy_id: authorization
    criticality: critical
    status: verified
    repo: github.com/<org>/webapp
    ref: main
    path: docs/security/controls/auth-rls-user-profiles.md

  - control_id: input-validation-api-routes
    name: Zod Validation on All API Routes
    domain: input
    component_id: webapp
    policy_id: input-validation
    criticality: high
    status: implemented
    repo: github.com/<org>/webapp
    ref: main
    path: docs/security/controls/input-validation-api-routes.md

  - control_id: csp-script-nonce
    name: CSP Nonce-Based Script Loading
    domain: csp
    component_id: webapp
    policy_id: browser-security
    criticality: high
    status: implemented
    repo: github.com/<org>/webapp
    ref: main
    path: docs/security/controls/csp-script-nonce.md
```

### 12.3 Policy registry file location

```
docs/security/policies.yaml
```

### 12.4 Policy registry schema

```yaml
policies:
  - policy_id: authentication
    name: Authentication Policy
    status: active
    path: docs/security/policies/authentication.md
    controls_count: 5

  - policy_id: authorization
    name: Authorization Policy
    status: active
    path: docs/security/policies/authorization.md
    controls_count: 8

  - policy_id: input-validation
    name: Input Validation Policy
    status: active
    path: docs/security/policies/input-validation.md
    controls_count: 4
```

### 12.5 Registry rules

- `control_id` MUST match the ID in the control's metadata block.
- `component_id` MUST match an AFADS `component_id`, or be `system` for cross-component controls.
- `policy_id` MUST match an AFSS policy.
- `threats_mitigated` IDs in control metadata MUST match threat IDs in the threat model.
- The registries SHOULD be validated in CI (e.g., check that referenced files exist and contain valid metadata).

---

## 13. AI/LLM Integration Model

This section defines how AI agents should interact with AFSS security controls when generating, modifying, or reviewing code.

### 13.1 Security control discovery

When an AI agent starts a session involving code changes, it MUST:

1. Read `docs/security/controls.yaml` in the current repository (if it exists).
2. Read `docs/security/controls.yaml` in the docs hub to get the system-wide view.
3. Identify which controls apply to the component and code area being modified.
4. Read applicable control documents, focusing on the Implementation and AI Guidance sections.

### 13.2 Code generation with security awareness

When generating code, the AI agent MUST:

1. Check whether any security controls apply to the code being written.
2. For database queries: verify RLS controls and ensure queries go through the Supabase client (not raw SQL that bypasses RLS).
3. For API routes: ensure authentication middleware is applied and input validation is present.
4. For form actions: ensure server-side validation exists.
5. Never hardcode secrets, tokens, or API keys.
6. Never disable or weaken a security control, even if asked. Instead, flag the request to the human.

### 13.3 Security review assistance

When reviewing code, the AI agent MUST:

1. Read all applicable security controls for the component.
2. Check each change against the relevant controls.
3. Reference the specific `control_id` when flagging a potential violation.
4. Classify findings by severity: `critical` (must fix before merge), `high` (should fix before merge), `medium` (consider fixing), `low` (informational).
5. Check for common vulnerability patterns: hardcoded secrets, missing auth checks, missing input validation, SQL injection, XSS, CSRF.

### 13.4 Threat-aware development

When the AI agent is building a new feature:

1. Check if the feature introduces new trust boundaries or data flows.
2. If yes, flag that the threat model may need updating.
3. Identify which existing controls apply to the new feature.
4. Recommend new controls if the feature exposes new attack surfaces.

### 13.5 Security control verification

When asked to verify security controls, the AI agent SHOULD:

1. Read the control's Verification section.
2. Execute automated verification tests if they exist.
3. Walk through manual verification steps.
4. Report the result with the `control_id`, verification date, and outcome.

### 13.6 Absolute rules for AI agents

The AI agent MUST NEVER:

- Disable row-level security on a table, even temporarily
- Expose service role keys or secret keys to client-side code
- Remove authentication middleware from a protected route
- Bypass input validation
- Commit secrets to version control
- Weaken CORS or CSP configurations
- Use `SELECT *` in queries that may return data the current user should not see
- Create database queries that bypass the standard client (and thus bypass RLS)

If the human explicitly requests any of these actions, the AI MUST refuse and explain why. The AI may suggest a safe alternative that achieves the intended goal without weakening security.

---

## 14. Lifecycle and Review

### 14.1 Review triggers

A security control MUST be reviewed when:

| Trigger | Review deadline |
|---------|----------------|
| 90 days since last review | within 2 weeks |
| Security incident affecting component | within 3 business days |
| New dependency vulnerability (critical/high) | within 24 hours |
| Component architecture changed | before next deployment |
| New threat identified in threat model | within 1 week |
| Compliance audit scheduled | 2 weeks before audit |

### 14.2 Control verification schedule

Controls MUST be verified (not just reviewed) on a schedule based on criticality:

| Criticality | Verification frequency |
|-------------|----------------------|
| `critical` | Monthly |
| `high` | Quarterly |
| `medium` | Semi-annually |
| `low` | Annually |

### 14.3 Review process

1. Create a PR with proposed changes.
2. The PR description MUST explain what changed and why.
3. The control owner MUST approve the PR.
4. After merge, update `last_reviewed` in the control metadata.
5. If verification was performed, update `last_verified`.

### 14.4 Deprecation

To deprecate a security control:
1. Set `status: deprecated` in the metadata.
2. Add a `supersedes` field pointing to the replacement control.
3. Do not delete the file until all references to it have been updated.
4. Verify that the replacement control provides equivalent or better protection.

---

## 15. Definition of Done

A security control is considered **compliant** when:

- [ ] Metadata block contains all required fields (section 5.1)
- [ ] All required body sections are present (section 7)
- [ ] Control references at least one threat from the threat model (section 5.1, `threats_mitigated`)
- [ ] Control references a policy via `policy_id` (section 5.1)
- [ ] Verification section includes at least one automated or manual check (section 7.4)
- [ ] Failure Mode section documents blast radius and compensating controls (section 7.5)
- [ ] AI Guidance section is present (section 7.6)
- [ ] Control is registered in `controls.yaml` (section 12)
- [ ] `last_reviewed` date is within 90 days
- [ ] `last_verified` date is within the schedule for its criticality (section 14.2)
- [ ] Control is listed in the component's `docs/security.md` overview (section 4.3)

A system is considered **security-documented** when:

- [ ] System-level threat model exists in the docs hub (section 9)
- [ ] All security policies exist in the docs hub (section 8)
- [ ] Every component has `docs/security.md` (section 4.3)
- [ ] Every component has `docs/security/controls.yaml` (section 4.1)
- [ ] The system-level `controls.yaml` indexes all component controls (section 12)
- [ ] Every threat in the threat model maps to at least one control (section 9.4)
- [ ] All controls with `coverage: partial` have documented accepted risk

---

## 16. Relationship to AFADS, AFOPS, and AFPS

### 16.1 What AFSS extends

| Standard | Section | AFSS Relationship |
|----------|---------|-------------------|
| AFADS | Section 5.6 (`05-security.md`) | AFSS provides the detailed control framework. `05-security.md` becomes a summary that references AFSS policies and links to `controls.yaml` |
| AFADS | Section 4.2 (`component.md`) body section 8 (Known risks) | Component risks should reference AFSS threat IDs and control IDs |
| AFADS | Section 5.2 (`01-context.md`) trust boundaries | Trust boundaries in the context diagram must align with the AFSS threat model trust boundaries |
| AFOPS | Procedures of type `patch` and `maintenance` | Security patching and rotation procedures are AFOPS procedures. AFSS controls reference them via `verification_procedure_id` |
| AFPS | Conventions of type `pattern` | Code-level security patterns (input validation, auth middleware) are AFPS patterns that implement AFSS controls |
| AFCS | Compliance mappings, checklists, risk assessments | AFCS maps external compliance frameworks (OWASP, NIS2, etc.) to AFSS controls and policies using `control_id` and `policy_id` |

### 16.2 What AFSS does not replace

- AFADS component documentation — `component.md` remains unchanged
- AFOPS procedures — AFSS defines what must be secured; AFOPS defines how to execute security operations
- AFPS conventions — AFSS defines security requirements; AFPS defines the code patterns that satisfy them
- AFADS ADRs — decisions about security controls should still be recorded as ADRs

### 16.3 Cross-references

- Control metadata `component_id` MUST match an AFADS `component_id`.
- Control metadata `verification_procedure_id` MUST match an AFOPS `procedure_id`.
- Security domains that have code-level patterns SHOULD have corresponding AFPS patterns with `related_controls` in the AFPS pattern metadata.
- The AFADS `05-security.md` MUST reference AFSS system-level policies by `policy_id`.
- The AFPS `dependency` convention's security auditing section MUST reference AFSS controls for vulnerability management.

---

## 17. Appendix A: Example Security Control

```markdown
---
control_id: auth-rls-user-profiles
name: Row-Level Security on user_profiles Table
domain: db
type: security-control
component_id: webapp
policy_id: authorization
criticality: critical
status: verified
threats_mitigated:
  - threat-disclosure-user-data-leak
  - threat-elevation-privilege-escalation
owner: platform-team
last_reviewed: 2026-02-07
last_verified: 2026-02-01
verification_procedure_id: verify-rls-policies
related_controls: [authz-supabase-policies, auth-jwt-validation]
enforced_by: [supabase-rls, postgres]
defense_layer: data
adr_link: docs/adrs/0005-rls-strategy.md
---

## Description

Row-Level Security (RLS) is enabled on the `user_profiles` table in
Supabase Postgres. Users can only read and update their own profile.
Service role access bypasses RLS for administrative operations only.

## Threat Context

**Threat: threat-disclosure-user-data-leak** — Without RLS, any
authenticated user could query another user's profile data through the
Supabase client. The Supabase JS client connects with the `anon` key
by default, which means RLS is the primary data access boundary.

**Threat: threat-elevation-privilege-escalation** — Without RLS, a user
could modify another user's profile (e.g., changing roles or permissions
stored in the profile).

## Implementation

RLS policies on `user_profiles`:

```sql
-- Enable RLS
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;

-- Users can read their own profile
CREATE POLICY "Users can read own profile"
  ON public.user_profiles
  FOR SELECT
  USING (auth.uid() = id);

-- Users can update their own profile (except role)
CREATE POLICY "Users can update own profile"
  ON public.user_profiles
  FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- No direct insert — profiles are created by a trigger on auth.users
-- No direct delete — profiles are soft-deleted via status column
```

These policies are defined in the Supabase migration:
`supabase/migrations/20260115_rls_user_profiles.sql`

## Verification

### Automated test

```typescript
// tests/security/rls-user-profiles.test.ts
import { describe, it, expect } from 'vitest';
import { createClient } from '@supabase/supabase-js';

describe('RLS: user_profiles', () => {
  it('user cannot read another user profile', async () => {
    const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
    // Sign in as user A
    await supabase.auth.signInWithPassword({
      email: 'user-a@test.com',
      password: 'test',
    });
    // Try to read user B's profile
    const { data, error } = await supabase
      .from('user_profiles')
      .select('*')
      .eq('id', USER_B_ID)
      .single();
    expect(data).toBeNull();
  });

  it('user can read own profile', async () => {
    const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
    await supabase.auth.signInWithPassword({
      email: 'user-a@test.com',
      password: 'test',
    });
    const { data } = await supabase
      .from('user_profiles')
      .select('*')
      .eq('id', USER_A_ID)
      .single();
    expect(data).not.toBeNull();
    expect(data.id).toBe(USER_A_ID);
  });
});
```

### Manual verification

1. Sign in as a non-admin user via the Supabase dashboard SQL editor.
2. Run: `SELECT * FROM user_profiles;`
   **Expected:** Only the signed-in user's row is returned.
3. Run: `UPDATE user_profiles SET display_name = 'hacked' WHERE id != auth.uid();`
   **Expected:** 0 rows affected.

### AFOPS procedure

Verification procedure: `verify-rls-policies` (runs monthly, confirms
all RLS policies are active and tests pass).

## Failure Mode

If RLS is disabled on this table:
- **Blast radius:** All user profile data is readable and writable by
  any authenticated user via the Supabase JS client.
- **Detection:** The `verify-rls-policies` procedure catches this within
  its scheduled run. Additionally, the Supabase dashboard shows RLS status
  per table.
- **Compensating control:** API routes that query user_profiles server-side
  (using the service role) already filter by user ID. But client-side
  queries through the Supabase JS client would be unprotected.

## AI Guidance

When generating code that interacts with the `user_profiles` table:
1. Always use the Supabase client (which respects RLS). Never use a raw
   Postgres connection for user-facing queries.
2. Never disable RLS on this table, even in migrations. If a migration
   needs to modify all rows, use the service role connection in the
   migration script.
3. If adding a new column to `user_profiles`, verify that existing RLS
   policies still cover the new column (they do by default for SELECT/UPDATE,
   but WITH CHECK constraints may need updating).
4. Never create a policy with `USING (true)` on this table.
```

---

## 18. Appendix B: Example Security Policy

```markdown
---
policy_id: authentication
name: Authentication Policy
type: security-policy
scope: system
status: active
owner: platform-team
last_reviewed: 2026-02-07
tags: [auth, supabase, jwt]
---

## Purpose

Defines how users and services authenticate to the system. All access
to protected resources must go through a verified authentication flow.

## Scope

Applies to all components that handle user sessions or service-to-service
communication. Applies to all environments (dev, staging, prod).

## Policy Statement

1. All user authentication MUST use Supabase Auth.
2. All protected routes MUST validate the JWT server-side.
3. JWTs MUST have a maximum expiry of 1 hour.
4. Refresh tokens MUST have a maximum expiry of 7 days.
5. Service-to-service calls MUST use the Supabase service role key,
   never the anon key.
6. The service role key MUST never be exposed to client-side code.
7. Multi-factor authentication SHOULD be available for all users.
8. OAuth providers MUST be configured in the Supabase dashboard, not
   hardcoded in application code.

## Requirements

1. Every SvelteKit `+page.server.ts` and `+server.ts` that accesses
   user data MUST verify the session via `locals.getSession()`.
2. The auth hook (`src/hooks.server.ts`) MUST validate the JWT on
   every request.
3. Password requirements: minimum 8 characters, no maximum length
   restriction.
4. Failed login attempts MUST be rate-limited.

## Controls Inventory

| Control ID | Component | Status |
|------------|-----------|--------|
| auth-jwt-validation | webapp | verified |
| auth-session-middleware | webapp | verified |
| auth-supabase-config | supabase-auth | verified |
| auth-oauth-providers | supabase-auth | implemented |

## Exceptions

- Public marketing pages (`/(marketing)/*`) do not require authentication.
  These routes MUST NOT access user data.
- Webhook endpoints MUST use HMAC signature validation instead of JWT
  authentication.
- Health check endpoints (`/health`, `/ready`) are public.

## Review Schedule

Quarterly review by platform-team. Next review: 2026-05-01.
```

---

## 19. Summary

This standard provides:
- a **security control framework** where every control has a stable ID, maps to threats, and is verifiable
- a **policy-to-control traceability** model that connects system-wide policies to specific implementations per component
- a **threat model integration** that drives control selection and justification
- a **security review process** with checklists, schedules, and review records
- a **security control registry** for discoverability across the system
- an **AI integration model** that tells AI agents how to discover, respect, and verify security controls when generating or reviewing code
- **absolute rules** that AI agents must never violate, even when instructed
- a clear **relationship to AFADS, AFOPS, and AFPS** so all four standards work together
