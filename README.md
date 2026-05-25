# Jacquard
![Jacquard Loom — every thread precisely routed](assets/banner.jpg)

**Every thread precisely routed — research-first AI coding for complex domains.**

Named after the [Jacquard loom](https://en.wikipedia.org/wiki/Jacquard_machine) — each agent is a thread with controlled inputs, isolated context, and a specific job. Human in the loop at every gate, because an LLM that skips domain research will confidently build the wrong thing.

A reusable, stage-gated playbook you hand to an LLM coding agent so it bootstraps a disciplined research-then-execute pipeline for a new app. Not a framework. Not a runtime. A set of linked Markdown instructions plus templates plus a bootstrap step that emits a project-specific `.claude/` scaffolding into the target repo.

## What this is

A **meta-pipeline**: the agent reads these files, runs them in order against a new project idea, and the output is (a) a filled-out `specs/` tree with research, requirements, design, eval specs, and vertical-slice plan, plus (b) a `.claude/` directory in the target project with skills, subagents, settings, and a `CLAUDE.md` triad that enforces the pipeline for every subsequent coding session.

The pipeline is human-in-the-loop by design. Stages like domain research involve extended back-and-forth with the human — the agent asks for access to subscription-gated tools, confirms architectural implications, and requests prioritization when research branches. A thorough 45-minute research session with multiple human check-ins is far more valuable than a 5-minute skim.

## Guiding principles (non-negotiable)

1. **Research before code.** No `Write` / `Edit` calls until domain research, codebase discovery, requirements, design, and eval spec are committed.
2. **Research means deep reading, not skimming.** Papers are read in full and summarized in detail. Competitor tools are used first-hand via the browser, not just read about. Unfamiliar concepts are followed up on with additional research. Every source is examined for architectural implications — problem taxonomies, complexity classes, required processing stages — that would constrain the software's structure.
3. **Human in the loop at every gate.** The agent pauses and asks the human when blocked on access, unsure about concepts, or when research is branching. Extended back-and-forth is expected — the human's domain knowledge and judgment are load-bearing inputs, not rubber stamps.
4. **Fresh context per stage.** Every stage runs in a new subagent with narrow tool access and a specified read-list. No stage reads the whole prior history — it reads named artifacts.
5. **Plan one phase ahead, not the whole tree.** Vertical slices are planned coarse; the next slice's task breakdown is generated *after* the previous slice lands and its handoff is written.
6. **Vertical slices, not backend-first.** Every slice ships a thin end-to-end piece of user-visible behavior, verified per-slice by automated tests. Chromium browser verification runs once at end-of-feature, not per slice — running it mid-build burns tokens on UI that is still in flux.
7. **Commit between steps, auto-advance between stages.** Each executed step ends with a commit, a review cluster verdict, and a handoff. The orchestrator auto-advances to the next stage — the user never has to `/clear` or manually continue. The only pauses are at human gates (clarify, slice plan approval) and context overflow.
8. **The handoff is the handoff.** The next step's coder reads only the previous step's `handoff.md`, not the previous step's full spec or code.
9. **Differentiated reads per role.** A researcher does not read `best-practices.md`. A coder does not read raw domain research. See [read-access matrix](#read-access-matrix).
10. **Evals are per step, written before code.** Each step-spec carries pass/fail criteria. The reviewer cluster checks against them.
11. **Reviewer cluster is separate from executors.** Code review, browser verification, and security review are subagents with their own fresh context.

## How to use

1. Open a fresh Claude Code session in the target project directory (empty repo or greenfield).
2. Paste or `@`-reference `00-START-HERE.md` from this pipeline directory.
3. The pipeline greets you and explains what to expect. If you have project materials (briefs, PDFs, wireframes, specs, research), drop them in the `input/` folder when prompted. Say "Ready" to begin.
4. The pipeline reads your materials, asks you some targeted questions, then does deep domain research. After that, it designs and builds — pausing at human gates (clarify questions, slice plan approval) for your input.
5. You never need to `/clear` or manually continue to the next stage — the orchestrator auto-advances.
6. If the context window fills up, the orchestrator writes a continuation file (`specs/.pipeline-state/continue.md`). Start a fresh session and `@`-reference that file to pick up where it left off.
7. After the feature ships, the pipeline critiques itself (Stage 10) and asks if you'd like to share your findings. If you do, submit as a [GitHub Issue](https://github.com/SilvanSal/jacquard/issues/new?template=pipeline-critique.yml) — it only captures meta-level pipeline friction, never your code or business logic.

## Directory layout

```
Jacquard/
├── README.md                     # this file
├── 00-START-HERE.md              # entrypoint the orchestrator reads first
├── input/                        # user-supplied project materials (briefs, PDFs, wireframes, specs)
│   └── README.md
├── pipeline/                     # ordered stage instructions
│   ├── 00-constitution.md
│   ├── 00.5-intake-reader.md
│   ├── 01-research-domain.md
│   ├── 02-research-codebase.md
│   ├── 03-clarify.md
│   ├── 04-requirements-design.md
│   ├── 05-plan-slices.md
│   ├── 06-research-step.md
│   ├── 07-execute-step.md
│   ├── 08-review.md
│   ├── 09-write-handoff.md
│   └── 10-pipeline-critique.md
├── templates/                    # skeleton artifacts the stages fill in
│   ├── constitution.md
│   ├── intake-brief.md
│   ├── intake-qa.md
│   ├── research-finding.md       # rich schema for each research insight (YAML frontmatter + source chain)
│   ├── research-findings-index.md # auto-maintained index with filter tables + dependency graph
│   ├── requirements.md
│   ├── design.md
│   ├── eval-spec.md
│   ├── slice-plan.md
│   ├── step-spec.md
│   ├── knowledge.md
│   ├── handoff.md
│   ├── error-registry.md         # project-scoped bug memory, empty-seeded at stage 01, grown by Coder
│   ├── hallucination-traps.md    # project-scoped wrong/right-pattern lookup, optionally seeded at stage 01
│   └── pipeline-critique.md      # post-feature critique skeleton for stage 10
├── claude-md-template/           # target-project conventions (CLAUDE.md triad)
│   ├── CLAUDE.md
│   ├── tech-stack.md
│   ├── code-style.md
│   └── best-practices.md
├── skills/                       # pre-authored SKILL.md per stage — copied into .claude/skills/ at bootstrap
│   ├── intake-reader/SKILL.md
│   ├── research-domain/SKILL.md
│   ├── research-codebase/SKILL.md
│   ├── clarify/SKILL.md
│   ├── requirements-design/SKILL.md
│   ├── plan-slices/SKILL.md
│   ├── research-step/SKILL.md
│   ├── execute-step/SKILL.md
│   ├── review/SKILL.md
│   └── write-handoff/SKILL.md
├── agents/                       # pre-authored subagent definitions — copied into .claude/agents/ at bootstrap
│   ├── intake-reader.md
│   ├── domain-researcher.md
│   ├── codebase-explorer.md
│   ├── architect.md
│   ├── slice-planner.md
│   ├── step-researcher.md
│   ├── coder.md
│   ├── code-reviewer.md
│   ├── security-reviewer.md
│   ├── browser-verifier.md
│   ├── handoff-writer.md
│   └── pipeline-critic.md
├── PIPELINE_IMPROVEMENT_CRITIQUE/  # post-feature critiques — stage 10 output, one per feature
│   └── README.md
└── bootstrap/
    └── generate-claude-scaffolding.md   # meta-step: copies skills/ + agents/ into .claude/ and substitutes tokens
```

## Read-access matrix

Each subagent reads only what its job requires. The orchestrator enforces this in the dispatch prompt; the generated `.claude/hooks/restrict-reads.sh` enforces the load-bearing restrictions at runtime via a stage-marker file (`.claude/.state/current-stage`). See [`bootstrap/generate-claude-scaffolding.md`](bootstrap/generate-claude-scaffolding.md) and [`00-START-HERE.md`](00-START-HERE.md) § "Stage marker protocol". `grep` = keyword lookup only, not a cover-to-cover read.

| Agent | constitution | domain-research | tech-stack | code-style | best-practices | step-spec | knowledge | prev-handoff | diff | eval-spec | repo | error-registry | hallucination-traps |
|---|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
| Intake-Reader | v | — | — | — | — | — | — | — | — | — | input/ (R) | — | — |
| Domain-Researcher | v | — | — | — | — | — | — | — | — | — | findings (W+index) | writes (empty seed) | writes (optional seed) |
| Codebase-Explorer | v | — | — | — | — | — | — | — | — | — | v (read-only) | — | — |
| Architect | v | v | v | — | — | — | — | — | — | — | findings/INDEX (R) | — | — |
| Slice-Planner | v | — | v | — | — | — | — | — | — | v | — | — | — |
| Step-Researcher | v | — | v | — | — | v | grep | — | — | — | findings/INDEX (grep) | grep | grep |
| Coder | v | — | v | v | v | v | v | v | — | — | v (scoped paths) | grep + append | grep + append |
| Coder + eval-harness | (same as Coder, plus reads `pipeline/07a-eval-harness.md` — only when step-spec has `(RED — eval)` sub-tasks) |
| Code-Reviewer | — | — | — | v | v | v | — | — | v | v (test-name column only) | — | — | — |
| Security-Reviewer | v | — | — | — | — | — | — | — | v | — | — | — | — |
| Browser-Verifier (end-of-feature only) | — | — | — | — | — | — | — | — | — | v | running app | — | — |
| Handoff-Writer | — | — | — | — | — | v | — | — | v | v | — | — | — |
| Pipeline-Critic (post-feature) | — | — | — | — | — | — | — | — | — | v | — | grep | — |

*Pipeline-Critic also reads: `slice-plan.md`, `session-log.md`, all `review.md` and `handoff.md` files, and prior critiques in `PIPELINE_IMPROVEMENT_CRITIQUE/`.*

## Community flywheel

Here's the deal: every time you finish a feature, the pipeline automatically generates a critique of *itself* — what worked, what caused friction, which instructions were unclear. That critique stays in your repo. But if you share it with us, it makes the pipeline better for the next person who tackles a project like yours.

### How it works

After your last slice ships, Stage 10 (Pipeline Critic) runs automatically and produces a critique file in `PIPELINE_IMPROVEMENT_CRITIQUE/`. Then the pipeline will ask if you'd like to share your findings. If you're up for it, submit it as a [GitHub Issue](https://github.com/SilvanSal/jacquard/issues/new?template=pipeline-critique.yml) — takes about 2 minutes, mostly copy-paste from the file the agent already wrote for you.

**What we learn from each submission:**
- Which pipeline instructions caused friction (and which were crystal clear)
- Which domain types the pipeline handles well vs where it struggles
- Whether the research loop went deep enough or spun its wheels
- Which architectural findings actually shaped the final design

### Your data stays yours

We want to be upfront about this: **nothing about your project's code, business logic, or proprietary information gets shared.** The critique template collects only meta-level signals — things like "the Coder deviated from the step-spec twice" or "Stage 03 asked the wrong questions." It's pipeline friction data, not your intellectual property.

The template is designed so you can fill it out without thinking twice about confidentiality. And if any field feels too close to home, skip it — we'd rather get a partial submission than make you uncomfortable. Your trust matters more than any data point.

### What we're optimizing for

This pipeline is designed for **deep domain complexity** — projects where getting the domain wrong means building the wrong thing. Compliance engines, medical device controllers, financial modeling tools, scientific data pipelines. If your project has academic literature, regulatory constraints, or domain-specific algorithms, this pipeline is for you.

We are NOT optimizing for "build a todo app faster." There are better tools for that.

## When this pipeline is wrong for the task

- Throwaway scripts, one-file tools, prototypes with <2 hours of work — the ceremony outweighs the value.
- Exploratory research code where the goal is learning, not shipping.
- Existing large codebases with strong established conventions — use only the review cluster and per-step research bits.
