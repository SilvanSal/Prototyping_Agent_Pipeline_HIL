---
name: plan-slices
description: Use after the Architect has produced `requirements.md` / `design.md` / `eval-spec.md` to break a feature into 3–8 vertical slices. Invokes the Slice-Planner subagent. Also re-runs between slices when a handoff reveals the plan needs revision. Blocks stage 06 until user approves with "Go".
allowed-tools: Read, Grep, Glob, Write
---

# plan-slices — Stage 05

## When to trigger
- First time: `specs/[feature]/design.md` + `eval-spec.md` exist, `slice-plan.md` does NOT.
- Re-run: a prior slice's handoff explicitly flags that the remaining plan needs revision.

## Do not trigger
- If `slice-plan.md` exists and the latest handoff did not flag revision.
- If the feature hasn't been designed yet.

## Produces
`specs/[feature]/slice-plan.md`. On re-run, version the previous one (`slice-plan.v1.md`) and write the revised plan as `slice-plan.md`.

## Rules
- Every slice ships user-visible value. "Set up schema" is NOT a slice.
- No backend-first layering. If the plan reads "S01: all models, S02: all APIs, S03: all UI", restart.
- 3–8 slices. Cap at 8; split into sub-features if more.
- Prefer smaller earlier slices (build momentum, reveal unknowns).
- Defer sub-task breakdown to stage 06/07.
- Every slice must satisfy at least one `eval-spec.md` criterion by ID.
- Each slice is independently verifiable by automated tests. Browser verification is end-of-feature only (see stage 08).

## Dispatch the Slice-Planner subagent (verbatim)

> You are the Slice-Planner subagent. Fresh context. Read: `specs/[feature]/design.md`, `specs/[feature]/eval-spec.md`, `tech-stack.md`, `specs/constitution.md`. If `specs/[feature]/slice-plan.md` already exists, also read it and the latest `specs/[feature]/slices/[N]/handoff.md`.
>
> Produce `specs/[feature]/slice-plan.md` using the skeleton in `templates/slice-plan.md`. Do NOT break slices into sub-tasks. Do NOT pick files or code locations. Do NOT read `specs/research/domain.md` or `best-practices.md`.
>
> Verify every slice satisfies at least one eval-spec criterion by ID. Flag uncovered criteria explicitly.
>
> When done, output the file path and the slice list. Stop.

## "Go" gate
After the subagent finishes, present the slice list to the user and ask for explicit "Go" before dispatching stage 06. Same format as stage 03.

## Stop condition
`slice-plan.md` exists with 3–8 slices, each mapped to ≥1 eval-spec criterion, dependencies declared, and the user has typed "Go".
