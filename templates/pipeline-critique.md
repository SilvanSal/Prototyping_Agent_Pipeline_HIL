# Pipeline Critique: [feature-slug]

_Feature: [feature-slug] · Phase: [P] · Written: [YYYY-MM-DD] · Slices analysed: [N]_

---

## Quality signal summary

| Signal | This run | Prior avg | Target |
|---|---|---|---|
| Block reviews | — | — | 0 |
| Pass-with-notes reviews | — | — | ≤ 1/slice |
| Micro-research escapes | — | — | ≤ 1/feature |
| Step-spec deviations | — | — | ≤ 1/feature |
| Error-registry entries added | — | — | ≤ 1/feature |

_Prior avg: computed from all files in `PIPELINE_IMPROVEMENT_CRITIQUE/`. Write "n/a" if this is the first critique._

---

## Per-slice analysis

### Slice [N]: [title]

- **Review verdict:** pass / pass-with-notes / block (N block issues, N notes)
- **Micro-research:** [N lookups — list topic + which knowledge.md claim was wrong, or "none"]
- **Deviations from step-spec:** [list, or "none"]
- **Slice sizing:** right / too large / too small — [evidence]
- **Eval criteria coverage:** [list IDs green/red/untested vs what was planned]

_Repeat for each slice._

---

## Pipeline instruction gaps

Friction points traced to specific instruction deficiencies. Only cite gaps directly evidenced in the artifacts — no speculation.

- **Gap 1** — [what went wrong] → root: [which pipeline doc / section / instruction was unclear or missing] → evidence: [handoff §N, review.md line, deviation entry]
- **Gap 2** — …

_Write "none identified" if signals were all at target._

---

## Hallucination-traps candidates

Micro-research corrections that revealed a confirmed wrong-pattern/right-pattern pair. Each is a candidate row for `specs/research/hallucination-traps.md`.

| Wrong pattern | Right pattern | Source | Library/version |
|---|---|---|---|
| | | [handoff path] | |

_Write "none" if no micro-research corrections this run._

---

## Suggested pipeline doc changes

Concrete, actionable suggestions. One suggestion per identified gap. Ordered by expected impact (highest first).

1. **File:** `[pipeline/XX-name.md or agents/name.md]`
   **Section:** [section heading]
   **Change:** [1-3 sentences describing exactly what to add, remove, or rewrite]
   **Confidence:** high / medium / low
   **Evidence:** [what in the run supports this]

2. …

---

## Trend

_Requires ≥ 2 prior critiques in `PIPELINE_IMPROVEMENT_CRITIQUE/`._

| Signal | [prior feature] | This run | Direction |
|---|---|---|---|
| Block reviews | — | — | ↓ / → / ↑ |
| Micro-research escapes | — | — | |
| Step-spec deviations | — | — | |

[1 sentence interpreting the trend. If flat or rising after a fix was applied, note "fix may be at the wrong level — check one stage up."]
