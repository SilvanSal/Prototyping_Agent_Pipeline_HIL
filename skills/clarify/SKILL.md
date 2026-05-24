---
name: clarify
description: Use after domain research exists and before the Architect runs, to collapse ambiguity into explicit user decisions via A/B/C/D numbered questions. Orchestrator runs this in the main session WITH the user — not a subagent. Blocks stage 04 until the user replies "Go".
allowed-tools: Read, Grep, Glob, Write
---

# clarify — Stage 03

## When to trigger
- `specs/research/domain.md` exists (or the project is small enough that skipping domain research was justified).
- `specs/clarify-[feature].md` does NOT exist for the feature under discussion.
- User is about to start design for a new feature.

## Do not trigger
- If `specs/clarify-[feature].md` exists with all questions answered + user's "Go" recorded.
- If the feature has no ambiguities beyond what the constitution already pins down (rare — interrogate this assumption).

## Produces
`specs/clarify-[feature].md` — questions, recommendations, user answers verbatim.

## The A/B/C/D format (non-negotiable)
Every question must be numbered, present 2–4 concrete mutually exclusive options, include a `[recommend: ...]` marker on one with 1-sentence reasoning, and allow `Other: _____` as an implicit fifth option.

## Rules
- Target 5–12 questions. Fewer means missed ambiguities; more exhausts the user.
- Never ask open-ended questions. Always A/B/C/D.
- Do not answer on the user's behalf; halt and wait if unresponsive.
- Do not let the user skip to design. If they say "just build something", present the A/B/C/D anyway and record any refusal explicitly.
- Record answers in the order asked.
- One clarify doc per feature.

## "Go" gate
After the user has answered every question (or explicitly deferred each), write the file and present:

> I have recorded [N] decisions in `specs/clarify-[feature].md`. Next stage is 04 (Architect produces requirements + design + eval-spec). Respond with **"Go"** to proceed, or raise any concerns.

Do NOT dispatch the Architect until the user types "Go" (or explicit equivalent).

## Stop condition
`specs/clarify-[feature].md` exists with all questions, recommendations, user answers, and the "Go" recorded.
