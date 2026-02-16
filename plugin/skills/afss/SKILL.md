---
name: afss
description: "AI-Friendly Security Standard. Use when documenting security controls, policies, threat models, or security review processes."
user-invocable: true
---

# AFSS — AI-Friendly Security Standard

Use this skill to document security controls, policies, and threat models so they are traceable, verifiable, and enforceable by both humans and AI agents.

## When to Use

- Documenting security controls for a component
- Writing security policies (authentication, authorization, input validation, etc.)
- Creating threat models using STRIDE or LINDDUN
- Setting up security review processes
- Defining security control registries

## Key Deliverables

```
docs/
  security.md                 ← component security overview (required)
  security/
    controls.yaml             ← control registry (required)
    policies.yaml             ← policy registry (docs hub)
    threat-model.md           ← component or system threat model
    controls/
      auth-rls-user-data.md   ← one file per control
      input-validation-api.md
    policies/
      authentication.md       ← one file per policy (docs hub)
      authorization.md
```

## Security Domains

`auth` | `authz` | `input` | `secrets` | `deps` | `api` | `cors` | `csp` | `db` | `infra` | `network`

## Control Metadata Schema

```yaml
---
control_id: auth-rls-user-profiles
name: Row-Level Security on user_profiles Table
domain: db
type: security-control
component_id: webapp                     # AFADS component_id
policy_id: authorization                 # parent policy
criticality: critical                    # low | medium | high | critical
status: verified                         # proposed | implemented | verified | deprecated
threats_mitigated:
  - threat-disclosure-user-data-leak
  - threat-elevation-privilege-escalation
owner: platform-team
last_reviewed: 2026-02-07
last_verified: 2026-02-01
verification_procedure_id: verify-rls-policies  # AFOPS procedure
related_controls: [authz-supabase-policies]
enforced_by: [supabase-rls, postgres]
defense_layer: data                      # network | application | data | identity
compliance_refs: [OWASP-A01]            # optional: AFCS framework refs
adr_link: docs/adrs/0005-rls-strategy.md
---
```

## Control Body Structure

```markdown
## Description
What this control does and why it exists.

## Threat Context
Which threats this mitigates and how:
- `threat-disclosure-user-data-leak`: RLS prevents users from querying other users' data
- `threat-elevation-privilege-escalation`: Policies enforce role-based access

## Implementation
Code, SQL, or configuration that implements this control:
```sql
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY user_own_data ON user_profiles
  USING (auth.uid() = user_id);
```

## Verification
### Automated
```bash
npm run test:security -- --filter=rls
```
### Manual
1. Log in as user A
2. Attempt to query user B's profile
3. Verify empty result set

## Failure Mode
- **Blast radius:** All user data exposed if RLS disabled
- **Detection:** Automated RLS verification test in CI
- **Compensating controls:** Application-level auth checks

## AI Guidance
- MUST never disable RLS on this table
- MUST verify RLS is enabled after any migration touching this table
- MUST use Supabase client (not raw SQL) to preserve RLS enforcement
```

## Policy Metadata Schema

```yaml
---
policy_id: authorization
name: Authorization Policy
type: security-policy
scope: system
status: active
owner: security-team
last_reviewed: 2026-02-07
controls: [auth-rls-user-profiles, authz-supabase-policies]
---
```

## Policy Body Structure

```markdown
## Purpose
## Scope
## Policy Statement
## Requirements
## Controls Inventory
## Exceptions
## Review Schedule
```

## Threat Model Structure

```markdown
## System Overview
## Assets (what we protect)
## Threat Actors (who might attack)
## Trust Boundaries (where trust changes)
## Threats (STRIDE analysis per boundary)
## Risk Assessment (likelihood x impact)
## Control Mapping (threat → controls)
```

## Control Registry (controls.yaml)

```yaml
controls:
  - control_id: auth-rls-user-profiles
    name: RLS on user_profiles
    domain: db
    component_id: webapp
    policy_id: authorization
    criticality: critical
    status: verified
    path: docs/security/controls/auth-rls-user-profiles.md
    threats_mitigated: [threat-disclosure-user-data-leak]
    defense_layer: data
    last_reviewed: 2026-02-07
```

## Verification Schedule (by criticality)

| Criticality | Frequency |
|-------------|-----------|
| `critical` | Monthly |
| `high` | Quarterly |
| `medium` | Semi-annually |
| `low` | Annually |

## AI Agent Absolute Rules

The AI agent MUST NEVER:
- Disable row-level security, even temporarily
- Expose service role keys to client-side code
- Remove authentication middleware from protected routes
- Bypass input validation
- Commit secrets to version control
- Weaken CORS or CSP configurations
- Create queries that bypass RLS

If asked to do any of these, refuse and explain why. Suggest a safe alternative.

## Core Principles

- **Traceable** — every control maps to threats, policies, and verification steps
- **Defense in depth** — document multiple layers for every asset
- **Threat-driven** — controls are justified by threats; no threat = question the control
- **Verifiable** — every control has automated or manual verification
- **AI-aware** — AI agents must consult controls before generating security-relevant code

## Cross-References

- `component_id` MUST match an AFADS component
- `verification_procedure_id` MUST match an AFOPS procedure
- AFPS patterns may implement AFSS controls
- AFCS maps external frameworks to AFSS controls
- AFRS security roadmap items reference controls to create or improve

## Full Standard

https://github.com/securitymonster/afdocs/blob/main/AFSS.md
