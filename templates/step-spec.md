# Step Spec: Slice [ID]

_Feature: [feature-slug] · Slice: [S0N] · Created: [YYYY-MM-DD]_

## User-visible outcome

[Copy verbatim from `slice-plan.md`. One sentence.]

## Eval criteria this step satisfies

Copied verbatim from `eval-spec.md`:

- **E-XX.Y** — [text]
- **E-XX.Z** — [text]

## Sub-tasks

Each sub-task is one-commit-sized. 3–10 sub-tasks typical. Ordered.

- [ ] **T1:** [action in imperative verb form]
- [ ] **T2:** [action]
- [ ] **T3:** [action]
- [ ] **T4:** [action]
- [ ] **T5:** [action — usually the test step]

## Files expected to be touched

Best guess. Coder may diverge but must raise significant deviations.

- `path/to/file1.ext` — [create / modify]
- `path/to/file2.ext` — [create / modify]
- `path/to/file3.test.ext` — [create]

## Out of scope (do NOT touch)

- [module / path] — [reason]
- [module / path] — [reason]

## Done definition

This step is done when:
- [ ] All sub-tasks committed
- [ ] All eval criteria listed above pass
- [ ] Test suite is green (or failures are explicitly documented)
- [ ] No new lint errors
- [ ] Commits follow `best-practices.md` message format

## Links

- Slice plan: `specs/[feature]/slice-plan.md`
- Knowledge for this step: `specs/[feature]/slices/[N]/knowledge.md`
- Previous handoff: `specs/[feature]/slices/[N-1]/handoff.md` (if N > 1)
