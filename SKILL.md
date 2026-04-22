---
name: educational-pr-description
description: >-
  Enhance PR/MR descriptions with educational context for reviewers. Use when
  writing or generating pull request or merge request descriptions, creating
  PRs/MRs, or when the user asks to add learning context to a PR or MR.
---

# Educational PR/MR Descriptions

Add a **Context & Patterns** section to PR/MR descriptions that explains
non-obvious decisions in the diff. The goal is to help less experienced
reviewers (and backend engineers reviewing frontend changes, or vice versa)
understand *why* the code is written this way.

## When to Include

Analyze the diff for patterns worth explaining. Include the section when the
diff contains any of:

- Architectural decisions where alternatives existed
- Non-obvious framework conventions (Rails callbacks, React hook dependency
  arrays, GraphQL fragment colocation, CSS-in-JS theme token usage)
- Performance-motivated choices (memoization, query optimization, lazy loading,
  batch operations)
- Security or data-integrity patterns (authorization checks, transaction
  boundaries, input validation)
- Cross-layer connections (how a GraphQL mutation triggers backend behavior that
  the frontend subscribes to, how a model callback feeds into a search index)

## When to Skip

Omit the section entirely when:

- The change is config-only, copy/translation changes, dependency bumps, or renames
- All patterns in the diff are standard and obvious to a working developer
- There is nothing genuinely worth calling out — not every change teaches something

**When in doubt, skip.** A missing section is invisible; a noisy one trains
reviewers to ignore it.

## Output Format

Append this section to the description, after Testing and before Notes
(or at the end if no Notes section exists). Generate 1-4 callouts maximum.

Each callout: a bolded pattern name, then 2-3 sentences explaining the *why*.

```markdown
## Context & Patterns

**Why fragment colocation here** — Each component declares its own GraphQL
fragment for the data it needs. This means adding or removing a field is a
one-file change and components stay independently testable.

**Transaction boundary around the two writes** — The order and payment records
must be created atomically. If the payment insert fails after the order is
committed, we'd have orphaned orders with no payment record.
```

## Tone

- Write like you are explaining to a colleague during pairing
- Focus on the **why**, not the **what** — the diff already shows what changed
- Be specific to *this* diff, not generic advice
- No textbook definitions, no tutorial voice
- Keep each callout to 2-3 sentences — concise beats thorough

## Anti-Patterns

- Explaining what the diff already makes obvious ("added a new column")
- Generic advice not tied to this specific change ("always memoize expensive computations")
- More than 4 callouts — if there are that many, pick the most valuable ones
- Restating framework documentation ("useEffect runs after render")
