# Error Registry

_Project-scoped. One file for the whole app. Created empty at bootstrap; grown by the Coder during Stage 07._

> **Purpose:** prevent re-debugging the same failure twice. Before chasing a non-trivial bug, grep here first. When you solve a non-trivial bug, append an entry so the next slice (and the Step-Researcher) finds it.
>
> **What counts as non-trivial:** anything that took more than one obvious fix attempt, anything that silently misbehaved at runtime without a clear error, anything involving version/schema/platform mismatch, anything you had to WebSearch to resolve. One-line typos do NOT belong here.
>
> **What does NOT belong here:** design decisions (→ `design.md` or ADRs), style preferences (→ `code-style.md`), domain facts (→ `research/domain.md` or slice knowledge.md), feature-level gotchas about an external API that you haven't hit yet (→ slice `knowledge.md`).

## Format

Every entry is one `###` block. Newest on top. Keep the body under ~15 lines.

```
### [short slug — the error signature you would grep for]

- **First hit:** slice `[ID]` · commit `[SHA]` · [YYYY-MM-DD]
- **Signature:** [exact error message, stack frame, or observable symptom — the string a future reader will grep]
- **Root cause:** [one sentence]
- **Fix:** [one or two sentences · file:line if local]
- **Scope:** [where else this pattern could resurface · which libraries/versions/OSes are affected]
- **Recurrence:** [count — increment when the same class hits again; if ≥3, promote to a slice knowledge.md gotcha or a hallucination-traps.md row]
```

## Entries

<!-- Coder appends above this line. Example entry below — delete once real ones exist. -->

### example-stale-entry-delete-me

- **First hit:** slice `S00` · commit `0000000` · 2026-01-01
- **Signature:** `TypeError: Cannot read properties of undefined (reading 'map')` in `FooList.tsx:42` on empty-array response
- **Root cause:** API returns `null` on empty, not `[]`; component assumed array.
- **Fix:** normalize at the fetch boundary — `return data ?? []` in `fooApi.ts:17`.
- **Scope:** any endpoint in `fooApi.ts` that returns a list. Confirmed on `foo-service@1.4.x`.
- **Recurrence:** 1
