---
name: research-codebase
description: Use once per project, after `specs/constitution.md` exists, to discover or bootstrap the standards triad (`CLAUDE.md`, `tech-stack.md`, `code-style.md`, `best-practices.md`). For greenfield, copies from `claude-md-template/` with minimal edits. For existing repos, discovers and documents existing conventions. Invokes the Codebase-Explorer subagent.
allowed-tools: Read, Grep, Glob, Write
---

# research-codebase — Stage 02

## When to trigger
- `specs/constitution.md` exists.
- One or more of `CLAUDE.md` / `tech-stack.md` / `code-style.md` / `best-practices.md` is missing at the project root.

## Do not trigger
- If all four triad files already exist — modifying them is an explicit user request, not this skill.

## Produces
Four files at the target project root: `CLAUDE.md`, `tech-stack.md`, `code-style.md`, `best-practices.md`.

## Rules
- Read-only on the repo (no tests run, no installs).
- Discover, don't invent: document existing conventions even if imperfect.
- Greenfield: copy from `claude-md-template/`, leave `_TBD — Architect to fill in stage 04_` where unknowable.
- Flag contradictions in a "Known inconsistencies" section; do not silently pick one.
- Do NOT read `specs/research/domain.md`.

## Dispatch the Codebase-Explorer subagent (verbatim)

> You are the Codebase-Explorer subagent. Fresh context window, read-only tools (Read, Grep, Glob). Read: `specs/constitution.md` and the target repository's existing files (if any).
>
> Produce four files at the target project root — `CLAUDE.md`, `tech-stack.md`, `code-style.md`, `best-practices.md` — using the structure in `pipeline/02-research-codebase.md`. For greenfield projects, start from `claude-md-template/` in the pipeline directory.
>
> You may NOT write application code, run tests, install anything, or read `specs/research/domain.md`. When done, output the four file paths and a note on whether this is greenfield or discovery. Stop.

## Stop condition
All four files exist and are committed. For greenfield, `CLAUDE.md` + `best-practices.md` have defaults; `tech-stack.md` / `code-style.md` may defer to stage 04 with `_TBD_`.
