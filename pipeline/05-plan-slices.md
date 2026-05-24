# Stage 05 — Plan Vertical Slices

**Run by:** `Slice-Planner` subagent (fresh context)
**Reads:** `specs/[feature]/design.md`, `specs/[feature]/eval-spec.md`, `tech-stack.md`, `specs/constitution.md`
**Produces:** `specs/[feature]/slice-plan.md`

## Purpose

Break the designed feature into **vertical slices**. A slice is a thin end-to-end piece of user-visible behavior: data model + backend + API + UI + test. A slice must be independently verifiable by automated tests (unit / integration / API). End-to-end browser verification runs **once at end-of-feature** (see `pipeline/08-review.md`), not per slice.

**Slice-Planner does NOT break slices into sub-tasks yet.** That happens just-in-time in stage 06/07, one slice ahead. This is deliberate — we don't want a stale task tree for slice 5 when slice 1 teaches us something new.

## What the Slice-Planner produces

Use `templates/slice-plan.md`. The file contains:

1. **Slice list** — ordered, 3 to 8 slices typical. Each slice has:
   - ID (`S01`, `S02`, ...)
   - Title (verb-phrase: "User can sign up and log in", not "Auth module")
   - User-visible outcome (1 sentence — what can a user do after this lands that they couldn't before?)
   - Acceptance evaluator (which `eval-spec.md` criterion this slice satisfies, referenced by ID)
   - Rough size (S / M / L — no hours or story points, just relative)
   - Dependencies (which earlier slices must land first — usually just `S(N-1)`)
2. **Slice ordering rationale** — 1 paragraph per ordering decision. Why is S01 first? Why not S03?
3. **Known risks** — slices you are least confident about, and why. These get the most careful step-research later.

## Rules for this stage

- **Every slice ships user-visible value.** "Set up database schema" is NOT a slice. "User can create an account and see their name" is a slice (which happens to include schema work).
- **No backend-first layering.** If you find yourself writing "S01: build all models, S02: build all APIs, S03: build all UI", you are wrong. Restart.
- **Prefer smaller earlier slices.** S01 should be the smallest slice that ships real behavior. Build momentum, reveal unknowns early.
- **Defer sub-tasks.** Do not expand any slice into a task list. Stages 06 and 07 handle that per-slice, just-in-time.
- **Cap at 8 slices per planning pass.** If the feature needs more, split it into sub-features with their own stage-04 runs, or mark slices beyond 8 as "_planned, awaits re-plan after S04 lands_".
- **Use the eval-spec.** Every slice must satisfy at least one eval-spec criterion. If a slice satisfies none, either it's unnecessary or the eval-spec is incomplete.

## When this stage re-runs

Slice-Planner re-runs (not first time) after each slice lands, when the Handoff-Writer's output reveals the remaining plan needs revision. Second-and-later runs take the previous `slice-plan.md` plus the latest handoff as input, and produce a revised plan. Version the file: `slice-plan.md` (current), `slice-plan.v1.md` (before S01 landed), etc.

## Orchestrator dispatch prompt (copy verbatim)

> You are the Slice-Planner subagent. Fresh context. Read: `specs/[feature]/design.md`, `specs/[feature]/eval-spec.md`, `tech-stack.md`, `specs/constitution.md`. If `specs/[feature]/slice-plan.md` already exists, also read it and the latest `specs/[feature]/slices/[N]/handoff.md`.
>
> Your job: produce `specs/[feature]/slice-plan.md` using the skeleton in `templates/slice-plan.md`. Do NOT break slices into sub-tasks. Do NOT pick files or code locations. Do NOT read `specs/research/domain.md` or `best-practices.md` — they are not relevant to slice planning.
>
> Verify every slice satisfies at least one eval-spec criterion by ID. If any eval-spec criterion is not covered by any slice, flag it explicitly.
>
> When done, output the file path and the slice list. Stop.

## Stop condition

`specs/[feature]/slice-plan.md` exists with 3–8 slices, each mapped to at least one eval-spec criterion, and dependencies declared. The user has approved the slice plan with an explicit "Go" (same gate format as stage 03).
