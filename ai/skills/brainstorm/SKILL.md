---
name: brainstorm
description: Plan an improvement ticket or idea into tracer-bullet work and GitHub issues.
argument-hint: "Please provide the GitHub Issue id or describe the improvement idea you would like to implement."
disable-model-invocation: true
---

> [!IMPORTANT]
> This skill only **plans and files tickets** — it must never write, edit, or execute implementation code, run builds/tests, or open branches/PRs. Once the plan is filed, tell the user to run the `implement-ticket` skill manually to build it; do not start implementation yourself, even if asked to "just do it" in the same run.

## Workflow

### Step 1 — Parse the Request

Verify if the provided input refers to an open GitHub Issue via the GitHub MCP. If not, treat it as an idea or improvement request. Gather context, requirements, and constraints. If the ticket or request references a PRD, load it via the GitHub MCP and extract relevant information.

**Done when:** you have a written set of context, requirements, and constraints (from issue, PRD, and/or user text).

### Step 2 — Generate Implementation Plan

Produce a plan that includes:

- Summary of the improvement or idea (with ticket/request context)
- Step-by-step implementation guide (code, config, infrastructure)
- Challenges/risks and mitigations
- Required tests and validation steps
- If the user asked for a prototype or proof of concept: a plan for it (use the `prototype` skill when building one)

If the context is dubious, unclear, or requirements need external facts (unfamiliar APIs, libraries, specs, prior art), invoke the `research` skill **before** grilling the user. Have it write/update `RESEARCH.md` at the repository root, citing sources for each claim; re-invoke it later in this run if new open questions surface that need external facts. Only once research is done should you use the `grilling` skill to clarify whatever questions remain open (missing decisions, preferences, or ambiguous scope that research cannot answer).

#### Mandatory expert consult (do not skip)

**Always** invoke the `ask-the-expert` skill in **Plan** mode before finalizing — mandatory on every run, not conditional on confidence or on whether you already “know” the stack.

When branching out:

1. **Invoke the skill** (do not impersonate experts yourself, and do not Task-call individual expert agents from this skill — that orchestration belongs to `ask-the-expert`).
2. **Pass full context**: draft plan, ticket/PRD requirements and constraints, relevant paths, and any open questions.
3. **Hand in the current codebase as reference.** Tell `ask-the-expert` this is **Plan** mode with screening corpus = **whole current workspace** (the live tree on disk). Experts plan against today’s architecture — do not point them at an older release unless the user explicitly asked to target one.
4. **Do not pre-filter technologies** for the consult. `ask-the-expert` must scan that **current workspace**, match **every** available expert domain, and dispatch to **all** matched experts (see that skill’s hard rules). Your job is to supply the plan and question, not to decide which experts run.
5. **Incorporate** the synthesized guidance (risks, recommended approach, tradeoffs) into the plan. If the consult’s “Experts consulted” list is missing or looks incomplete relative to the repo, re-invoke `ask-the-expert` rather than proceeding on a partial consult.

**Done when:** the plan has summary, steps, risks, tests/validation; `ask-the-expert` was actually invoked in Plan mode against the **current workspace** as codebase reference; its Experts consulted / inventory outcome is reflected; feedback is incorporated; open questions resolved or explicitly listed.

### Step 3 — Work breakdown and GitHub filing

Follow [`references/tracer-ticket-breakdown.md`](references/tracer-ticket-breakdown.md): split into tracer-bullet tickets (or expand–contract for wide refactors), then create/update the main issue and linked child issues.

**Done when:** that shared reference’s completion criteria are met and the user has issue URLs plus next steps.

### Step 4 — Stop and hand off

Report the plan summary and issue URLs, then stop. **Do not** begin implementation, create branches, edit files, or run `implement-ticket` yourself — the user must trigger implementation manually via the `implement-ticket` skill.

**Done when:** the user has been told to run `implement-ticket` manually when ready.
