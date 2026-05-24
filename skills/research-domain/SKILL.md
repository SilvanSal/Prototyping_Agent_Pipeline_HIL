---
name: research-domain
description: Use when the user is starting a new feature and no `specs/research/domain.md` exists yet. Invokes the Domain-Researcher subagent to survey prior art, user workflows, failure modes, and regulatory surface for the problem space — NOT tech stack. Runs after `specs/constitution.md` is committed, before stage 03 (clarify).
allowed-tools: Read, Grep, Glob, WebSearch, WebFetch, Write
---

# research-domain — Stage 01

## When to trigger
- `specs/constitution.md` exists.
- `specs/research/domain.md` does NOT exist (or is stale — see refresh policy below).
- User has asked to start a new feature OR explicitly invoked this skill.

## Do not trigger
- If `specs/research/domain.md` exists and is < 90 days old.
- If this is a tech-stack question (that's stage 04's job).
- If the user wants to go straight to design — route them to clarify (stage 03) instead and raise that domain research is missing.

## Produces
`specs/research/domain.md` with 7 sections: problem framing, current solutions survey, user workflows, academic/technical prior art, known failure modes, regulatory/legal surface, open questions (A/B/C/D format for stage 03).

Also:
- Always creates an empty `specs/error-registry.md` from `templates/error-registry.md` for the Coder to grow during Stage 07.
- Optionally seeds `specs/research/hallucination-traps.md` from `templates/hallucination-traps.md` with 1–5 rows ONLY if well-documented wrong-pattern/right-pattern pairs surface during research (each with a source URL). Do not invent traps.

## Rules
- Do not propose architecture or tech stack.
- Every factual claim has a source URL; unsourced claims are deleted.
- Timestamp at top: `Research pass: [YYYY-MM-DD]`.
- Do NOT use Chromium MCP mid-build; optional at research time only for competitor UX study.

## Dispatch the Domain-Researcher subagent (verbatim)

> You are the Domain-Researcher subagent. Fresh context window. Read ONLY these files: `specs/constitution.md`, and the user's original brief (attached below).
>
> Produce `specs/research/domain.md` following the structure in `pipeline/01-research-domain.md`. You may use WebSearch, WebFetch, and (optionally, only if research is blocked without it) the Chromium browser tools. You may NOT propose an architecture, pick a tech stack, or write code.
>
> If 1–5 well-documented wrong-pattern/right-pattern pairs surface during research (each with a source URL), seed `specs/research/hallucination-traps.md` from `templates/hallucination-traps.md` with one row per confirmed pair. Do not invent traps. Regardless, also create `specs/error-registry.md` from `templates/error-registry.md` as an empty registry for later growth.
>
> When done, output all file paths and a 5-bullet summary of key findings. If hallucination-traps was skipped, state the reason in one line. Stop.

## Stop condition
`specs/research/domain.md` exists, has all 7 sections filled (or explicitly "none identified" with reasoning), timestamp at top, every factual claim sourced. `specs/error-registry.md` exists (empty or with the delete-me example). `specs/research/hallucination-traps.md` exists if 1–5 documented traps were found; otherwise skipped with a one-line reason in the output. Then the orchestrator proceeds to stage 03 (clarify).
