# Phase Plan: [Feature Name]

_Feature ID: [feature-slug] · Created: [YYYY-MM-DD]_

> **Phases are user-visible milestones**, each independently shippable. Slices are implementation chunks within a phase.
> The user approves this plan and selects which phase to build before slice planning begins.

## Selected phase

- **Active phase ID:** [P1 / P2 / ...]
- **Selected by:** [user]
- **Date selected:** [YYYY-MM-DD]

## Phases

### P1: [Phase name — user-visible milestone]

- **User outcome:** [1 sentence — what a user/stakeholder can verify shipped]
- **Requirements satisfied:** [REQ-XX, REQ-YY — IDs from requirements.md]
- **Acceptance criteria:** [How to verify this phase shipped — observable behavior, not code]
- **Estimated slice count:** S (1–2) / M (3–5) / L (6–8)
- **Dependencies:** none (this is the MVP)

### P2: [Phase name]

- **User outcome:**
- **Requirements satisfied:**
- **Acceptance criteria:**
- **Estimated slice count:** S / M / L
- **Dependencies:** P1

### P3: [Phase name]

- **User outcome:**
- **Requirements satisfied:**
- **Acceptance criteria:**
- **Estimated slice count:** S / M / L
- **Dependencies:** [P1, P2, ...]

## Not in scope for any phase

Requirements explicitly deferred to future work:
- [list, or "none — all requirements covered"]

## Phase ordering rationale

- **Why P1 is the MVP:** [reasoning — smallest thing that delivers core user value]
- **Why P2 after P1:** [what P1 unblocks]

## Links

- Requirements: `specs/[feature]/requirements.md`
- Design: `specs/[feature]/design.md`
- Eval spec: `specs/[feature]/eval-spec.md`
- Slice plan: `specs/[feature]/slice-plan.md`
