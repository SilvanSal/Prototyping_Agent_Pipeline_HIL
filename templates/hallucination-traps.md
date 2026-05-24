# Hallucination Traps

_Project-scoped. One file for the whole app. Seeded at Stage 01 if the domain has known wrong-pattern/right-pattern pairs; appended to by the Coder when a trap is confirmed during execution._

> **Purpose:** a short lookup of specific wrong-pattern → right-pattern pairs that LLMs (including you) reliably get wrong for this domain. Grep before writing code in an unfamiliar area. Grep before assuming an API works the way the name suggests.
>
> **What belongs here:** confirmed cases where the intuitive / memorised / widely-documented-but-wrong pattern produces silently broken code. Must be reproducible, not a one-off bug.
>
> **What does NOT belong here:** normal bugs (→ `error-registry.md`), style preferences (→ `code-style.md`), general best practices (→ `best-practices.md`), project-specific business rules (→ `requirements.md`).

## Table

Newest rows on top. Keep descriptions short — the Wrong/Correct columns are the payload.

| Trap | Wrong pattern | Correct pattern | Source |
|---|---|---|---|
| [one-phrase name — what the agent tends to do wrong] | `short code snippet or API call that looks right but fails` | `short code snippet of the actually-working form` | [URL to docs / GH issue / changelog / commit SHA where this was confirmed in this project] |

## Promotion rules

- A row earns its place only after a confirmed wrong → right swap. Theoretical traps do not belong here.
- If a trap in `error-registry.md` hits its 3rd recurrence, promote it to a row here.
- If a row here has not triggered a prevented-mistake in 6 months AND the underlying library has changed major version, mark it `[stale: review]` and let the next Step-Researcher decide whether to keep, rewrite, or delete.

## Links

- Error registry: `specs/error-registry.md`
- Domain research: `specs/research/domain.md`
