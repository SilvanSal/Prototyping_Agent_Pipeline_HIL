# Tech Stack — [Project Name]

_Last updated: [YYYY-MM-DD] · Source of truth for allowed dependencies and versions._

> **Pinning is non-negotiable.** Every row below has an exact version. A Coder may not install a different version without an explicit update to this file.
> **Changes to this file require an orchestrator-level decision**, not a per-step one. Raise it.

## Runtime

| Concern | Choice | Version | Notes |
|---|---|---|---|
| Language | | | |
| Runtime | | | |
| Package manager | | | |

## Frameworks and libraries

| Name | Version | Purpose | Docs URL |
|---|---|---|---|
| | | | |

## Data layer

| Concern | Choice | Version | Notes |
|---|---|---|---|
| Database | | | |
| ORM / query builder | | | |
| Migration tool | | | |
| Cache | | | |
| Queue | | | |

## Build / dev tooling

| Concern | Choice | Version | Notes |
|---|---|---|---|
| Bundler | | | |
| Test runner | | | |
| Linter | | | |
| Formatter | | | |
| Type checker | | | |

## Deployment

| Concern | Choice | Notes |
|---|---|---|
| Hosting | | |
| CI/CD | | |
| Secrets management | | |
| Observability | | |

## Approved external APIs

Third-party APIs that are allowed and the auth mechanism.

| API | Purpose | Auth | Docs URL |
|---|---|---|---|
| | | | |

## Explicitly forbidden

Libraries, APIs, or patterns that must NOT be introduced. Usually from the constitution's non-goals.

- [Forbidden thing] — [reason]

## Version bump policy

- Patch versions: auto, no approval required.
- Minor versions: require updated `knowledge.md` for any affected slice.
- Major versions: require a dedicated slice or a constitution revisit.
