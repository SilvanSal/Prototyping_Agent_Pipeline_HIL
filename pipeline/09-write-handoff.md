# Stage 09 — Write Handoff

**Run by:** `Handoff-Writer` subagent (fresh context, read-only + Write for the one output file)
**Reads:** `specs/[feature]/slices/[N]/step-spec.md`, `specs/[feature]/slices/[N]/review.md`, the git diff for this slice's commits, commit messages, test output from the last run, `specs/[feature]/eval-spec.md`
**Does NOT read:** the knowledge.md or the Coder's chat output. The handoff is grounded in artifacts, not narration.
**Produces:** `specs/[feature]/slices/[N]/handoff.md` · appends one line to `specs/[feature]/session-log.md`

## Purpose

Write the one file the next slice's Coder will read *instead of* re-reading this slice's full context. The handoff is the compression that makes fresh-context-per-slice affordable.

**Critical design choice:** the Handoff-Writer is NOT the Coder that wrote the slice. This avoids self-assessment bias. The Handoff-Writer derives its summary from diff + commits + test output + reviewer verdicts — all forgery-resistant artifacts.

## What the Handoff-Writer produces

Use `templates/handoff.md`. Target length: 300–500 words. If it's longer, the next Coder won't read it; if it's shorter, it's underspecified. Contents:

1. **What shipped** — 1 paragraph. User-visible outcome of this slice. What can the user do now that they couldn't before? Reference eval-spec criteria satisfied, by ID.
2. **Names the next slice depends on** — module names, public function signatures, env vars, DB table/column names, API routes. Just the names the next Coder will type. No explanation.
3. **Decisions made that affect downstream** — 3–7 bullets. Choices the Coder made that weren't in the step-spec but constrain future work. Example: "Chose `redis` for session store (constitution allowed choice). All session code goes through `src/sessions/store.ts`." Example: "Deferred password complexity rules to slice S03 per user's 'Go' on simplification."
4. **Known gotchas** — bullets. Things that bit this slice and could bite the next one. Library bugs, environment issues, flaky tests, unfinished edges. Be specific.
5. **Reviewer notes carried forward** — any `pass-with-notes` issues that were not blocking this slice but should influence the next one. By review.md reference.
6. **What is NOT done** — explicit out-of-scope items that were surfaced during this slice. These are candidates for future slices, not current ones.
7. **Test / eval state** — which eval criteria from eval-spec.md are now green (by ID), which are still red, which are untested.

## Rules for this stage

- **Ground every claim in an artifact.** "We chose Redis" → cite the commit. "Password rules deferred" → cite the commit or the review.md note. No claims that can't be traced.
- **No narration.** "I decided to..." is banned. The Coder's chat output is not input here. Only: diff, commits, tests, review.md.
- **No flattery.** Do not write "clean implementation" or "solid work". Describe *what* is there, not its quality. The review cluster already assessed quality.
- **Forward-looking, not backward-looking.** If a piece of context only matters to understand what happened *inside* this slice, drop it. The handoff is for the next slice, not a changelog.
- **Cap at 500 words.** If you need more, identify what can be dropped. Usually: historical context, personal reasoning, re-statement of the step-spec.

## Orchestrator dispatch prompt (copy verbatim)

> You are the Handoff-Writer subagent for slice `[ID]`. Fresh context, read-only except for the one output file. Read: `specs/[feature]/slices/[N]/step-spec.md`, `specs/[feature]/slices/[N]/review.md`, the git diff for commits `[SHAs]`, the commit messages, the test output from the last run (attached), and `specs/[feature]/eval-spec.md`.
>
> Do NOT read: knowledge.md, prior slices' handoff files, best-practices.md, or any Coder chat output.
>
> Your job: produce `specs/[feature]/slices/[N]/handoff.md` per the structure in `pipeline/09-write-handoff.md`. Target 300–500 words. Every claim traceable to a cited artifact. No flattery, no narration, forward-looking.
>
> When done, output the file path and the list of eval-spec criteria IDs marked green vs still red. Stop.

## Stop condition

`specs/[feature]/slices/[N]/handoff.md` exists, is committed, and has all 7 sections. Word count between 200 and 600 (tight band — compression is the feature).

## After this stage

**The orchestrator auto-advances.** If slices remain in `slice-plan.md`, the orchestrator runs the pre-slice drift check (stage 05.5) and then dispatches stage 06 for the next slice — no user action needed. If this was the final slice, the orchestrator dispatches stage 10 (Pipeline Critic).

The orchestrator's reads to start the next slice are:
- `CLAUDE.md`
- `specs/[feature]/slices/[N]/handoff.md` (the just-written file, for the next Coder)
- `specs/[feature]/slice-plan.md` (to identify slice N+1)

If Slice-Planner needs to re-run (because this handoff revealed plan-level issues), the orchestrator dispatches it before stage 06.

The only scenario where the user must manually start a new session is **context overflow** — see `00-START-HERE.md` § "Continuation protocol".
