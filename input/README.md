# input/ — Your Project Materials

Put your project materials here — briefs, PDFs, wireframes, specs, research notes, competitor screenshots, or anything that helps describe what you want to build.

Stage 00.5 (Intake-Reader) and Stage 01 (Domain-Researcher) read everything here.

## Accepted file types

| Type | Examples | Used for |
|---|---|---|
| `.md` / `.txt` | Briefs, RFCs, notes | Problem framing, constraints |
| `.pdf` | Papers, whitepapers, spec sheets | Research grounding, technical prior art |
| `.docx` | Word documents, proposals | Same as PDF |
| `.png` / `.jpg` | Wireframes, mockups, screenshots | UX intent, UI layout |
| `.yaml` / `.json` | OpenAPI specs, config schemas | API surface reference |
| `.zip` | Existing codebase references | Code context (use sparingly) |

## Recommended sub-folders

```
input/
├── papers/          # academic papers, technical reports
├── briefs/          # product briefs, PRDs, one-pagers
├── wireframes/      # mockups, screenshots, design files
├── specs-raw/       # OpenAPI specs, schema files, config templates
├── competitive/     # competitor screenshots, product teardowns
└── research-findings/   # populated by Domain-Researcher at Stage 01
```

## What NOT to put here

- Secrets, API keys, credentials, `.env` files
- Large binaries unrelated to the project brief (datasets, model weights)
- Code you intend to ship — that belongs in the target project repo

## Lifecycle

| Stage | Action |
|---|---|
| 00.5 Intake-Reader | Reads all files in `input/**`; writes `specs/intake-brief.md` and `specs/intake-qa.md` |
| 01 Domain-Researcher | Reads `specs/intake-brief.md` and `specs/intake-qa.md`; writes dated insight files to `input/research-findings/` |
| 04 Architect | Reads `input/**` directly for raw material grounding |

You may add files to `input/` at any time before Stage 04. Files added after Stage 04 will not influence the design of the current feature unless the pipeline is re-run from Stage 00.5.

## research-findings/ sub-folder

The Domain-Researcher writes dated insight files here after Stage 01:

```
input/research-findings/YYYY-MM-DD-[slug].md
```

These are machine-generated summaries and are safe to read but should not be hand-edited — they are regenerated if Stage 01 re-runs.
