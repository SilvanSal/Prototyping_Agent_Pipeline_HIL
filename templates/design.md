# Design: [Feature Name]

_Feature ID: [feature-slug] · Created: [YYYY-MM-DD]_

## Architecture overview

```mermaid
%% System-level component diagram. Show every major component, its
%% responsibility (one phrase), and how data flows between them.
%% Include external systems from the constitution's integration context
%% (upstream sources, downstream consumers, coexisting systems).
%% Use subgraphs to group related components (e.g., "Backend", "Data layer").
%% Label edges with the protocol or data format (REST, gRPC, CSV, SQL, etc.).

graph TD
    subgraph External
        A[Upstream source] -->|format| B[Your component]
    end
```

[1 paragraph narrating the diagram for a non-technical reader: what the boxes are, what the arrows mean, where data enters and leaves.]

```mermaid
%% Data-flow diagram for the 1-2 most complex user actions.
%% Show the path of a single request/event through the system
%% from user action to final state change. Label each step.

sequenceDiagram
    participant User
    participant UI
    participant API
    participant DB
    User->>UI: [action]
    UI->>API: [call]
    API->>DB: [query]
    DB-->>API: [result]
    API-->>UI: [response]
```

[1 paragraph explaining the sequence to a non-technical reader.]

## Tech-stack choices

| Concern | Choice | Version | Reason |
|---|---|---|---|
| Language | | | |
| Framework | | | |
| Database | | | |
| Test runner | | | |

## Data model

### Entity: [Name]

| Field | Type | Constraints | Notes |
|---|---|---|---|
| id | | PK, NOT NULL | |
| | | | |

Relationships:
- [Entity] has many [Entity] via [column]

Migration path:
- [If existing schema, how this ships without downtime]

## API surface

### [METHOD] [/path]

**Purpose:** [one sentence]
**Auth:** [required / none / specific role]
**Request:**
```
{ ... }
```
**Response (200):**
```
{ ... }
```
**Errors:** [4xx/5xx cases]

## Key sequence flows

### [User action name]

```
1. User clicks X in UI
2. UI sends [METHOD] [/path] with [payload]
3. API validates [...]
4. API writes [...]
5. API returns [...]
6. UI renders [...]
```

## Rejected alternatives

Options considered and why they lost. Future readers will thank you.

| Option | Why rejected |
|---|---|
| | |

## Open questions deferred to Slice-Planner

- [Any implementation detail not decided here because it depends on slice order]

## Links

- Requirements: `specs/[feature]/requirements.md`
- Eval spec: `specs/[feature]/eval-spec.md`
- Slice plan: `specs/[feature]/slice-plan.md`
