---
name: requirements-design
description: Use after the user types "Go" on a clarify doc to produce `requirements.md`, `design.md`, and `eval-spec.md` for a single feature. Invokes the Architect subagent. Runs once per feature. Blocks stage 05 until all three files exist.
allowed-tools: Read, Grep, Glob, Write
---

# requirements-design — Stage 04

## When to trigger
- `specs/clarify-[feature].md` exists with a "Go" from the user.
- `specs/[feature]/requirements.md` / `design.md` / `eval-spec.md` do NOT yet exist.

## Do not trigger
- If clarify is missing or the user has not said "Go".
- For multiple features at once — run once per feature.

## Produces
`specs/[feature]/requirements.md`, `specs/[feature]/design.md`, `specs/[feature]/eval-spec.md`. Also updates root `tech-stack.md` if it was `_TBD_` from stage 02.

## Rules
- Respect clarify answers literally. If user chose B, design for B.
- Respect constitution non-negotiables. If a choice would violate one, stop and raise it.
- One feature at a time.
- Reject designing capabilities not covered by clarify — surface as a gap.
- The eval-spec MUST be written before Slice-Planner runs. Evaluator types: `unit test`, `integration test`, `browser verifier` (end-of-feature only), `manual user approval`.
- Every test-evaluated criterion gets a **named test signature** in the `Test name` column (one line, no code — e.g., `test_upload_rejects_files_over_10mb`). Architect names tests; the Coder writes them in Stage 07. The Code-Reviewer verifies each named test exists in the diff.

## Dispatch the Architect subagent (verbatim)

> You are the Architect subagent. Fresh context window. Read in this order: `specs/constitution.md`, `specs/research/domain.md`, `specs/clarify-[feature].md`, `tech-stack.md` (if filled and not `_TBD_`).
>
> Produce three files under `specs/[feature]/` — `requirements.md`, `design.md`, `eval-spec.md` — using the skeletons in `templates/`. You may also update `tech-stack.md` in the project root if stage 02 deferred it. You may NOT propose slices or write application code.
>
> In `eval-spec.md`, every criterion whose evaluator is `unit test` or `integration test` must include a one-line **named test signature** in the `Test name` column (e.g., `test_upload_rejects_files_over_10mb`). Name tests only — never create test files, fixtures, or skeleton code. The Coder writes the test bodies in Stage 07.
>
> When done, output the three file paths and a 3-bullet summary of key design decisions. Stop.

## Stop condition
All three files exist under `specs/[feature]/`, are committed, and every template section is filled or explicitly marked as a gap. `tech-stack.md` is no longer `_TBD_`.
