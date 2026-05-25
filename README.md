# Jacquard
![Jacquard Loom — every thread precisely routed](assets/banner.jpg)

Research-first AI coding pipeline for complex domains. Drop your materials and the agent handles everything — researching, designing, building, reviewing, and iterating with you.

---

## Why Jacquard

**Deep domain research, not skimming.** Scientific papers read in full. Every source traced for architectural implications. The agent loops back to you when it finds something that needs your input — no fixed round limit, just depth until the domain is actually understood.

**Hyper-precise context routing.** Every subagent gets a fresh context window with only the files it needs — a researcher never sees code style rules, a coder never sees raw research papers. Twelve specialized roles, each with an enforced read-list. No context pollution, no confusion, no hallucinations from stale information bleeding across stages.

**Professional TDD infrastructure.** Every slice is built test-first with a separate review cluster — code reviewer and security reviewer running in parallel, each in their own fresh context. Evals are written before code. Pass/fail criteria exist before the first line is implemented. The reviewer can block, and the coder has to fix it before anything advances.

---

## Get Started

Open a Claude Code session in the Jacquard folder and say "Go." The agent takes it from there.

---

## Pipeline Files

```
Jacquard/
├── 00-START-HERE.md              # orchestrator entrypoint
├── input/                        # your project materials
├── pipeline/                     # stage instructions (00–11)
├── templates/                    # artifact skeletons (research findings, specs, handoffs)
├── agents/                       # subagent definitions (one per role)
├── skills/                       # SKILL.md per stage (copied to .claude/skills/ at bootstrap)
├── claude-md-template/           # CLAUDE.md triad for the target project
├── bootstrap/                    # generates .claude/ scaffolding in the target repo
└── PIPELINE_IMPROVEMENT_CRITIQUE/  # stage 10 output (one per feature)
```

---

## What the Pipeline Does

### Phase 1 — Understand

The agent reads your materials, asks you targeted questions, then does deep domain research. Papers, tools, APIs, competitors — it digs until it actually understands the problem space. It loops back to you whenever it finds something that needs your input.

### Phase 2 — Design

Architecture, requirements, evaluation criteria, and a vertical slice plan. You approve the plan before any code gets written.

### Phase 3 — Build

One slice at a time — research the step, write code with tests, get it reviewed by separate agents (code + security), write a handoff, auto-advance to the next slice. Repeat until the feature ships.

### Phase 4 — Iterate

After shipping, you stay in a loop. Describe bugs, refinements, or new features — the agent figures out the right approach (quick patch, enhancement, or full pipeline) and handles it. Say "done" when you're finished.

---

## Built For

**Deep domain complexity** — projects where getting the domain wrong means building the wrong thing.

Compliance engines. Medical device controllers. Financial modeling tools. Scientific data pipelines. If your project has academic literature, regulatory constraints, or domain-specific algorithms — this is for you.

**Not for** throwaway scripts, simple CRUD apps, or "build a todo app faster."

---

## Community

After each feature ships, the agent offers to share pipeline friction data with the community — say "yes" and it handles the submission. Nothing proprietary leaves your machine.

[View submitted critiques](https://github.com/SilvanSal/jacquard/issues?q=label%3Acritique) | [Questions & discussion](https://github.com/SilvanSal/jacquard/discussions)
