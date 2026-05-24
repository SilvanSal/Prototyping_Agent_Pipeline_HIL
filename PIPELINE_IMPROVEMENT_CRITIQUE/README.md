# Pipeline Improvement Critiques

One file per feature, written by the Pipeline-Critic agent after all slices in a feature are complete. This is Stage 10 of the pipeline.

## Purpose

These critiques close the improvement loop. Each pipeline run produces evidence — block reviews, agent deviations, micro-research escapes, error-registry entries — about where instructions were unclear. The Pipeline-Critic synthesises that evidence into concrete, file-level suggestions for improving the pipeline docs.

Read this folder after every shipped feature. Apply the top suggestions. Over time the quality signals trend down; that is the loop converging.

## File naming

`[feature-slug]-[YYYY-MM-DD].md`

## Quality signal baseline targets

| Signal | Target | What it measures |
|---|---|---|
| Block reviews | 0 per feature | Coder produced something the reviewer had to reject |
| Pass-with-notes reviews | ≤ 1 per slice | Reviewer found issues but not blockers |
| Micro-research escapes | ≤ 1 per feature | knowledge.md was incomplete or stale |
| Step-spec deviations | ≤ 1 per feature | Coder had to go outside the planned file list |
| Error-registry entries | ≤ 1 per feature | Non-trivial bugs hit during implementation |

A feature that hits all targets consistently means the pipeline is well-calibrated for that type of work. A spike in any signal points to a specific pipeline instruction to fix.

## How to apply a critique

1. Read the "Suggested pipeline doc changes" section.
2. Apply the highest-confidence suggestions directly to the relevant `pipeline/` or `agents/` file.
3. Commit with message: `fix(pipeline): [what changed] — informed by [feature]-critique`.
4. On the next feature run, check whether the relevant signal dropped.

## Trend tracking

The Pipeline-Critic compares quality signals across all prior critiques in this folder. Once you have three or more critiques, the trend section becomes meaningful. A flat or rising trend after applying suggestions means the fix was at the wrong level — check one stage up in the pipeline.
