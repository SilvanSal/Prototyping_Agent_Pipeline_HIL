# Requirements: [Feature Name]

_Feature ID: [feature-slug] · Created: [YYYY-MM-DD] · Clarify doc: `specs/clarify-[feature].md`_

## Summary

[1–3 sentences. What the feature does, who it's for.]

## User stories

Each story has: role, capability, outcome, acceptance criteria. Stories are numbered for reference by `eval-spec.md` and `slice-plan.md`.

### US-01: [Short title]

**As a** [role]
**I want** [capability]
**So that** [outcome]

**Acceptance criteria:**
- [ ] [Testable criterion — no vague words like "fast" without a number]
- [ ] [Testable criterion]
- [ ] [Testable criterion]

### US-02: [Short title]

**As a** [role]
**I want** [capability]
**So that** [outcome]

**Acceptance criteria:**
- [ ] [Testable criterion]
- [ ] [Testable criterion]

## Non-functional requirements

- **Performance:** [e.g., P95 page load < 1s on 3G]
- **Accessibility:** [e.g., WCAG 2.1 AA for all user-facing surfaces]
- **i18n:** [e.g., English only in v1; string extraction pattern in place]
- **Security:** [e.g., all endpoints require auth except /health and /login]

## Explicit non-requirements

- [What this feature does NOT do]
- [What this feature does NOT do]

## Links

- Constitution: `specs/constitution.md`
- Clarify: `specs/clarify-[feature].md`
- Design: `specs/[feature]/design.md`
- Eval spec: `specs/[feature]/eval-spec.md`
