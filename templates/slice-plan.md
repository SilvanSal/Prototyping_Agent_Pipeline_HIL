# Slice Plan: [Feature Name]

_Feature ID: [feature-slug] · Version: [v1, v2, ...] · Created: [YYYY-MM-DD]_

> **Vertical slices only.** Each slice ships user-visible behavior end-to-end. No "build all models" or "build all APIs" slices.
> **Sub-tasks are NOT in this file.** Stage 06 (Step-Researcher) writes sub-tasks per slice, just-in-time.

## Slices

### S01: [Verb-phrase title — what the user can now do]

- **User-visible outcome:** [1 sentence — concrete user capability after this lands]
- **Eval criteria satisfied:** [E-XX.Y, E-XX.Z — reference eval-spec.md by ID]
- **Size:** S / M / L
- **Dependencies:** [none / S00 / ...]
- **Known risk:** [why this slice might be harder than it looks, or "low"]

### S02: [Verb-phrase title]

- **User-visible outcome:**
- **Eval criteria satisfied:**
- **Size:** S / M / L
- **Dependencies:** [typically S01]
- **Known risk:**

### S03: [Verb-phrase title]

- **User-visible outcome:**
- **Eval criteria satisfied:**
- **Size:** S / M / L
- **Dependencies:**
- **Known risk:**

## Ordering rationale

- **Why S01 first:** [reasoning — usually: smallest slice that ships real behavior, reveals the most unknowns]
- **Why S02 after S01:** [what S01 unblocks for S02]
- **Why S03 after S02:** [...]

## Coverage check

Every criterion in `eval-spec.md` maps to at least one slice. Criteria not covered below are flagged for follow-up.

| Eval criterion ID | Satisfied by slice |
|---|---|
| E-01.1 | S01 |
| E-01.2 | S01 |
| E-02.1 | S02 |
| ... | ... |

Uncovered criteria (must be addressed before feature is considered complete):
- [list, or "none"]

## Risks and unknowns

- **Highest-risk slice:** [ID] — [why]
- **Assumption we're making that could be wrong:** [what, and what we'd do if it turns out wrong]

## Re-plan triggers

This plan will be re-run if any of the following happens after a slice lands:

- A handoff reveals a design assumption was wrong.
- Eval criteria cannot be met by the remaining slices as-planned.
- The user changes a clarify answer.

Versioned copies: `slice-plan.v1.md`, `slice-plan.v2.md` — the current file is always `slice-plan.md`.

## Links

- Requirements: `specs/[feature]/requirements.md`
- Design: `specs/[feature]/design.md`
- Eval spec: `specs/[feature]/eval-spec.md`
- Latest handoff: `specs/[feature]/slices/[N]/handoff.md` (if any)
