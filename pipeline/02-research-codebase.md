# Stage 02 — Codebase Discovery

**Run by:** `Codebase-Explorer` subagent (fresh context, read-only tools: Read/Grep/Glob only — no Write/Edit/Bash-mutating)
**Reads:** target repo (if it exists), `specs/constitution.md`
**Produces:** `CLAUDE.md`, `tech-stack.md`, `code-style.md`, `best-practices.md` in the target project root

## Purpose

If the project is greenfield, this stage produces the standards triad from `claude-md-template/` with minimal modification. If the project already has a codebase, this stage *discovers* the existing conventions and writes them down so downstream coders follow the same patterns instead of inventing new ones. Every coder session reads these files before writing code.

## What the Codebase-Explorer must produce

### `CLAUDE.md`
Start from `claude-md-template/CLAUDE.md`. Fill in the project-specific sections. This file is the top-level pointer every session reads. It should be short and link out to the triad.

### `tech-stack.md`
- Language(s), version(s) pinned.
- Framework(s), version(s) pinned.
- Database, message queue, cache — if any.
- Build tools, package manager, test runner.
- If greenfield: leave as "_TBD — Architect will fill in stage 04_" and note that stage 04 must write this.

### `code-style.md`
- Naming conventions (files, functions, variables).
- Import ordering.
- Formatting rules (quote style, trailing commas, line length) — prefer referencing the installed linter config over re-stating.
- File organization patterns (colocated tests? separate `tests/` dir?).
- If greenfield: pick sensible defaults from the constitution's tech-stack-locks. If those are empty, defer to stage 04.

### `best-practices.md`
- Error handling patterns — what the codebase does when things fail.
- Logging conventions.
- Testing expectations — coverage thresholds, test naming, what "done" means.
- Commit message format.
- Branching model (trunk-based? feature branches?).
- If greenfield: pick sensible defaults and mark them as defaults so stage 04 can revise.

## Rules for this stage

- **Read-only.** You may not run tests, install packages, or modify anything.
- **Discover, don't invent.** If the codebase has a pattern, document it, even if you dislike it. A project with consistent bad patterns beats a project with mixed good and bad.
- **For greenfield, defer rather than guess.** Leaving `_TBD_` is better than inventing a tech stack the Architect will override. The only exception: if `specs/constitution.md` has tech-stack-locks filled in, use those.
- **Flag contradictions.** If you find two conflicting patterns (camelCase in half the files, snake_case in the other), write the dominant one and note the inconsistency in a "Known inconsistencies" section at the bottom of the relevant file. Do not silently pick one.
- **Do not read `specs/research/domain.md`.** Domain research is not your job. Tech-stack context only comes from the constitution and the repo itself.

## Orchestrator dispatch prompt (copy verbatim)

> You are the Codebase-Explorer subagent. You have a fresh context window and read-only tools (Read, Grep, Glob). Read: `specs/constitution.md` and the target repository's existing files (if any).
>
> Your job: produce four files in the target project root — `CLAUDE.md`, `tech-stack.md`, `code-style.md`, `best-practices.md` — using the structure in `pipeline/02-research-codebase.md`. For greenfield projects, start from `claude-md-template/` in the pipeline directory.
>
> You may NOT write application code, run tests, install anything, or read `specs/research/domain.md`. When done, output the four file paths and a note on whether this is greenfield or discovery. Stop.

## Stop condition

All four files exist and are committed. For greenfield: at minimum `CLAUDE.md` and `best-practices.md` are filled with defaults; `tech-stack.md` and `code-style.md` may defer to stage 04 with explicit `_TBD_` markers.
