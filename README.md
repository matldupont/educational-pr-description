# Educational PR/MR Descriptions — Agent Skill

A portable "skill" that teaches coding agents (Claude Code, Cursor, Codex, etc.) to add a **Context & Patterns** section to pull/merge request descriptions.

The goal: help less experienced reviewers — or engineers reviewing across the stack (backend reviewing frontend, vice versa) — understand *why* the code is written the way it is, not just *what* changed.

Works for both GitHub PRs and GitLab MRs. The skill's activation trigger covers both.

## What is a "skill"?

A skill is a markdown file with YAML frontmatter that agents load to gain narrow, on-demand capabilities. The `description` field tells the agent when to invoke it. Works with any agent framework that supports the Anthropic "Agent Skills" convention (`.claude/skills/`, `~/.agents/skills/`, Cursor skills, etc.).

## Install

### One-liner

```bash
curl -fsSL https://raw.githubusercontent.com/matldupont/educational-pr-description/main/install.sh | bash
```

Install to Claude Code user skills instead:

```bash
curl -fsSL https://raw.githubusercontent.com/matldupont/educational-pr-description/main/install.sh | bash -s -- claude
```

Install project-local (commit to share with your team):

```bash
cd your-project
curl -fsSL https://raw.githubusercontent.com/matldupont/educational-pr-description/main/install.sh | bash -s -- project
```

### Manual

Drop `SKILL.md` into one of:

- **User-wide (all projects):** `~/.agents/skills/educational-pr-description/SKILL.md`
- **Claude Code user-wide:** `~/.claude/skills/educational-pr-description/SKILL.md`
- **Project-local:** `.claude/skills/educational-pr-description/SKILL.md`

Then just ask your agent to write or improve a PR/MR description and the skill will activate automatically.

## How to use it

There are two main ways to use this skill.

### 1. Direct invocation

Just ask your agent something that mentions PRs, MRs, or writing a description. The `description` field in the frontmatter triggers activation:

- *"Write a PR description for this branch."*
- *"Improve the description on this MR."*
- *"Add educational context to the PR I just opened."*

### 2. Compose it into your PR/MR-creation workflow (recommended)

The real power is using it as a **step inside a larger skill or workflow** that creates PRs/MRs. If you already have a skill like `gh-pr-create`, `glab-mr-create`, `ship-pr`, `ship-mr`, or a custom slash command, add a step that invokes this skill right before the description is written.

Example — in another skill's `SKILL.md`:

```markdown
## Steps

1. Validate the branch is pushed and up to date.
2. Analyze the diff against the base branch.
3. **Invoke the `educational-pr-description` skill** to generate a
   `## Context & Patterns` section from the diff. Skip gracefully if the
   skill determines there is nothing worth calling out.
4. Assemble the final description: Summary → Testing → Context & Patterns → Notes.
5. Create the PR/MR with `gh pr create` / `glab mr create`.
```

Because this skill has clear "When to Skip" guidance, composing it is safe: it will self-suppress on dependency bumps, renames, and config-only changes instead of forcing a noisy section into every PR.

### 3. Bind it to a slash command or alias

If your agent supports custom commands (Claude Code commands, Cursor rules, shell aliases that wrap an agent call), point the command at an instruction like:

> Draft a PR description for the current branch. Use the `educational-pr-description` skill to add a Context & Patterns section when appropriate.

## Works well with

- [`gh pr create`](https://cli.github.com/manual/gh_pr_create) — GitHub CLI
- [`glab mr create`](https://gitlab.com/gitlab-org/cli) — GitLab CLI
- Agent skills like `gh-pr-create`, `glab-mr-create`, `ship-pr`, `ship-mr`, or any custom "create PR/MR" workflow
- Claude Code `/commands`, Cursor rules, or shell aliases that wrap an agent to draft PR/MR descriptions
- Pre-push git hooks that call an agent to draft a description before opening the PR/MR

## Before / After

**Before** — a typical AI-generated description:

```markdown
## Summary
Adds a new checkout flow with payment processing.

## Testing
- Unit tests pass
- Manually tested happy path
```

**After** — with the skill active:

```markdown
## Summary
Adds a new checkout flow with payment processing.

## Testing
- Unit tests pass
- Manually tested happy path

## Context & Patterns

**Transaction boundary around the two writes** — The order and payment records
must be created atomically. If the payment insert fails after the order is
committed, we'd have orphaned orders with no payment record.

**Idempotency key on the charge call** — The checkout endpoint can be retried
by the client on network failure. The key ensures a retried request doesn't
double-charge the customer.
```

The skill is deliberately conservative: it tells the agent to *skip* the section entirely for config changes, renames, dependency bumps, or anything where all the patterns are obvious. A noisy section trains reviewers to ignore it.

## Philosophy

- **Focus on the *why*, not the *what*** — the diff already shows what changed
- **Be specific to *this* diff** — no generic advice, no textbook definitions
- **Cap at 4 callouts** — pick the most valuable ones
- **When in doubt, skip** — a missing section is invisible; a noisy one is worse than nothing

## License

MIT — use it, fork it, remix it.
