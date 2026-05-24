# Best Practices — [Project Name]

_Last updated: [YYYY-MM-DD] · Source of truth for error handling, testing, commits, branching, and "done"._

> **Coders read this.** Code-Reviewer reads this. Nobody else does.
> **"Done" is defined here.** If this file says tests must pass, tests must pass.

## Coding principles

- **YAGNI.** Do not build for hypothetical future requirements. Three similar lines beat a premature abstraction.
- **KISS.** Prefer the dumbest thing that works. Cleverness is a tax future readers pay.
- **DRY with judgment.** Deduplicate behavior, not shape. Two functions that look alike but change for different reasons stay separate.
- **Single responsibility.** A function does one thing. A module owns one concept. If the summary needs "and", split it.
- **Pure where possible.** Push side effects (I/O, time, randomness) to the edges; keep the core deterministic and testable.
- **Fail fast at boundaries, trust internally.** Validate at the edge once; do not re-check inside.
- **Names over comments.** If the name does not explain it, rename before commenting.
- **Small units.** Prefer short functions and short files. If either grows without a clear reason, split.
- **No dead code.** Delete unused branches, flags, and `// removed` stubs. Git remembers; the repo should not.

## Architecture

- **Layer by dependency direction.** Upper layers (UI, API) depend on lower (domain, data) — never the reverse. No cycles between modules.
- **Feature folders, not type folders.** Group by capability (`features/checkout/`), not by kind (`controllers/`, `services/`). Keep cross-feature imports rare and explicit.
- **Public API per module.** Each folder exposes a small, intentional surface (an `index` export or equivalent). Internals are not importable across module boundaries.
- **Domain logic is framework-agnostic.** Business rules do not import the web framework, ORM, or UI library. Adapters do.
- **No hidden global state.** Dependencies come in as parameters or injected values. Singletons are justified in writing or not used.
- **Record non-trivial decisions as ADRs.** A short `docs/adr/NNNN-title.md` (context, decision, consequences). One per load-bearing choice.
- **Backwards-compat shims are banned within a release.** Change the call sites; do not leave a compatibility layer to "migrate later".

## Documentation

- **Code is the primary doc.** Names, types, and tests carry meaning first. Prose fills gaps only.
- **Public API docstrings.** Every exported function/class has a 1–3 line docstring: what it does, non-obvious constraints, error modes. Private helpers get docstrings only when the WHY is non-trivial.
- **Inline comments explain WHY, not WHAT.** See `code-style.md` — one short line, only when a future reader would otherwise be surprised.
- **README per project.** Must answer: what it is, how to run, how to test, where the specs live. No marketing prose.
- **ADRs for decisions, handoffs for progress.** Architecture decisions live in `docs/adr/`. Per-slice work summaries live in `specs/[feature]/slices/[N]/handoff.md`. Do not conflate them.
- **Docs live next to the code they describe.** Module docs in the module folder. Top-level docs in `docs/`. Stale docs are deleted, not left "for later".

## Error handling

- **At trust boundaries** (user input, external APIs, filesystem): validate explicitly, reject with a specific error.
- **Inside internal code:** trust callers. Do not re-validate. Do not add "just in case" defensive checks for conditions that cannot happen.
- **Error types:** [e.g., custom error classes with a `code` field] / [e.g., plain throws with message strings].
- **Never swallow errors silently.** Either handle or re-throw. `catch {}` blocks are forbidden.
- **Never log-and-rethrow.** Pick one: log, or rethrow.

## Logging

- **Log level:** [e.g., `info` default, `debug` behind an env flag].
- **Do not log** PII, credentials, auth tokens, full request bodies containing user data.
- **Format:** [e.g., structured JSON with `ts`, `level`, `event`, `ctx` fields].
- **Trace IDs:** [e.g., every request gets an ID propagated through async boundaries].

## Testing

- **What "tests pass" means:** [e.g., all unit + integration tests green; browser verifier signs off for UI slices].
- **Coverage target:** [e.g., 80% on changed files, no target on legacy].
- **Test naming:** [e.g., `test_[behavior]_[condition]` or `it('[behavior]', ...)` pattern].
- **Test data:** [e.g., fixtures in `tests/fixtures/`; factories preferred over inline object literals].
- **Mocks:** [e.g., mock at the network boundary, not at internal interfaces].
- **Flaky tests:** fix or delete. Do not retry.

## Commit messages

Format:
```
[type]([scope]): [imperative summary under 72 chars]

[Optional body: why, not what. Wrap at 72.]

[Optional footers: Refs slice S0N, Closes #123]
```

Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `build`.
Scope: the slice ID (e.g., `S01`) or module name.

## Branching

- **Model:** [e.g., trunk-based — short-lived branches merged daily / feature branches with PRs].
- **Branch names:** [e.g., `slice/S0N-short-name`].
- **PR / merge requirements:** [e.g., passing CI + reviewer cluster green in `review.md`].

## Dependencies

- **Adding a new dependency:** requires updating `tech-stack.md` in the same commit.
- **Removing a dependency:** must also remove all imports; reviewer enforces no dangling references.
- **Never use a dependency whose last release is > 2 years old** without an explicit note in `tech-stack.md`.

## What "done" means for a step

All of the following, or the step is not done:

1. All sub-tasks in `step-spec.md` committed.
2. Eval criteria listed in the step-spec pass (per `eval-spec.md`).
3. Test suite is green. No skipped tests without an explicit reason logged.
4. No new lint errors.
5. No new type errors.
6. `handoff.md` written by the Handoff-Writer subagent.

If any of these fail, the step returns to the Coder via stage 08's block path.

## Things never to do

- Never use `--no-verify`, `--no-gpg-sign`, or equivalent hook-bypass flags.
- Never run destructive git operations (`reset --hard`, `push --force`, `branch -D`) without explicit user approval.
- Never commit secrets. If you find one already committed, stop and raise it.
- Never introduce a feature flag for backwards compatibility inside a single release's slices.
- Never leave `_removed`, `deprecated:`, or commented-out code blocks.
