---
name: write-handoff
description: Use after `review` returns all-pass to write `specs/[feature]/slices/[N]/handoff.md`. Invokes the Handoff-Writer subagent — NOT the Coder that wrote the slice (avoids self-assessment bias). Grounded in diff + commits + tests + review.md, not chat narration. Orchestrator auto-advances after this file is committed.
allowed-tools: Read, Grep, Glob, Write
---

# write-handoff — Stage 09

## When to trigger
- `specs/[feature]/slices/[N]/review.md` exists with both reviewer verdicts `pass` or `pass-with-notes`.
- `specs/[feature]/slices/[N]/handoff.md` does NOT yet exist.

## Do not trigger
- If review is still open or returned a `block`.
- If the handoff already exists — do not rewrite without explicit user request.

## Produces
`specs/[feature]/slices/[N]/handoff.md` (target 300–500 words, hard cap 600).

## Rules
- Handoff-Writer is NOT the Coder who wrote the slice.
- Ground every claim in an artifact: diff, commit, test output, `review.md`. No chat narration input.
- No flattery ("clean implementation", "solid work" — banned). Describe what's there, not its quality.
- Forward-looking, not backward-looking. Drop context that only mattered inside this slice.
- Cap at 500 words. If longer, cut historical context and re-statement of the step-spec.
- Do NOT read `knowledge.md`, prior slices' handoffs, or `best-practices.md`.

## Required sections (from `templates/handoff.md`)
1. What shipped (references eval-spec criteria by ID).
2. Names the next slice depends on (modules, signatures, env vars, DB columns, API routes).
3. Decisions that affect downstream (3–7 bullets, each traceable to a commit).
4. Known gotchas.
5. Reviewer notes carried forward (from `review.md`).
6. What is NOT done (explicit out-of-scope).
7. Test / eval state (green / red / untested by ID).

## Dispatch the Handoff-Writer subagent (verbatim)

> You are the Handoff-Writer subagent for slice `[ID]`. Fresh context, read-only except for the one output file. Read: `specs/[feature]/slices/[N]/step-spec.md`, `specs/[feature]/slices/[N]/review.md`, the git diff for commits `[SHAs]`, the commit messages, the test output from the last run (attached), and `specs/[feature]/eval-spec.md`.
>
> Do NOT read: `knowledge.md`, prior slices' handoff files, `best-practices.md`, or any Coder chat output.
>
> Produce `specs/[feature]/slices/[N]/handoff.md` per the structure in `pipeline/09-write-handoff.md`. Target 300–500 words. Every claim traceable to a cited artifact. No flattery, no narration, forward-looking.
>
> When done, output the file path and the list of eval-spec criteria IDs marked green vs still red. Stop.

## Stop condition
`handoff.md` exists (word count 200–600), is committed, and has all 7 sections. **The orchestrator then auto-advances** — drift check → stage 06 for the next slice, or stage 10 if this was the final slice.
