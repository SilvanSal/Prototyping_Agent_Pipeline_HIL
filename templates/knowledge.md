# Knowledge: Slice [ID]

_Feature: [feature-slug] · Slice: [S0N] · Research pass: [YYYY-MM-DD]_

> **Refresh policy:** re-verify on any version bump of the pinned libraries below. Default expiry: 90 days.
> **Scope:** external reference only. Conventions and style are in `best-practices.md` / `code-style.md`, which the Coder reads separately.

## Pinned versions (non-negotiable for this slice)

| Library / runtime | Version | Why this version |
|---|---|---|
| [e.g., requests] | [==2.31.0] | [matches tech-stack.md] |
| | | |

## API / library reference

### [Endpoint or function name]

**Source:** [URL to canonical docs]
**Signature / shape:**
```
[exact call shape, copy-paste from docs]
```
**Key parameters:**
- `param_name` — [type] — [constraint]
- `param_name` — [type] — [constraint]

**Typical response / return:**
```
[exact shape]
```

### [Second item]

**Source:**
**Signature:**
```

```

## Gotchas and footguns

Known issues at the pinned versions. Cite source for each (StackOverflow, GitHub issue, changelog).

- [Gotcha] — [source URL]
- [Gotcha] — [source URL]

## Minimal working example

Smallest snippet that demonstrates the pattern this slice will use. From official docs where possible.

**Source:** [URL]
```
[code]
```

## Unverified claims

Anything above where we could not find a canonical source. Coder should verify before relying.

- [Claim] — [why unverified]

## Links

- Step spec: `specs/[feature]/slices/[N]/step-spec.md`
- Tech stack: `tech-stack.md`
