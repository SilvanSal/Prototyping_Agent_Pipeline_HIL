# Code Style — [Project Name]

_Last updated: [YYYY-MM-DD] · Source of truth for formatting, naming, and file organization._

> **Coders read this.** Researchers and reviewers (except Code-Reviewer) do not.
> **If a rule conflicts with the installed linter/formatter config, the linter wins.** Update this file to match.

## Naming

- **Files:** [e.g., kebab-case for modules, PascalCase for components]
- **Functions:** [e.g., camelCase, verb-phrase]
- **Variables:** [e.g., camelCase, noun]
- **Constants:** [e.g., SCREAMING_SNAKE_CASE at module scope only]
- **Types / classes / interfaces:** [e.g., PascalCase]
- **Test files:** [e.g., `foo.test.ts` colocated with `foo.ts`]

## Formatting

- **Quote style:** [single / double]
- **Semicolons:** [required / forbidden]
- **Trailing commas:** [always / never]
- **Line length:** [e.g., 100 cols]
- **Indentation:** [2 spaces / 4 spaces / tabs]

These should match the linter/formatter config in the repo. If they don't, the config wins.

## Import ordering

1. [e.g., standard library]
2. [e.g., third-party packages]
3. [e.g., local modules, absolute paths]
4. [e.g., local modules, relative paths]
5. [e.g., type-only imports, grouped separately]

## File organization

- **Where tests live:** [e.g., colocated with `.test.ts` suffix / in `tests/` dir mirroring `src/`]
- **Module boundaries:** [e.g., each feature is a folder under `src/features/`; no cross-feature imports]
- **Public API:** [e.g., each folder has an `index.ts` exporting its public surface]

## Comments

- **Default:** no comments. Names carry the meaning.
- **When a comment is required:** the WHY is non-obvious — a hidden constraint, a workaround, a subtle invariant. One short line.
- **Forbidden:** comments that narrate what the code does, reference tickets, or explain removed code.

## Language-specific rules

[Any rules specific to the language(s) in tech-stack.md. e.g., for TypeScript: `any` banned outside test files. For Python: type hints required on all public functions.]

- [Rule]
- [Rule]
