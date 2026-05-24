---
name: review
description: Use immediately after `execute-step` reports commit SHAs + green tests. Dispatches Code-Reviewer and Security-Reviewer in parallel (both fresh context, read-only). Aggregates verdicts into `review.md`. Browser-Verifier is NOT invoked here — it runs once at end-of-feature.
allowed-tools: Read, Grep, Glob, WebSearch, Bash, Write
---

# review — Stage 08

## When to trigger
- The Coder has just reported commit SHAs for slice `[N]` and tests are green.
- `specs/[feature]/slices/[N]/review.md` does NOT yet exist.

## Do not trigger
- If the Coder reported test failures (route back to `execute-step` with the failure).
- If the review is already done for this slice.
- As a per-slice Browser-Verifier invocation — that is explicitly deferred to end-of-feature (see `ui-verify` below).

## Produces
`specs/[feature]/slices/[N]/review.md` with aggregated verdicts.

## Rules
- Parallel dispatch. Fire both reviewers in one message — no dependencies.
- Reviewers do not talk to each other; orchestrator aggregates.
- Reviewers are read-only. Fixes loop back to `execute-step`.
- Reviewers cannot expand scope. Pre-existing bugs outside the diff are `nit`, not block.
- Advance only if both verdicts are `pass` or `pass-with-notes`. Any `block` returns to stage 07.
- Code-Reviewer may attach a **suggested-fix snippet** to `block` or `warn` issues (text only, local, minimal). Never for `nit`. Snippets are guidance — the Coder writes the actual patch and may deviate with reasoning.

## Dispatch (parallel — one message, two subagent calls)

**Code-Reviewer:**
> You are the Code-Reviewer subagent. Fresh context, read-only. Read: `code-style.md`, `best-practices.md`, `specs/[feature]/slices/[N]/step-spec.md`, and the git diff for commits `[SHAs]`. Output verdict (`pass` / `pass-with-notes` / `block`) + numbered issues per `pipeline/08-review.md`. For `block` or `warn` issues you may attach a minimal, local suggested-fix snippet (text only — the Coder writes the actual patch). Never attach one to a `nit`. Stop.

**Security-Reviewer:**
> You are the Security-Reviewer subagent. Fresh context, read-only. Read: `specs/constitution.md` and the git diff for commits `[SHAs]`. You may use WebSearch for CVE checks on added dependencies. Output verdict (`pass` / `block`) + numbered findings per `pipeline/08-review.md`. Stop.

## Aggregation
Write `specs/[feature]/slices/[N]/review.md`:
```
## Code-Reviewer: [verdict]
[issues]

## Security-Reviewer: [verdict]
[findings]

## Orchestrator decision
- [ ] Advance to stage 09 (Handoff-Writer)
- [ ] Return to stage 07 (Coder) with fixes
- [ ] Escalate to user (design-level issue)
```

## End-of-feature UI verification (separate sub-mode)

Run ONCE per feature, after the final UI-touching slice's handoff is written. Produces `specs/[feature]/ui-verification.md`. Do NOT invoke per slice.

Dispatch:
> You are the Browser-Verifier subagent. Fresh context, no file reads except `specs/[feature]/eval-spec.md`. You have Chromium/Preview MCP tools. Dev server at `[URL]`. Exercise every UI-evaluator criterion + 2–3 edge cases each + regression-check earlier criteria. Output `specs/[feature]/ui-verification.md` with verdict (`pass` / `partial` / `fail` / `inconclusive`) + per-criterion results per `pipeline/08-review.md`. Flag inconclusives. Stop.

On `fail` / `partial`: open a remediation slice (re-run stages 05–09 for it). Do NOT patch from the verification session.

## Stop condition
`review.md` exists with both reviewer verdicts and an orchestrator decision. For end-of-feature: `ui-verification.md` exists.
