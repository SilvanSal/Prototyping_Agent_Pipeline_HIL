---
name: intake-reader
description: Run stage 00.5 — Intake Reader. Reads everything in input/, synthesises a structured brief, and asks 5–10 architectural Q&A questions before domain research begins. Invoke after constitution and before domain research.
---

# /intake-reader

Runs Stage 00.5. Reads all user-supplied materials in `input/`, builds a synthesis brief, and asks clarifying questions whose answers ground domain research in what the user already knows — rather than re-discovering it from scratch.

## When to invoke

After `specs/constitution.md` is committed and before Stage 01 (domain research). Invoke once per project, not once per feature.

Also invoke if:
- The user adds significant new materials to `input/` after constitution but before Stage 04
- The user asks to re-run intake with updated materials

## What this skill does

1. Reads `input/**` and `specs/constitution.md`
2. Produces `specs/intake-brief.md` — a structured synthesis of user-supplied materials
3. Produces `specs/intake-qa.md` — 5–10 A/B/C/D questions, most consequential first
4. Presents questions to the user and waits for answers
5. Records answers in `specs/intake-qa.md`

## Outputs

| File | Written by | Read by |
|---|---|---|
| `specs/intake-brief.md` | Intake-Reader | Domain-Researcher (Stage 01), Architect (Stage 04) |
| `specs/intake-qa.md` | Intake-Reader | Domain-Researcher (Stage 01), Architect (Stage 04) |

## Gates

Stage 01 (Domain-Researcher) does not start until both output files exist and all questions in `specs/intake-qa.md` have recorded answers.

## Orchestrator action

Before dispatching Intake-Reader, write `.claude/.state/current-stage` = `intake-reader`.

After the subagent returns:
1. Verify `specs/intake-brief.md` exists and is non-empty.
2. Verify `specs/intake-qa.md` exists, has questions, and every question has a recorded answer.
3. If either check fails: do not advance to Stage 01. Re-run this stage.
