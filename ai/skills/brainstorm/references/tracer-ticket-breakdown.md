# Tracer-ticket breakdown and GitHub filing

Shared external reference for `brainstorm` and `troubleshoot`. Load after the plan (implementation or troubleshooting) is written. Not a skill — not invocable on its own.

## Work breakdown

Break the work into **tracer bullet** tickets.

### Vertical-slice rules

- Each slice cuts a narrow but COMPLETE path through every layer (schema, API, UI, tests) — vertical, NOT a horizontal slice of one layer
- A completed slice is demoable or verifiable on its own
- Each slice is sized to fit in a single fresh context window
- Any prefactoring should be done first

Give each ticket its **blocking edges** — the other tickets that must complete before it can start. A ticket with no blockers can start immediately.

**Done when:** every ticket has a one-line goal, a demoable/verifiable criterion, and an explicit blockers list (or “none”).

### Wide refactors (exception)

**Wide refactors are the exception to vertical slicing.** A **wide refactor** is one mechanical change — rename a column, retype a shared symbol — whose **blast radius** fans across the whole codebase, so a single edit breaks thousands of call sites at once and no vertical slice can land green. Don't force it into a tracer bullet; sequence it as **expand–contract**.

1. **Expand:** add the new form beside the old so nothing breaks.
2. **Migrate:** move call sites over in batches sized by blast radius (per package, per directory), each batch its own ticket blocked by the expand, keeping CI green batch to batch because the old form still exists.
3. **Contract:** delete the old form once no caller remains, in a ticket blocked by every migrate batch.

When even the batches can't stay green alone, keep the sequence but let them share an integration branch that all block a final integrate-and-verify ticket — green is promised only there.

## GitHub issue creation / management

Use the GitHub MCP.

1. **Main issue**
   - If work started from an existing GitHub Issue: update it with a summary of the plan.
   - If work started from an idea, improvement request, or trace ID only: create a new GitHub Issue with that summary.

2. **Child issues** — for each tracer-bullet ticket from the breakdown, create a GitHub Issue linked to the main issue. Each child body must include:
   - Goal (one line) — fits Context **What**
   - Context references (paths, issue URLs, ADRs — not duplicated full specs)
   - Blocking edges (issue numbers or “none”)
   - Demoable/verifiable done criterion — fits Acceptance Criteria
   - No secrets (API keys, passwords, PII)

3. **User summary** — return plan summary, main + child issue links, and next-step recommendations.

**Done when:** main issue exists/updated, every child ticket has a linked GitHub Issue with goal/context/blockers/done criterion, and the user has the URLs.
