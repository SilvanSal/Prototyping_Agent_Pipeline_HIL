# Eval Spec: [Feature Name]

_Feature ID: [feature-slug] · Created: [YYYY-MM-DD]_

The reviewer cluster (code / security / browser) checks against THIS file. Every criterion has a unique ID so slice-plan and handoff can reference it.

> **Test-name convention:** For criteria whose evaluator is `unit test` or `integration test`, the `Test name` column holds the one-line signature the Coder will implement — e.g., `test_upload_rejects_files_over_10mb` (pytest) or `uploadRejectsFilesOver10MB()` (vitest). Names only, no file paths, no bodies. Pick the runner based on `tech-stack.md`. For `browser verifier` and `manual` evaluators, leave `Test name` as `—`. The Code-Reviewer (Stage 08) verifies each named test exists in the slice that owns the criterion.

## Pass criteria (per user story)

### US-01 criteria

| ID | Criterion | Evaluator | Test name | Notes |
|---|---|---|---|---|
| E-01.1 | [Testable statement] | unit test / integration test / browser verifier / manual | `test_name_here` or `—` | [how to run, what to assert] |
| E-01.2 | | | | |

### US-02 criteria

| ID | Criterion | Evaluator | Test name | Notes |
|---|---|---|---|---|
| E-02.1 | | | | |

## Regression criteria

Previously-shipped slices whose behavior must NOT change when this feature lands.

| ID | Behavior that must stay intact | Reference | Evaluator | Test name |
|---|---|---|---|---|
| R-01 | | slice `[ID]` | browser verifier / integration test | `test_name_here` or `—` |

## Performance budgets

| Metric | Target | Measurement method |
|---|---|---|
| | | |

## Security checks

Diff-scoped checks the Security-Reviewer runs on every commit in this feature.

- [ ] No secrets committed
- [ ] Auth-free routes do not return PII
- [ ] Input validation at every new trust boundary
- [ ] [Feature-specific check]

## Manual approval gates

Criteria that can't be automated. Must be explicitly approved by the user before the feature is considered complete.

- [ ] [User behavior that a human must confirm]

## Links

- Requirements: `specs/[feature]/requirements.md`
- Design: `specs/[feature]/design.md`
