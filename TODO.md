# Pipeline Improvement TODO

Three parts: (A) new intake + early architecture flow, (B) four concrete structural fixes,
(C) smaller compliance and reliability improvements.

Items are ordered by dependency — do earlier items before later ones within each section.

---

## Part A — New Intake & Early Architecture Flow

The pipeline currently starts from scratch on each project with no mechanism for the user
to feed in prior work (papers, briefs, wireframes, competitor analysis). It also has no
high-level milestone planning layer between architecture and slice execution. This section
adds both.

The revised stage sequence becomes:

```
00  Constitution
00.5 Intake Reader + Early Clarification   ← NEW
01  Domain Research (now grounded in input folder)
02  Codebase Discovery
03  Clarify (retained, now narrower in scope)
04  Requirements + Design
04.3 Architect Deep-Dive Q&A               ← NEW (optional gate within stage 04)
04.5 Phase Planning                         ← NEW
05  Slice Planning (within a single phase)
06–09 per-slice loop (unchanged)
```

---

### A1 — Define the `input/` folder contract

**What to do**

- Add an `input/` folder to this pipeline repo (not the target project) as the canonical
  location for user-supplied materials. Bootstrap copies it as an empty folder with a
  README to the target project root.

- Write `input/README.md` (in the pipeline repo, copied at bootstrap) explaining:
  - Accepted file types: `.pdf`, `.md`, `.txt`, `.docx`, `.png`/`.jpg` (wireframes), `.yaml`/`.json` (OpenAPI specs), `.zip` (existing codebase references)
  - Recommended sub-folders: `papers/`, `briefs/`, `wireframes/`, `specs-raw/`, `competitive/`
  - What NOT to put there: secrets, credentials, large binaries unrelated to the project brief
  - The folder is read by Stage 00.5 and Stage 01; the user may add files at any time before Stage 04

- Update `bootstrap/generate-claude-scaffolding.md`:
  - Add step to create `input/` and copy `input/README.md` from pipeline repo into target project
  - Add `Read(input/**)` to the orchestrator's allowed reads in the generated `settings.json`
  - Add `Write(input/research-findings/*.md)` as allowed for the domain-researcher agent

**Files to create**
- `input/README.md` (pipeline repo; copied to target project at bootstrap)

**Files to modify**
- `bootstrap/generate-claude-scaffolding.md` — add input/ creation step and permissions

**Done when**
- Bootstrap creates `input/` with `README.md` in target project
- `settings.json` allows `Read(input/**)` for orchestrator and agents that need it
- Folder structure documented for the user

---

### A2 — New Stage 00.5: Intake Reader + Early Clarification

**What to do**

This is the first agent the user interacts with after constitution. It reads everything in
`input/`, synthesizes a structured brief, then asks the user 5–10 questions that surface
non-obvious ambiguities — things that would send the architecture in different directions
but are not stated in the input materials.

**Create `pipeline/00.5-intake-reader.md`** with the following logic:

1. Read all files in `input/**` (PDFs with pdf skill, images as visual references).
2. Produce a synthesis with these sections:
   - **Problem statement** (1 paragraph, grounded in the user's own words from the materials)
   - **Stated constraints** (explicit requirements from the materials: tech choices, compliance, deadlines)
   - **Implied user types** (personas inferred from the materials — flag as inferred, not stated)
   - **Referenced prior art** (papers, products, APIs explicitly cited in the materials)
   - **Identified conflicts** (places where two input documents contradict each other)
   - **Unstated assumptions** (things the materials seem to assume without stating)
3. Generate 5–10 questions. Rules for questions:
   - Each question targets a gap that would materially change the architecture, scope, or user model
   - Do not ask about things the materials already answer clearly
   - Do not ask about implementation details (that's Stage 06)
   - Each question has 4–5 labeled options (A/B/C/D/E); one option is marked "(recommended)" with a one-line rationale
   - Questions are ordered: most architecturally consequential first
   - Maximum one question per topic area (no two questions about scalability, no two about auth)
4. Wait for user answers. If the user selects an option and adds free-text qualifications, record both.
5. Do not proceed to Stage 01 until all questions are answered.
6. Output `specs/intake-brief.md` and `specs/intake-qa.md`.

**Create `agents/intake-reader.md`** as the subagent definition:
- Role: synthesize input materials, surface non-obvious ambiguities, record user decisions
- Read access: `input/**`, `specs/constitution.md`
- Write access: `specs/intake-brief.md`, `specs/intake-qa.md`
- No write access to application code, tech-stack, or any spec under `specs/[feature]/`
- Model: sonnet (this is mostly reading and synthesis, not deep reasoning)

**Create `skills/intake-reader/SKILL.md`** following the existing skill pattern.

**Update `00-START-HERE.md`**:
- Add Stage 00.5 to the stage sequence table
- Dispatch intake-reader with read list: `input/**`, `specs/constitution.md`
- Gate: do not dispatch Stage 01 until `specs/intake-brief.md` and `specs/intake-qa.md` exist

**Update `README.md`** (root): add Stage 00.5 to the pipeline overview.

**Update read-access matrix** (in `README.md`):
- Add `intake-reader` row: reads `input/**` and `constitution`; writes `intake-brief.md` and `intake-qa.md`

**Files to create**
- `pipeline/00.5-intake-reader.md`
- `agents/intake-reader.md`
- `skills/intake-reader/SKILL.md`

**Files to modify**
- `00-START-HERE.md` — add stage 00.5 to sequence, gate, dispatch instructions
- `README.md` — update stage table and read-access matrix
- `bootstrap/generate-claude-scaffolding.md` — add intake-reader agent to copy list

**Done when**
- Orchestrator dispatches intake-reader after constitution, before domain research
- `specs/intake-brief.md` and `specs/intake-qa.md` are gated outputs
- Stage 01 cannot begin without both files present

---

### A3 — Enhance Stage 01: Grounded Domain Research

**What to do**

Currently the domain-researcher does generic problem surveying. Now it must use
`specs/intake-brief.md` and `specs/intake-qa.md` as the research agenda, so internet
research is targeted at what the user's materials raised, not a generic domain scan.

**Update `pipeline/01-research-domain.md`**:
1. Add a "read first" step: read `specs/intake-brief.md` and `specs/intake-qa.md` before
   forming any research queries.
2. Derive the research agenda from:
   - Papers referenced in `input/` (fetch their abstracts or full text if available)
   - Competitors or products named in the intake brief
   - Technologies referenced (look for known failure modes, migration guides, version pitfalls)
   - Conflicts identified in the intake synthesis (research which side is correct)
   - Unstated assumptions (research whether they hold in the target domain)
3. Newly discovered insights must be saved as dated markdown files in `input/research-findings/`
   (e.g., `input/research-findings/2026-04-30-competitor-X-analysis.md`). This is in addition
   to `specs/research/domain.md` (which remains for the pipeline's internal use).
   Rationale: the user asked that the input folder accumulate insights across the whole process,
   not just hold initial materials.
4. If an input document is a PDF paper, fetch the full text (use pdf skill) and extract:
   methods, conclusions, limitations, and any cited datasets or benchmarks — these go into
   `specs/research/domain.md` under a "From user-supplied papers" section.

**Update `agents/domain-researcher.md`**:
- Add `specs/intake-brief.md` and `specs/intake-qa.md` to read list
- Add `Write(input/research-findings/*.md)` to write permissions

**Update `README.md`** read-access matrix:
- Domain-researcher row: add reads for `intake-brief.md` and `intake-qa.md`; add write for `input/research-findings/*.md`

**Files to modify**
- `pipeline/01-research-domain.md`
- `agents/domain-researcher.md`
- `README.md` (read-access matrix row)

**Done when**
- Domain researcher reads intake artifacts before forming its research agenda
- `input/research-findings/` is populated with dated insight files after Stage 01
- Research queries are traceable to specific gaps identified in intake-brief.md

---

### A4 — Enhance Stage 04: Architect Deep-Dive with Optional Q&A Gate

**What to do**

The architect currently fills in a design template. It should also engage in deeper
architectural reasoning — enumerating and rejecting alternatives before committing — and
have an optional gate to ask the user clarifying questions when architectural decisions
genuinely hinge on user intent rather than known tradeoffs.

**Update `pipeline/04-requirements-design.md`**:

1. Add to the architect's read list: `input/**`, `specs/intake-brief.md`, `specs/intake-qa.md`.
   The architect must read the user's raw materials, not just the domain-researcher's summary.
2. Before writing `design.md`, the architect must enumerate at least **3 candidate architectures**
   with explicit tradeoffs (latency, cost, operational complexity, team skill fit, scalability ceiling).
   It then picks one and documents why the others were rejected. These go in `design.md` under a
   new "Architecture candidates considered" section before the final architecture section.
3. Define an optional **Architect Q&A gate** (Stage 04.3):
   - Trigger condition: the architect identifies ≥1 architectural decision where the right answer
     depends on user intent or business constraints not answerable by research (e.g., "sync vs async
     processing — depends on whether user tolerance for latency is <1s or <10s").
   - If triggered: pause, output up to **3 questions** in A/B/C/D format (4–5 options, one
     "(recommended)" with rationale). Wait for answers before writing `design.md`.
   - If not triggered: proceed directly to design.
   - Hard limits: max 3 questions total, architectural scope only (not feature scope, not UX preferences).
     If the architect wants to ask more than 3, it must pick the 3 that have the highest impact on
     architecture and defer the rest.
   - Record answers in `specs/[feature]/architect-qa.md`.
4. Update `design.md` template to include "Architecture candidates considered" section.

**Update `agents/architect.md`**:
- Add `input/**`, `specs/intake-brief.md`, `specs/intake-qa.md` to read list
- Add `Write(specs/[feature]/architect-qa.md)` to write permissions

**Update `README.md`** read-access matrix:
- Architect row: add reads for `input/**`, `intake-brief.md`, `intake-qa.md`
- Add `architect-qa.md` as a conditional output

**Update `templates/design.md`**:
- Add "Architecture candidates considered" section before the final architecture section
- Each candidate: name, 2-sentence description, pros, cons, reason rejected/selected

**Files to modify**
- `pipeline/04-requirements-design.md`
- `agents/architect.md`
- `templates/design.md`
- `README.md` (read-access matrix)

**Done when**
- Architect reads intake artifacts
- `design.md` always contains at least 3 candidate architectures with rejection rationale
- Architect Q&A gate fires only when user-intent-dependent decisions exist
- `architect-qa.md` exists if and only if the gate fired

---

### A5 — New Stage 04.5: Phase Planning

**What to do**

Phase planning sits between architecture (04) and slice planning (05). It answers: "what are
the milestone releases that deliver user value incrementally?" — distinct from slice planning,
which answers "what are the vertical slices within this phase?" Phases are user-visible
milestones (MVP, v1.0, v1.1, v2.0 etc.); slices are implementation chunks within a phase.

**Create `pipeline/04.5-phase-planning.md`** with the following logic:

1. Read `specs/[feature]/requirements.md`, `specs/[feature]/design.md`, and `specs/intake-qa.md`.
2. Produce `specs/[feature]/phase-plan.md`. Rules for phase plan:
   - 2–5 phases minimum; more only if the requirements genuinely span multiple major releases
   - Each phase must be user-visible and independently shippable (no "internal-only" phases)
   - Each phase: ID, name, 1-sentence user-outcome, subset of requirements IDs it satisfies,
     acceptance criteria (how a user/stakeholder would verify it shipped), estimated slice count
     (rough: S=1–2, M=3–5, L=6–8), dependencies on prior phases
   - Phases are ordered: highest user value with fewest dependencies first
   - Phase 1 must be an MVP: the smallest thing that delivers the core user value from the requirements
   - Features deferred to later phases must be explicitly listed as "not in Phase N" — no implicit deferral
3. Present the phase plan to the user. The user must:
   - Approve the full plan, OR
   - Reject with specific changes (phase-planner revises and re-presents), OR
   - Approve Phase 1 and mark the rest as "TBD" (valid choice for uncertain roadmaps)
4. After approval, the user selects which phase to build now.
5. Stage 05 (Slice Planning) operates within the selected phase only, satisfying only that
   phase's requirements subset and acceptance criteria.

**Create `agents/phase-planner.md`**:
- Role: decompose requirements into user-visible milestone phases; present for approval
- Read access: `specs/[feature]/requirements.md`, `specs/[feature]/design.md`,
  `specs/intake-qa.md`, `specs/constitution.md`
- Write access: `specs/[feature]/phase-plan.md`
- No write access to slice-plan, requirements, design, or application code

**Create `skills/phase-planning/SKILL.md`** following existing skill pattern.

**Create `templates/phase-plan.md`** with the template structure:
- Header: feature name, date, phase-planner agent version
- Phase table: columns = ID, Name, User outcome, Requirements satisfied, Acceptance criteria,
  Est. slice count, Depends on
- "Not in scope for any phase" section: requirements explicitly deferred to future work
- User approval record: date, approved-by (user), selected phase for this run

**Update `pipeline/05-plan-slices.md`**:
- Add "Read `specs/[feature]/phase-plan.md` first" as the opening step
- Slice planner targets only the selected phase's requirements subset
- Each slice in `slice-plan.md` must reference at least one requirement from the active phase
- Slices that would satisfy requirements from a *different* phase are out of scope

**Update `00-START-HERE.md`**:
- Add Stage 04.5 to the stage sequence
- Gate: do not dispatch Slice-Planner until `specs/[feature]/phase-plan.md` exists and user has
  selected a phase

**Update `README.md`**:
- Add Phase-Planner row to read-access matrix
- Update the artifact tree to include `phase-plan.md`

**Update `bootstrap/generate-claude-scaffolding.md`**:
- Add `phase-planner` to the agent copy list

**Files to create**
- `pipeline/04.5-phase-planning.md`
- `agents/phase-planner.md`
- `skills/phase-planning/SKILL.md`
- `templates/phase-plan.md`

**Files to modify**
- `pipeline/05-plan-slices.md` — add phase-plan read, scope restriction
- `00-START-HERE.md` — add stage 04.5 to sequence and gate
- `README.md` — read-access matrix, artifact tree
- `bootstrap/generate-claude-scaffolding.md` — add phase-planner to copy list

**Done when**
- Phase-planner produces `phase-plan.md` after architecture, before slice planning
- Slice planner reads phase-plan and restricts its output to the selected phase's requirements
- User explicitly approves the phase plan and selects a phase before Stage 05 begins
- `templates/phase-plan.md` exists as a fill-from-skeleton template

---

### A6 — Update Artifact Tree and Stage Numbering

**What to do**

The new stages shift every reference to "stages 00–09" throughout the pipeline docs.
Also, `specs/` grows two new top-level files and one new per-feature file.

**Update `README.md`**:
- Stage sequence table: insert 00.5 (intake-reader) and 04.5 (phase-planner)
- Artifact tree: add `specs/intake-brief.md`, `specs/intake-qa.md`,
  `input/research-findings/`, `specs/[feature]/architect-qa.md` (conditional),
  `specs/[feature]/phase-plan.md`

**Update `00-START-HERE.md`**:
- Reorder the dispatch sequence to reflect 00 → 00.5 → 01 → 02 → 03 → 04 → (04.3) → 04.5 → 05 → 06–09 loop
- Add "check for `specs/intake-brief.md`" to the pre-flight checklist at session start

**Update `pipeline/README.md`**:
- List all pipeline stages including new ones

**Files to modify**
- `README.md`
- `00-START-HERE.md`
- `pipeline/README.md`

**Done when**
- All stage references are consistent across docs
- The artifact tree in README reflects every file the pipeline produces

---

## Part B — Four Concrete Structural Fixes

These are independent of Part A and can be done in parallel with it.

---

### B1 — Fix Stage 08: Actually Parallel Reviewers

**Problem**

Stage 08 says "run Code-Reviewer and Security-Reviewer in parallel" but gives no instruction
for how. Without explicit fork-join wiring, any orchestrator will run them serially. Serial
review doubles the token cost of review and misses the architectural point (independent
verification means neither reviewer can be influenced by the other's verdict).

**What to do**

**Update `pipeline/08-review.md`**:

Replace the current dispatch instruction with explicit fork-join steps:

```
1. Write `.claude/.state/current-stage` = "code-reviewer"
2. Dispatch code-reviewer agent with run_in_background: true. Assign it the name "code-review-agent".
3. Write `.claude/.state/current-stage` = "security-reviewer"
4. Dispatch security-reviewer agent with run_in_background: true. Assign it the name "security-review-agent".
5. Await completion of both agents (SendMessage or Monitor — do not poll; wait for both Done signals).
6. Collect both outputs. Aggregate into `specs/[feature]/slices/[N]/review.md`:
   - Section 1: Code Review verdict (pass / pass-with-notes / block) + findings
   - Section 2: Security Review verdict (pass / pass-with-notes / block) + findings
   - Section 3: Aggregate verdict (most severe of the two wins)
7. If either verdict is "block": stop. Surface to user with specific blocking findings.
   Do not proceed to Stage 09 until the block is resolved and review is re-run.
```

**Update `agents/code-reviewer.md`** and **`agents/security-reviewer.md`**:
- Both agents must write their individual outputs to separate files first:
  `specs/[feature]/slices/[N]/review-code.md` and `specs/[feature]/slices/[N]/review-security.md`
- The orchestrator aggregates these into the single `review.md` after both complete

**Update `skills/review/SKILL.md`**:
- Document the fork-join pattern explicitly
- Add the stop condition: aggregate verdict "block" halts the pipeline

**Done when**
- Code-Reviewer and Security-Reviewer are dispatched with `run_in_background: true` in sequence
- Orchestrator waits for both before aggregating
- Neither reviewer can read the other's output (they write to separate files; aggregation is done by orchestrator after both finish)
- "Block" verdict halts Stage 09

---

### B2 — Add Test Execution Gate Before Stage 08

**Problem**

The pipeline names tests in eval-spec and has the Coder implement them, but there is no
stage that actually runs the test suite and blocks on red. The Code-Reviewer checking
"named test signatures match" is much weaker than a green CI gate. A Coder can write
tests that satisfy the naming convention but are broken.

**What to do**

**Add a test-execution step to `pipeline/07-execute-step.md`**:

After the final sub-task commit and before the deviation log, add:

```
Post-implementation gate:
1. Run the project's test suite (command from tech-stack.md, e.g., `pytest`, `npm test`, `cargo test`).
2. If any test in the current slice's scope fails: DO NOT proceed to Stage 08.
   Fix the failure, add it to the deviation log, commit the fix, re-run tests.
3. Capture test output: pass count, fail count, total time.
   Write a one-section summary to `specs/[feature]/slices/[N]/test-run.md`:
   - Command run
   - Pass / fail / skip counts
   - Names of any tests that were skipped (with reason)
   - Duration
   - Commit SHA at time of test run
4. If the test suite command itself errors (e.g., missing dependency, import error):
   this is a halt condition — fix the environment issue before proceeding.
```

**Update `pipeline/08-review.md`**:
- Add to Code-Reviewer's read list: `specs/[feature]/slices/[N]/test-run.md`
- Code-Reviewer must include a "Test coverage" section in `review-code.md`:
  - Were all named test signatures from eval-spec present in the test output?
  - Were any eval-spec criteria left untested?
  - Pass rate

**Update `agents/code-reviewer.md`**:
- Add `specs/[feature]/slices/[N]/test-run.md` to read list
- Add "Test coverage" section to the review output format

**Update `templates/` — create `templates/test-run.md`**:
- Template for the test run summary file

**Update `bootstrap/generate-claude-scaffolding.md`**:
- Add `Bash(pytest*) allow`, `Bash(npm test*) allow`, `Bash(cargo test*) allow` to generated `settings.json`
  (currently these are in the "ask" bucket — test running should be automatic after each sub-task)

**Update `README.md`** artifact tree:
- Add `specs/[feature]/slices/[N]/test-run.md` as an output of Stage 07

**Done when**
- Coder runs test suite after final sub-task; red tests halt the pipeline
- `test-run.md` exists before Stage 08 begins
- Code-Reviewer reads `test-run.md` and includes a test-coverage section in its verdict
- Test commands are in the `allow` bucket in `settings.json` (not `ask`)

---

### B3 — Fix knowledge.md Staleness: Version-Based, Not Time-Based

**Problem**

The current 90-day freshness threshold is arbitrary. A 91-day-old entry for a stable
library (e.g., PostgreSQL) is perfectly valid. A 3-day-old entry for a fast-moving library
(e.g., a new AI SDK in active beta) can already be wrong. Time is the wrong axis; library
version is the right axis.

**What to do**

**Update `templates/knowledge.md`**:

Add two metadata fields per library/API entry:

```markdown
## [Library Name]
- **pinned-version**: x.y.z          ← exact version from tech-stack.md at time of research
- **last-verified**: YYYY-MM-DD      ← date this entry was written or last confirmed
- **version-source**: tech-stack.md  ← where the version came from
```

**Update `pipeline/06-research-step.md`** — dedup logic:

Replace the current "< 90 days" staleness check with:

```
For each library this slice touches:
1. Look up the library's pinned version in tech-stack.md.
2. Grep any prior knowledge.md entries for that library.
3. If a prior entry exists:
   a. Compare prior entry's `pinned-version` field to tech-stack.md's current version.
   b. If versions match → entry is current. Add a `See also:` pointer. Skip re-research.
   c. If versions differ → entry is stale. Research fresh. Flag the stale entry with:
      "STALE: tech-stack.md now pins [new version]; this entry was written for [old version]."
      Do NOT delete the stale entry — the Coder may still need to understand what changed.
4. If no prior entry exists → research fresh.
5. When researching fresh for a library with a stale entry, explicitly look for:
   - Migration guides from [old version] to [new version]
   - Breaking changes in the changelog between the two versions
   - Any known regressions introduced in the new version
```

**Update `agents/step-researcher.md`**:
- Replace "< 90 days freshness" language with "version match against tech-stack.md" language
- Add instructions to flag stale entries without deleting them

**Done when**
- `knowledge.md` template has `pinned-version` and `last-verified` fields per library entry
- Step-Researcher compares versions against tech-stack.md, not timestamps
- Stale entries are flagged in place with the old version noted; not silently overwritten
- Fresh research on version-bumped libraries explicitly seeks changelog and migration content

---

### B4 — Fix Bootstrap: Version Tracking and Update Path

**Problem**

Bootstrap copies skills and agents into target projects once. When this pipeline repo
improves — new agents, better instructions, bug fixes — there is no mechanism to propagate
those improvements to existing target projects. Every project is a frozen snapshot fork.

**What to do**

**Add `pipeline-version` to the generated `settings.json`**:

```json
{
  "pipeline-version": "0.1.0",
  "pipeline-repo": "path/to/Agentic_Coding_Pipeline",
  ...
}
```

**Create `CHANGELOG.md`** in this pipeline repo:
- Follows Keep a Changelog format
- Every meaningful change to an agent, skill, hook, or pipeline stage gets an entry
- Entries include: which files changed, what behavior changed, whether target projects
  should update (yes/no/optional)
- Versioning: semver. Breaking changes (changed hook behavior, changed output file names,
  changed read-access matrix) = minor bump. New stages = minor bump. Bug fixes = patch.

**Create `bootstrap/update-pipeline.md`** with update instructions:

```
When the pipeline repo is at version X.Y.Z and a target project's settings.json
shows pipeline-version A.B.C (where A.B.C < X.Y.Z):

1. Consult CHANGELOG.md for all versions between A.B.C and X.Y.Z.
2. Identify files marked as "update recommended" or "breaking change."
3. For each such file in the target project's .claude/:
   a. If the file is unmodified since bootstrap (compare to pipeline repo version):
      overwrite with the new version.
   b. If the file has been modified by the user or a pipeline run:
      diff the pipeline repo's new version against the target project's version.
      Present the diff to the user and ask them to merge manually.
4. Update `pipeline-version` in `settings.json` to the new version.
5. Do not update tech-stack.md, code-style.md, best-practices.md, or any `specs/**` file —
   these are project-owned and must never be overwritten by a pipeline update.
```

**Add a version-check to `00-START-HERE.md`**:
- At the start of every new feature (not every slice), check `settings.json`'s `pipeline-version`
  against this pipeline repo's current version.
- If behind: surface a one-line warning: "Pipeline version [A.B.C] in this project; repo is
  at [X.Y.Z]. Run bootstrap/update-pipeline.md to review changes. Proceeding with current version."
- Do not block; warn only. The user decides whether to update.

**Add "pipeline owned" comments to agent and skill files** (in this pipeline repo):
- Top of each file: `<!-- pipeline-owned: do not edit in target project; use update-pipeline.md to upgrade -->`
- This is metadata for human readers and for the update script's diff logic

**Files to create**
- `CHANGELOG.md`
- `bootstrap/update-pipeline.md`

**Files to modify**
- `bootstrap/generate-claude-scaffolding.md` — add `pipeline-version` to generated `settings.json`
- `00-START-HERE.md` — add version-check at new-feature start
- All files in `agents/` and `skills/` — add pipeline-owned comment header

**Done when**
- Generated `settings.json` contains `pipeline-version`
- `CHANGELOG.md` exists and has a v0.1.0 entry covering the current baseline
- `update-pipeline.md` documents the manual update process clearly
- Version check fires at the start of each new feature run

---

## Part C — Compliance and Reliability Improvements

These are smaller but load-bearing. Most take less than an hour each.

---

### C1 — Stage-Output Gating: Dead Man's Switch Per Stage

**Problem**

The orchestrator is instructed to "check for named output files before advancing." In
practice, an LLM orchestrator will advance anyway if it thinks the stage was "basically
done" — it pattern-matches success rather than verifying file existence. This is how
pipeline stages silently fail.

**What to do**

**Update `00-START-HERE.md`** — add a mandatory verification step after every stage dispatch:

```
After each subagent returns:
1. Check the filesystem for the stage's required output file(s).
2. If any required output is missing: DO NOT advance to the next stage.
   Output: "Stage [N] incomplete: expected [file] does not exist. Re-run the stage."
3. If outputs exist but are empty (0 bytes or only the template header): treat as missing.
4. Only after all required outputs are verified present and non-empty: write the next
   stage marker and proceed.
```

Add a table to `00-START-HERE.md` mapping each stage to its required output files:

| Stage | Required outputs before advancing |
|-------|----------------------------------|
| 00    | `specs/constitution.md` |
| 00.5  | `specs/intake-brief.md`, `specs/intake-qa.md` |
| 01    | `specs/research/domain.md`, `specs/error-registry.md` |
| 02    | `CLAUDE.md`, `tech-stack.md`, `code-style.md`, `best-practices.md` |
| 03    | `specs/clarify-[feature].md` |
| 04    | `specs/[feature]/requirements.md`, `specs/[feature]/design.md`, `specs/[feature]/eval-spec.md` |
| 04.5  | `specs/[feature]/phase-plan.md` |
| 05    | `specs/[feature]/slice-plan.md` |
| 06    | `specs/[feature]/slices/[N]/step-spec.md`, `specs/[feature]/slices/[N]/knowledge.md` |
| 07    | `specs/[feature]/slices/[N]/test-run.md` + committed code |
| 08    | `specs/[feature]/slices/[N]/review-code.md`, `specs/[feature]/slices/[N]/review-security.md`, `specs/[feature]/slices/[N]/review.md` |
| 09    | `specs/[feature]/slices/[N]/handoff.md` |

**Done when**
- Table exists in `00-START-HERE.md`
- Orchestrator instructions say "check filesystem, not LLM recall" for each gate
- The "treat empty file as missing" rule is explicit

---

### C2 — Drift Check: Make File Tracking Deterministic

**Problem**

Stage 05.5 (pre-slice drift check) asks the orchestrator to detect changes "outside the
last slice's declared file list." The orchestrator is expected to remember what the Coder
touched from the prior slice's step-spec. This is unreliable — across session boundaries,
the orchestrator has no memory of prior sessions.

**What to do**

**Update `pipeline/07-execute-step.md`**:
- After each sub-task commit, the Coder appends the list of files modified in that sub-task
  to `specs/[feature]/slices/[N]/touched-files.txt` (one file path per line).
- Format: `[SHA] [file-path]` — one entry per file per commit.
- This file is the authoritative record of what Stage 07 touched. It is NOT part of the
  application codebase; it is a pipeline artifact in `specs/`.

**Update `pipeline/05.5-drift-check`** (or the drift-check section within `00-START-HERE.md`):
- Replace "orchestrator checks its memory" with:
  1. Read `specs/[feature]/slices/[N-1]/touched-files.txt` (prior slice's touched file list).
  2. Run `git diff --name-only HEAD~[K]` where K = number of commits since prior slice's final commit.
  3. Compute: files changed in git that are NOT in `touched-files.txt`.
  4. If any such files exist: surface them to the user with the drift-check options
     (absorb / ignore / revert).
- This makes the drift check deterministic and independent of the orchestrator's memory.

**Done when**
- Coder writes `touched-files.txt` after each sub-task commit (in `specs/` not in app code)
- Drift check reads `touched-files.txt` and diffs against `git diff --name-only`
- No reliance on orchestrator memory for drift detection

---

### C3 — Session Continuity: Re-Entry Checklist and Session Log

**Problem**

The orchestrator auto-advances between slices, but if context overflow forces a manual
session restart, there is no machine-readable record of where the pipeline is in a
multi-slice, multi-phase feature. A user returning after a context-overflow restart may
not know which slice to pick up from, which phase they're in, or whether the last review passed.

**What to do**

**Update `pipeline/09-write-handoff.md`**:
- After writing `handoff.md`, the Handoff-Writer also appends one line to
  `specs/[feature]/session-log.md`:
  ```
  [YYYY-MM-DD] Phase [P] Slice [N] — [status: completed|blocked|partial] — review: [pass|pass-with-notes|block] — handoff: [path]
  ```
- `session-log.md` is a running log of every pipeline session for this feature.

**Create `skills/resume/SKILL.md`** — a `/resume` skill for the orchestrator:
- User invokes `/resume` at the start of a session when picking up a paused pipeline.
- Skill reads: `specs/[feature]/session-log.md`, `specs/[feature]/slice-plan.md`,
  `specs/[feature]/phase-plan.md`, the most recent `slices/[N]/handoff.md`
- Outputs a one-paragraph re-entry briefing: current phase, next slice, last review verdict,
  open blockers from handoff, and the next orchestrator action
- Does not modify any files; read-only

**Update `00-START-HERE.md`**:
- Add a "Session start" pre-flight checklist:
  1. Is `specs/[feature]/session-log.md` present? If yes, read the last entry to determine status.
  2. Is the last slice's `handoff.md` present? If yes, read it before dispatching Stage 06.
  3. Is `specs/[feature]/phase-plan.md` present? If yes, confirm which phase is active.
  4. If any of the above are missing despite earlier stages having run, surface a warning
     before proceeding.

**Files to create**
- `skills/resume/SKILL.md`
- `templates/session-log.md` (one-line-per-entry format, header only)

**Files to modify**
- `pipeline/09-write-handoff.md` — add session-log append step
- `00-START-HERE.md` — add session-start pre-flight checklist

**Done when**
- `session-log.md` is updated by every Stage 09 run
- `/resume` skill reads the log and produces a re-entry briefing
- Orchestrator has a documented pre-flight checklist for session start

---

### C4 — Handoff Word Limit: Scale With Slice Complexity

**Problem**

The 300–500 word cap on `handoff.md` is applied uniformly. A Small slice with 2 sub-tasks
has plenty of room. A Large slice with 8 sub-tasks and several discovered gotchas does not.
A writer forced into 500 words for a complex slice will cut gotchas — exactly the wrong
tradeoff.

**What to do**

**Update `pipeline/09-write-handoff.md`**:

Replace the flat cap with a size-scaled cap:

| Slice size (from slice-plan.md) | Core 7 sections cap | Gotchas + out-of-scope appendix |
|---------------------------------|--------------------|---------------------------------|
| S (1–3 sub-tasks)               | 300 words          | unlimited                       |
| M (4–6 sub-tasks)               | 500 words          | unlimited                       |
| L (7–10 sub-tasks)              | 700 words          | unlimited                       |

Rules:
- The core 7 sections (what shipped, names next depends on, decisions downstream, gotchas
  summary, review notes, out-of-scope discovered, eval state) have the size-scaled cap.
- The "out-of-scope discovered" and "gotchas details" appendix sections have no word limit.
  Better to have a long handoff than a lost gotcha.
- Handoff-Writer must read the slice's size field from `slice-plan.md` before writing.

**Update `agents/handoff-writer.md`**:
- Add "read slice size from slice-plan.md" as the first step
- Add the size-scaled cap table

**Update `templates/handoff.md`**:
- Add explicit section markers for "core sections" vs "appendix"
- Note the size-scaling rule at the top of the template

**Done when**
- Handoff-Writer reads slice size before writing
- L slices are allowed 700 words for core sections + unlimited appendix
- The appendix is structurally separate from the capped core sections

---

### C5 — Error-Registry Schema Validation

**Problem**

The Coder appends entries to `error-registry.md` under time pressure (after a debugging
session). Malformed entries — missing the `root-cause` field, wrong slug format, no
`scope` — silently corrupt the registry and make the Step-Researcher's dedup greps miss
real matches.

**What to do**

**Create `bootstrap/hooks/validate-error-registry.sh`**:

```bash
#!/usr/bin/env bash
# Runs after any Write or Edit on specs/error-registry.md
# Checks that the most recent entry has all required fields
```

Required fields per entry: `slug`, `first-hit` (ISO date), `signature` (grep-able string),
`root-cause`, `fix`, `scope`, `recurrence` (integer).

Hook behavior:
- If all fields present: silent pass
- If any field missing: print warning with specific missing fields; do NOT block the commit
  (blocking would frustrate a Coder in the middle of a debug session — warn only)
- Log the warning to `specs/.registry-warnings.log` with date and entry slug

**Update `templates/error-registry.md`**:
- Add an explicit field checklist at the top as a comment block
- Include a one-line example entry with all fields filled in

**Update `bootstrap/generate-claude-scaffolding.md`**:
- Add `validate-error-registry.sh` to the hooks to copy and configure as a PostToolUse hook
  on `Write` and `Edit` targeting `specs/error-registry.md`
- Add corresponding hook config to generated `settings.json`

**Files to create**
- `bootstrap/hooks/validate-error-registry.sh`

**Files to modify**
- `templates/error-registry.md` — add field checklist and example entry
- `bootstrap/generate-claude-scaffolding.md` — add hook copy and config

**Done when**
- Hook runs after every write to `error-registry.md`
- Missing fields produce a warning in `specs/.registry-warnings.log`
- Hook does NOT block (warn-only)
- Example entry in the template shows all required fields

---

### C6 — Pipeline Self-Documentation: Architecture Decision Records

**Problem**

The pipeline has several non-obvious design choices that are load-bearing — the handoff
word cap, the fresh-context-per-stage rule, the vertical-slices ordering, the
test-names-not-test-files pattern. Without documented rationale, a future maintainer
(or a future you) will remove one of these thinking it's arbitrary, and the pipeline will
silently degrade.

**What to do**

**Create `docs/decisions/` folder** in this pipeline repo.

Write an ADR for each of the following (one file per decision):

1. `docs/decisions/001-fresh-context-per-stage.md` — why each stage runs in a new subagent
   context rather than one long session. (LLM context drift, attention degradation on long
   contexts, preventing cross-contamination of research/design/implementation concerns.)

2. `docs/decisions/002-vertical-slices-not-horizontal-layers.md` — why slices must deliver
   user-visible end-to-end behavior rather than "backend first, frontend second." (Delivery
   risk: horizontal layers delay the moment you discover integration problems. Vertical slices
   expose integration issues in slice 1.)

3. `docs/decisions/003-test-names-not-test-files.md` — why Architect writes test signatures
   and Coder implements them, rather than Architect writing the test files. (The Architect
   should define WHAT to verify, not HOW. Test implementation details belong in the code
   context where the library is known.)

4. `docs/decisions/004-handoff-as-session-boundary.md` — why the handoff is the
   compression boundary between slices. The orchestrator auto-advances (no manual session
   restart), but each slice's Coder starts with fresh context reading only the handoff —
   not the prior slice's full history. (Prevents accumulated context drift across slices.)

5. `docs/decisions/005-error-registry-and-hallucination-traps.md` — why these two files
   exist as separate artifacts rather than being merged, and why the promotion threshold
   (3 recurrences) was chosen.

6. `docs/decisions/006-read-access-matrix.md` — why each agent's read access is explicitly
   restricted rather than "just trust the agent to read only what it needs." (LLMs will read
   available context. If the Coder can see the domain research, it will be influenced by
   framing choices the researcher made. Role isolation requires access isolation.)

ADR format (each file):
```markdown
# ADR [N]: [Title]
**Status**: accepted
**Date**: [date]

## Context
[What problem or constraint motivated this decision]

## Decision
[What was decided]

## Consequences
[What becomes easier, what becomes harder, what is now off-limits]

## What NOT to change
[Specific things that would break the pipeline if removed]
```

**Files to create**
- `docs/decisions/001-fresh-context-per-stage.md`
- `docs/decisions/002-vertical-slices-not-horizontal-layers.md`
- `docs/decisions/003-test-names-not-test-files.md`
- `docs/decisions/004-handoff-as-session-boundary.md`
- `docs/decisions/005-error-registry-and-hallucination-traps.md`
- `docs/decisions/006-read-access-matrix.md`

**Done when**
- All 6 ADRs exist with Status: accepted
- Each ADR has a "What NOT to change" section that explicitly names the invariant it protects
- `README.md` links to `docs/decisions/` from the pipeline overview section

---

## Part D — End-to-End Routing Audit

The pipeline is only as reliable as the precision of its routing. A subagent that
receives an ambiguous dispatch, a missing file reference, or an undefined error path will
hallucinate a reasonable-sounding continuation. This section defines a thorough audit of
every routing decision in the pipeline — stage transitions, agent dispatch instructions,
read/write lists, error branches, conditional gates, and hook trigger conditions.

This is not a one-time check. Re-run this audit after every change to `00-START-HERE.md`,
any agent file, any pipeline stage file, or `README.md`'s read-access matrix.

---

### D1 — Audit: Stage Transition Completeness

**What to audit**

For every stage in the sequence (00, 00.5, 01, 02, 03, 04, 04.3, 04.5, 05, 05.5, 06, 07, 08, 09,
end-of-feature browser verification), verify that `00-START-HERE.md` contains all five of
the following routing elements:

1. **Trigger condition** — what must be true before this stage can run (prior stage outputs
   present, user approval given, specific condition met)
2. **Dispatch instruction** — which agent or action to invoke, with the exact read-list passed
   at dispatch time (not just "read what you need")
3. **Success path** — what the orchestrator does immediately after the stage returns successfully
   (write stage marker, verify outputs, advance to next stage)
4. **Failure / block path** — what the orchestrator does if the stage returns a block verdict,
   missing output, or explicit error (halt, surface to user, re-run options)
5. **Output verification** — the exact file paths the orchestrator checks on the filesystem
   before advancing (not "check that the agent said it was done")

**Go through each stage and mark any element as MISSING, PARTIAL, or PRESENT.**

Known gaps to fix before marking this audit complete:

- **Stage 04.3 (Architect Q&A gate)**: The conditional branch is not yet routed in
  `00-START-HERE.md`. Define: how does the orchestrator know if the gate fired? (The
  architect either produces `architect-qa.md` or it does not — orchestrator checks for the
  file after Stage 04 returns. If present: the Q&A was conducted and answers are in that
  file. If absent: gate did not fire.) Add this as an explicit routing note in
  `pipeline/04-requirements-design.md` and `00-START-HERE.md`.

- **Stage 05.5 (drift check)**: The three user choices (absorb / ignore / revert) each have
  different downstream actions. All three must be spelled out: absorb = re-dispatch
  codebase-explorer (Stage 02) before continuing; ignore = log the decision in
  `specs/[feature]/drift-log.md` and proceed; revert = surface git instructions to user,
  halt until user confirms repo is clean. Currently only partially described.

- **End-of-feature browser verification trigger**: The condition "after the final
  UI-touching slice" is ambiguous — the orchestrator must know in advance which slices touch
  the UI. Define: the slice-planner must tag each slice in `slice-plan.md` with a boolean
  `ui-touching: true/false`. The orchestrator reads this flag after each Stage 09 and fires
  the browser-verifier only after the last slice flagged `ui-touching: true` in the current
  phase. Add this field to `templates/slice-plan.md` and document the trigger in
  `00-START-HERE.md`.

- **Loop termination condition (06–09)**: When does the per-slice loop end? Currently implicit
  ("when all slices in the slice-plan are done"). Make explicit: after each Stage 09, the
  orchestrator reads `slice-plan.md` and checks whether any slice in the active phase has
  status != completed. If all slices are completed: exit loop, proceed to browser verification
  (if applicable) or end-of-phase. The slice-plan template needs a `status` column
  (pending / in-progress / completed / blocked) that the orchestrator updates after each
  handoff.

**Files to modify**
- `00-START-HERE.md` — add all five routing elements per stage; fix the four known gaps above
- `pipeline/04-requirements-design.md` — document the 04.3 conditional branch routing
- `pipeline/05-plan-slices.md` — add `ui-touching` and `status` fields to slices
- `templates/slice-plan.md` — add `ui-touching` boolean and `status` field to the slice table

**Done when**
- Every stage has all five routing elements documented in `00-START-HERE.md`
- No stage's success or failure path says "proceed as appropriate" or uses vague language
- The four known gaps are explicitly resolved

---

### D2 — Audit: Agent Definition vs. Pipeline Stage Consistency

**What to audit**

Each agent in `agents/` has a definition that should exactly match what the corresponding
`pipeline/` stage doc says the agent will do. Drift between these two sources is a common
failure — an agent definition says it reads file X, the pipeline stage says it reads file Y,
and the orchestrator is confused about which to trust.

**For every agent, cross-check these five fields between `agents/[name].md` and
`pipeline/[stage].md`**:

| Field | Check |
|-------|-------|
| Read list | Identical in both files? |
| Write list | Identical in both files? |
| Output file paths | Same exact paths, same naming conventions? |
| Model recommendation | Consistent? |
| Halting / stop conditions | Same in both files? |

**Known inconsistencies to fix:**

- The read-access matrix in `README.md` is a third source of truth that must match both
  `agents/` and `pipeline/`. All three must agree. Currently no mechanism enforces this.
  Add a comment header to each agent file that says:
  `<!-- read-list: [file1, file2, ...] write-list: [file3, ...] — must match pipeline/[N]-[name].md and README.md matrix row -->`
  This makes drift visible at a glance during future edits.

- After Part A work, the following agents will have updated read lists but the matrix in
  `README.md` will lag unless explicitly updated in the same pass:
  `domain-researcher`, `architect`, `intake-reader` (new), `phase-planner` (new).
  The audit must verify all four rows are consistent before marking A3 and A4 done.

- The `handoff-writer` agent currently says it reads `specs/[feature]/slices/[N]/review.md`
  but after B1 changes, review is split into `review-code.md`, `review-security.md`, and
  the aggregated `review.md`. Verify: does handoff-writer need to read all three, or just
  `review.md`? Answer: just `review.md` (the aggregated one). But `review.md` doesn't exist
  until the orchestrator aggregates — make sure the orchestrator writes it before dispatching
  the handoff-writer. Document this sequencing dependency explicitly.

**Files to modify**
- Every file in `agents/` — add the structured comment header with read-list and write-list
- `README.md` — re-verify the matrix after every agent file change
- `pipeline/09-write-handoff.md` — clarify that handoff-writer reads aggregated `review.md`,
  not the individual reviewer files

**Done when**
- Every agent file has the structured comment header
- All three sources (agent file, pipeline stage file, README matrix) agree for every agent
- The `review.md` sequencing dependency for handoff-writer is documented

---

### D3 — Audit: Dispatch Instructions Are Unambiguous and Self-Contained

**What to audit**

Every time `00-START-HERE.md` dispatches a subagent, the dispatch instruction must be
self-contained: a reader who has never seen the pipeline should be able to follow it
without inferring anything. Vague dispatch instructions ("dispatch the architect with the
relevant context") are routing bugs.

**For every dispatch in `00-START-HERE.md`, verify it contains:**

1. **Agent name** — exact name matching an `agents/` file
2. **Explicit read-list** — every file the agent is allowed to read, listed by exact path.
   No "read the specs folder" or "read what it needs."
3. **Token substitutions resolved** — all runtime tokens (`[feature]`, `[N]`, `[phase]`)
   must have an explicit instruction for how the orchestrator fills them in (e.g., "replace
   `[feature]` with the feature slug from `specs/constitution.md`")
4. **Background flag** — whether the agent runs in foreground or background (`run_in_background`)
5. **Completion check** — what the orchestrator looks for to know the agent is done

**Known gaps:**

- Currently no dispatch instruction in `00-START-HERE.md` explains how `[feature]` and `[N]`
  are resolved. The orchestrator is expected to know. Add a "Token resolution" section at
  the top of `00-START-HERE.md`:
  - `[feature]` = the feature slug set by the user at Stage 03, stored in
    `specs/constitution.md` under a "active feature" field. Add this field to the
    constitution template.
  - `[N]` = the current slice number, taken from `specs/[feature]/slice-plan.md`'s next
    pending slice. Add explicit instructions for how the orchestrator determines "next slice."
  - `[phase]` = the phase ID selected by the user at Stage 04.5, stored in
    `specs/[feature]/phase-plan.md` under a "selected phase" field. Add this field to the
    phase-plan template.

- Stage 08's parallel dispatch (after B1) introduces a new routing pattern not currently
  described anywhere in `00-START-HERE.md`. The exact sequence — dispatch code-reviewer
  with background:true, dispatch security-reviewer with background:true, wait for both,
  aggregate — must be written out as numbered steps, not described in prose.

- Stage 06 dispatches the step-researcher with a dedup instruction that references
  "prior slices' knowledge.md files." The dispatch must specify exactly which files:
  `specs/[feature]/slices/1/knowledge.md`, `specs/[feature]/slices/2/knowledge.md`, etc.
  The orchestrator must dynamically build this list from all completed slices before dispatch.
  Add explicit instruction for this.

**Files to modify**
- `00-START-HERE.md` — token resolution section; fill in all five dispatch elements per stage
- `templates/constitution.md` — add "active feature slug" field
- `templates/phase-plan.md` — add "selected phase ID" field (also needed for A5)

**Done when**
- Every dispatch in `00-START-HERE.md` is a numbered list (not prose)
- Token resolution (`[feature]`, `[N]`, `[phase]`) is documented at the top of `00-START-HERE.md`
- No dispatch instruction contains the words "relevant," "appropriate," "as needed," or
  "what it needs" — these are routing bugs masquerading as instructions

---

### D4 — Audit: Hook Trigger Conditions Are Correct and Non-Overlapping

**What to audit**

Five hooks fire based on tool calls and file targets. If two hooks both fire on the same
event, or a hook fires on an event it wasn't intended for, the pipeline will either
double-block or silently fail to enforce a constraint.

**For each hook, verify:**

1. **Trigger event** — which tool (Write, Edit, Read, Bash, Stop) and which file pattern
2. **Intended behavior** — what it checks and what it does on fail
3. **No false positives** — does it fire on legitimate operations it shouldn't block?
4. **No false negatives** — is there a legitimate operation that should trigger it but doesn't?

**Current hooks and known issues:**

| Hook | Trigger | Known issue |
|------|---------|-------------|
| `require-step-spec.sh` | Write/Edit on app code | What counts as "app code"? The pattern must explicitly exclude `specs/**`, `.claude/**`, and `input/**`. If it uses a catch-all pattern, it will block the Coder from writing `touched-files.txt` (which is in `specs/`). |
| `require-plan.sh` | Write on app code | Same exclusion issue as above. Also: does this fire on the first slice before a slice-plan exists, blocking legitimate first-run? Add: if `slice-plan.md` doesn't exist AND `phase-plan.md` doesn't exist, fire. If slice-plan exists, this hook is satisfied. |
| `no-bypass-hooks.sh` | Any Bash command | Checks for `--no-verify` and `--no-gpg-sign`. Also check for `--no-hooks` (a lesser-known bypass). Verify the hook's regex covers all known bypass flags. |
| `restrict-reads.sh` | Read on any file | This is the most complex hook. It reads `.claude/.state/current-stage` and checks the read against the access matrix. Known issue: what happens if `current-stage` file doesn't exist yet (before Stage 00 writes it)? Hook must have a defined fallback — either allow all reads (permissive default) or block all reads (strict default). Document which is chosen and why. |
| `stop-after-handoff.sh` | Stop event | Fires after a session stop to remind the orchestrator. But a Stop event is terminal — the session has already ended. Verify this hook is actually a `PostToolUse` on `Write` targeting `**/handoff.md`, not a `Stop` hook. If it's a Stop hook, it fires too late. |

**For each new hook added in Part C** (`validate-error-registry.sh`):
- Verify trigger pattern: `PostToolUse` on `Write` and `Edit` targeting `specs/error-registry.md`
- Verify it doesn't fire on reads of the file

**Additional check — hook ordering:**

If two hooks have overlapping trigger conditions (e.g., both fire on `Write` to app code),
Claude Code executes them in the order they appear in `settings.json`. Document the intended
execution order and verify it is correct. A hook that blocks should run before a hook that
logs — otherwise the log hook writes a record of an operation that never completed.

**Files to modify**
- `bootstrap/hooks/require-step-spec.sh` — add explicit exclusion for `specs/**`, `.claude/**`, `input/**`
- `bootstrap/hooks/require-plan.sh` — same exclusion; fix first-run edge case
- `bootstrap/hooks/no-bypass-hooks.sh` — add `--no-hooks` to the regex
- `bootstrap/hooks/restrict-reads.sh` — document the fallback behavior when `current-stage` is absent
- `bootstrap/hooks/stop-after-handoff.sh` — verify this is a PostToolUse Write hook, not a Stop hook; fix if wrong
- `bootstrap/generate-claude-scaffolding.md` — document hook execution order in generated `settings.json`

**Done when**
- Every hook has a written spec: trigger event, file pattern, intended behavior, known false
  positive/negative cases, fallback behavior
- The `restrict-reads.sh` fallback is documented and tested
- The `stop-after-handoff.sh` trigger type is verified correct
- Hook execution order in `settings.json` is documented with rationale

---

### D5 — Audit: Read-Access Matrix Is the Single Source of Truth

**What to audit**

The read-access matrix in `README.md` must be the authoritative reference, not a summary.
Currently it is a summary that lags behind agent file updates. This section establishes it
as the canonical source.

**What to do**

**Restructure the read-access matrix** in `README.md` to be exhaustive — not just the
conceptual "this agent roughly reads these things" but every concrete file path, annotated
with the access type:

- `R` = read-only
- `W` = write (create or overwrite)
- `A` = append only
- `G` = grep only (no full read; only used as a search target)
- `RW` = read and may write

The current matrix uses symbols (✓) that don't distinguish between these. After the D2
audit adds structured comment headers to agent files, use those headers as the source of
truth to regenerate the matrix.

**Add a consistency check instruction** to `bootstrap/update-pipeline.md`:
- After any agent file change, re-verify the README matrix row for that agent
- After any pipeline stage file change, re-verify the corresponding agent file's comment header
- The three sources (agent file header, pipeline stage doc, README matrix) must agree before a
  change is considered complete

**Add "last audited" date** to the matrix header in `README.md`. This makes staleness visible.

**Done when**
- Matrix uses R/W/A/G/RW annotations instead of ✓
- Matrix is updated to include all new files from Parts A and B
- Every file path in the matrix exists (no references to files that haven't been created yet)
- "Last audited" date is present in the matrix header
- Consistency check instruction exists in `update-pipeline.md`

---

### D6 — Audit: Every Pipeline Doc Is Self-Explanatory Without Prior Context

**What to audit**

Each pipeline stage document (`pipeline/00-constitution.md` through `pipeline/09-write-handoff.md`,
plus the new ones) and each agent definition (`agents/`) must be fully understandable by
someone who reads only that file, never having seen the rest of the pipeline. This is not
aspirational — it is a hard requirement because each agent runs in a fresh context and
its definition is its only instruction set.

**The test: for each file, ask these questions:**

1. If I am the agent described in this file, do I know exactly what to read before starting?
2. Do I know exactly what to produce and where to write it?
3. Do I know what to do if I hit a blocker (can't find a file, API returns nothing, user
   doesn't answer a question)?
4. Do I know what NOT to do (explicit out-of-scope list)?
5. Do I know when I am done — not "when the work seems complete" but a concrete, checkable
   condition?

**Known failures of self-explanatory clarity:**

- `agents/coder.md`: The micro-research escape hatch says "allowed ONE WebSearch per
  blocker." But what is a blocker? Define it: a blocker is a tool call that returns an
  error (non-2xx, import error, wrong function signature) that contradicts `knowledge.md`,
  not a gap in the Coder's understanding. This distinction must be in the agent file.

- `agents/step-researcher.md`: The dedup instruction says "grep prior knowledge.md files."
  Which ones? The agent has no way to know how many slices have run before it. The dispatch
  instruction must pass the explicit list of prior `knowledge.md` paths (see D3), but the
  agent file must also say: "If no prior knowledge.md paths are provided in your dispatch,
  grep `specs/[feature]/slices/*/knowledge.md`."

- `agents/handoff-writer.md`: Currently says "grounds claims only in artifacts." But which
  artifacts? List them: `diff` (from `git diff HEAD~[K]`), `commits` (from `git log`),
  `test-run.md`, `review.md`, `eval-spec.md`. The handoff-writer must not read any file not
  on this list, especially not `step-spec.md` (it should not re-evaluate whether the
  implementation satisfied the spec — that is the reviewer's job).

- `pipeline/05-plan-slices.md`: Does not say what to do if the feature's requirements
  cannot be decomposed into ≤8 slices without each slice being enormous. Add a halt
  condition: if the slice-planner cannot satisfy the vertical-slice constraint within 8
  slices, it must surface this to the user with three options:
  (A) Reduce scope for this phase, (B) Allow up to 12 slices (user accepts longer cycle),
  (C) Split the phase — deliver Phase 1a and Phase 1b as separate runs.

- `pipeline/08-review.md` (after B1): The aggregation step is done by the orchestrator,
  not a subagent. But `pipeline/08-review.md` describes the reviewer's behavior, not the
  orchestrator's. Move the aggregation instruction to `00-START-HERE.md` where it belongs.
  `pipeline/08-review.md` should describe only what the reviewers do; the orchestrator doc
  describes the fork-join.

**For each agent file and pipeline stage file:**
- Read it with the "fresh context" test above
- Mark any question (1–5) that is not answered clearly
- Add the missing answer directly into the file — not as a footnote, not as a reference
  to another doc, but inline where the agent will encounter the gap

**Files to modify**
- `agents/coder.md` — define "blocker" explicitly
- `agents/step-researcher.md` — add fallback for missing dispatch-provided knowledge list
- `agents/handoff-writer.md` — list exact source artifacts; prohibit reading step-spec
- `pipeline/05-plan-slices.md` — add >8 slices halt condition with three user options
- `pipeline/08-review.md` — move aggregation instruction to `00-START-HERE.md`
- All other agent and pipeline stage files — apply the 5-question test and fill gaps

**Done when**
- Every agent file passes the 5-question self-explanatory test
- No agent file says "see the pipeline documentation" or "as described elsewhere"
- No ambiguous terms (blocker, relevant, appropriate, as needed) remain in any agent file
- The >8 slices edge case is handled in slice-planner

---

### D7 — Audit: All File Path References Are Verified Correct

**What to audit**

Every file path mentioned in every pipeline document, agent definition, skill file, and
template must refer to a real path that either exists now (in the pipeline repo) or will
exist at the point in the pipeline when it is referenced (because a prior stage produces it).
A single typo in a file path makes a stage silently read nothing or write to the wrong location.

**Method:**

1. Extract every file path string from every `.md` file in the repo (grep for `specs/`,
   `input/`, `.claude/`, `agents/`, `skills/`, `templates/`).
2. For each path, determine one of:
   - **Pipeline repo static** — exists in this repo right now (check with `ls`)
   - **Generated at bootstrap** — produced by `bootstrap/generate-claude-scaffolding.md`
     (verify it is listed in the bootstrap doc)
   - **Runtime artifact** — produced by a pipeline stage at runtime (verify which stage
     produces it and that it is produced before first referenced)
   - **ORPHAN** — referenced but not produced by anything; this is a bug
3. For runtime artifacts: verify the producing stage and the consuming stage agree on the
   exact path, including capitalization, slashes, and extension.

**Known path inconsistencies to fix:**

- `specs/research/hallucination-traps.md` vs `specs/research/hallucination-traps.md` —
  verify this path is consistent across all references (some pipeline docs may use
  `specs/hallucination-traps.md` without the `research/` subdirectory).

- After Part A, `input/research-findings/` is written by `domain-researcher` but the
  exact path template for individual files is `input/research-findings/YYYY-MM-DD-[slug].md`.
  Verify this naming convention is stated in both `pipeline/01-research-domain.md` and
  `agents/domain-researcher.md`.

- `specs/[feature]/slices/[N]/` — the `[N]` token is used with and without leading zeros
  in different files (e.g., `slices/1/` vs `slices/01/`). Pick one convention and enforce
  it everywhere. Recommendation: no leading zeros (simpler glob patterns).

- Template files in `templates/` — verify each template is referenced by name in its
  corresponding pipeline stage doc. If a template exists but no stage doc says "fill from
  `templates/X.md`", it will never be used.

**Files to modify**
- Any file with an orphan path reference — fix to match the canonical path
- `pipeline/01-research-domain.md` and `agents/domain-researcher.md` — add exact filename
  convention for `input/research-findings/` entries
- All files using `[N]` — standardize to no-leading-zeros convention
- Any template file not referenced in a stage doc — add the reference

**Done when**
- No orphan path references exist in any pipeline file
- `[N]` token convention is consistent across all files
- Every template has at least one stage doc that references it by name
- The hallucination-traps path is consistent across all references

---

## Summary: Files to Create and Modify

### Net-new files

```
input/README.md
pipeline/00.5-intake-reader.md
pipeline/04.5-phase-planning.md
agents/intake-reader.md
agents/phase-planner.md
skills/intake-reader/SKILL.md
skills/phase-planning/SKILL.md
skills/resume/SKILL.md
templates/phase-plan.md
templates/test-run.md
templates/session-log.md
bootstrap/update-pipeline.md
bootstrap/hooks/validate-error-registry.sh
CHANGELOG.md
docs/decisions/001-fresh-context-per-stage.md
docs/decisions/002-vertical-slices-not-horizontal-layers.md
docs/decisions/003-test-names-not-test-files.md
docs/decisions/004-handoff-as-session-boundary.md
docs/decisions/005-error-registry-and-hallucination-traps.md
docs/decisions/006-read-access-matrix.md
```

### Modified files

```
00-START-HERE.md                    ← stage sequence, gates, version check, session pre-flight,
                                      token resolution section, all 5 routing elements per stage,
                                      parallel dispatch for Stage 08, fork-join aggregation
README.md                           ← stage table, artifact tree, read-access matrix (R/W/A/G/RW),
                                      last-audited date, docs/decisions link
pipeline/README.md                  ← stage list including 00.5 and 04.5
pipeline/01-research-domain.md      ← grounded research, save to input/research-findings/,
                                      exact filename convention for research-findings entries
pipeline/04-requirements-design.md  ← architect candidates, optional Q&A gate (stage 04.3),
                                      04.3 conditional branch routing documented
pipeline/05-plan-slices.md          ← restrict to active phase, ui-touching + status fields,
                                      >8 slices halt condition with three user options
pipeline/07-execute-step.md         ← test gate, touched-files.txt append per sub-task
pipeline/08-review.md               ← reviewer behavior only (aggregation moved to 00-START-HERE)
pipeline/09-write-handoff.md        ← session-log append, size-scaled word cap
agents/domain-researcher.md         ← read intake artifacts, write to input/research-findings/,
                                      structured comment header with read/write lists
agents/architect.md                 ← read input/**, intake artifacts, optional Q&A output,
                                      structured comment header
agents/coder.md                     ← "blocker" defined explicitly, structured comment header
agents/code-reviewer.md             ← read test-run.md, test-coverage section, write to
                                      review-code.md, structured comment header
agents/security-reviewer.md         ← write to review-security.md, structured comment header
agents/handoff-writer.md            ← read slice size, size-scaled cap, exact source artifact list,
                                      prohibition on reading step-spec, structured comment header
agents/step-researcher.md           ← version-based staleness, fallback for missing knowledge list,
                                      structured comment header
agents/slice-planner.md             ← structured comment header
agents/browser-verifier.md          ← structured comment header
templates/constitution.md           ← active feature slug field
templates/knowledge.md              ← pinned-version + last-verified fields
templates/design.md                 ← architecture-candidates section
templates/handoff.md                ← core/appendix split, size-scaling note
templates/error-registry.md         ← field checklist, example entry
templates/slice-plan.md             ← ui-touching boolean, status field
templates/phase-plan.md             ← selected phase ID field (also created in A5)
bootstrap/generate-claude-scaffolding.md ← new agents, hooks, permissions, pipeline-version,
                                           hook execution order documented
bootstrap/hooks/require-step-spec.sh    ← exclude specs/**, .claude/**, input/**
bootstrap/hooks/require-plan.sh         ← same exclusions, fix first-run edge case
bootstrap/hooks/no-bypass-hooks.sh      ← add --no-hooks to regex
bootstrap/hooks/restrict-reads.sh       ← document fallback when current-stage absent
bootstrap/hooks/stop-after-handoff.sh   ← verify/fix trigger type (PostToolUse Write, not Stop)
All agents/*.md                     ← pipeline-owned comment header
All skills/*/SKILL.md               ← pipeline-owned comment header
```
