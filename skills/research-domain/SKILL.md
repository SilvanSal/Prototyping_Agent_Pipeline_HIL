---
name: research-domain
description: Use when the user is starting a new feature and no `specs/research/domain.md` exists yet. Invokes the Domain-Researcher subagent to deeply survey prior art (reading papers in full, not abstracts), actively use competitor tools via browser, extract architectural implications from research, and engage the human in extended dialogue. Runs after `specs/constitution.md` is committed, before stage 03 (clarify).
allowed-tools: Read, Grep, Glob, WebSearch, WebFetch, Write, browser tools
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
`specs/research/domain.md` with 8 sections: problem framing, current solutions survey, user workflows, academic/technical prior art (detailed deep reading), known failure modes, regulatory/legal surface, architectural implications extracted from research, open questions (A/B/C/D format for stage 03 — **must include questions derived from architectural implications** so the Architect gets scope/choice decisions pre-resolved).

Also:
- Always creates an empty `specs/error-registry.md` from `templates/error-registry.md` for the Coder to grow during Stage 07.
- Optionally seeds `specs/research/hallucination-traps.md` from `templates/hallucination-traps.md` with 1–5 rows ONLY if well-documented wrong-pattern/right-pattern pairs surface during research (each with a source URL). Do not invent traps.

## Rules
- Do not propose architecture or tech stack. But DO extract architectural implications from research (there is a critical difference — see pipeline/01-research-domain.md).
- Every factual claim has a source URL; unsourced claims are deleted.
- Timestamp at top: `Research pass: [YYYY-MM-DD]`.
- Papers must be read in full and summarized in detail (multi-paragraph, not one-line distillations). Follow up on unfamiliar concepts with additional research.
- Freely-accessible competitor tools must be used first-hand via browser tools. Subscription-gated tools: ask the human (inline) or add to questionnaire (async).
- Architectural implications must be explicitly extracted and documented in section 7.
- Check `specs/constitution.md` § "Human profile" — if `domain-expert-async`, follow the multi-round questionnaire protocol in `pipeline/01-research-domain.md`. Otherwise, extended interactive human dialogue is expected.

## Dispatch the Domain-Researcher subagent

**Check `specs/constitution.md` § "Human profile" first.** Use the inline dispatch prompt if the expert is at the keyboard (or there is no separate expert). Use the async dispatch prompt if `domain-expert-async` is set. All three dispatch prompts (inline, async round 0, async follow-up) are in `pipeline/01-research-domain.md` — copy the appropriate one verbatim.

## Stop condition

**Inline mode:** `specs/research/domain.md` exists, has all 8 sections filled (or explicitly "none identified" with reasoning), timestamp at top, every factual claim sourced. Section 4 contains detailed multi-paragraph summaries. Section 7 is present and non-empty for any domain with research literature. `specs/error-registry.md` exists. `specs/research/hallucination-traps.md` exists if traps were found; otherwise skipped with a reason.

**Async mode:** All of the above, plus: at least one `expert-questionnaire-R[N].md` and corresponding `expert-answers-R[N].md` exist. `specs/research/expert-summary.md` exists and has been approved by the domain expert. No `_PENDING EXPERT INPUT_` markers remain in `domain.md`.

Then the orchestrator proceeds to stage 03 (clarify).
