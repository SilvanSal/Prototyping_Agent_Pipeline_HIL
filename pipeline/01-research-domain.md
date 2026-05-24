# Stage 01 — Domain Research

**Run by:** `Domain-Researcher` subagent (fresh context, read-only tools + WebSearch/WebFetch)
**Reads:** user brief, `specs/constitution.md`
**Produces:** `specs/research/domain.md` · optionally seeds `specs/research/hallucination-traps.md` and creates an empty `specs/error-registry.md`

## Purpose

Understand the domain the app lives in *before* designing. This is NOT tech-stack research. It is: what do real users in this space do today? What prior art exists (open-source, commercial, academic)? What are the known failure modes, UX conventions, and regulatory quirks?

## What the Domain-Researcher must produce

Copy `templates/knowledge.md` layout (but save as `specs/research/domain.md`) and fill in the following sections:

1. **Problem framing** — 1 paragraph. What problem the app solves, stated in the user's words, not the product's.
2. **Current solutions survey** — at least 3 existing tools / products / approaches that address this problem. For each: URL, one-sentence description, what they do well, what they do badly. Prefer the 2–3 closest competitors over a wide survey.
3. **User workflows observed** — describe how real users accomplish this task today, even if clumsily. If the Chromium verifier is available, use it to actually click through 1–2 competitor apps and record the interaction pattern.
4. **Academic / technical prior art** — 1–5 relevant papers, RFCs, blog posts, or specifications. URL + one-paragraph distillation each. Skip if the domain has no research literature (most CRUD apps).
5. **Known failure modes** — what goes wrong for users of existing solutions? Security issues, UX frustrations, performance cliffs, data-loss patterns. 3–7 items.
6. **Regulatory / legal surface** — GDPR, COPPA, HIPAA, PCI, accessibility mandates, content moderation obligations. One paragraph or "none identified" with reasoning.
7. **Open questions for the user** — numbered A/B/C/D format. These feed directly into stage 03.

## Optional seed: hallucination-traps.md + empty error-registry.md

While surveying prior art and failure modes, the Domain-Researcher will occasionally discover *well-documented wrong-pattern/right-pattern pairs* — e.g., a BIM schema where `.FireRating` looks like an attribute but is actually inside a property set; a charting library whose default behaviour silently swallows NaN; a payment API whose `amount` field is in cents, not dollars.

If 1–5 such pairs surface during domain research, seed `specs/research/hallucination-traps.md` from `templates/hallucination-traps.md` and add one row per confirmed pair, each with a source URL. Do NOT invent traps — only include ones you ran into or found explicitly documented.

Regardless of whether traps exist, create `specs/error-registry.md` from `templates/error-registry.md` as an empty registry with the delete-me example intact. The Coder will grow it during execution.

Skip both seeds only if the domain has no known documented traps AND you cannot create the empty error-registry file for some reason (log why in your output).

## Rules for this stage

- **Do not propose an architecture.** That is stage 04's job.
- **Do not pick a tech stack.** That is stage 04's job.
- **Do not write code or pseudocode.**
- **Cite sources.** Every claim about a competitor, a paper, or a regulation must have a URL. Unsourced claims get deleted by the reviewer.
- **Pin timestamps.** At the top of the file, write `Research pass: [YYYY-MM-DD]`. Domain research ages — downstream stages decide whether to trust or refresh.
- **Use the browser verifier for competitor UX study** if available. It's cheaper and more accurate than reading screenshots.

## Orchestrator dispatch prompt (copy verbatim)

> You are the Domain-Researcher subagent. You have a fresh context window. Read ONLY these files: `specs/constitution.md`, and the user's original brief (attached below).
>
> Your job: produce `specs/research/domain.md` following the structure in `pipeline/01-research-domain.md`. You may use WebSearch, WebFetch, and (if available) the Chromium browser tools. You may NOT propose an architecture, pick a tech stack, or write code.
>
> While researching, if you encounter 1–5 well-documented wrong-pattern/right-pattern pairs for this domain (each with a source URL), seed `specs/research/hallucination-traps.md` from `templates/hallucination-traps.md` with one row per confirmed pair. Do not invent traps. Regardless of whether traps are found, also create `specs/error-registry.md` from `templates/error-registry.md` as an empty registry for the Coder to grow later.
>
> When you are done, output the file paths (including the two optional seeds) and a 5-bullet summary of the key findings. Stop.

## Stop condition

File `specs/research/domain.md` exists, has all 7 sections filled or explicitly marked "none identified" with reasoning, every factual claim has a source URL, and the timestamp is at the top. `specs/error-registry.md` exists (empty or with the delete-me example). `specs/research/hallucination-traps.md` exists if 1–5 documented traps were found; otherwise is skipped with a one-line reason in the Domain-Researcher's output.
