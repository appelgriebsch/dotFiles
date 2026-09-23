---
name: brainstorm
description: Plan an improvement ticket or idea into tracer-bullet work and tracker tickets.
argument-hint: "Please provide the ticket ID or describe the improvement idea you would like to implement."
disable-model-invocation: true
---

> [!IMPORTANT]
> **Allowed writes:** plan artifacts only — `docs/research/` files per the [path rule](references/research-grill-decisions.md), `CONTEXT.md` / ADRs via `domain-modeling`, and tracker creates/updates/comments. After filing, persist the plan artifacts on the **implement-ticket baseline branch** (Step 4) and open a **draft** PR, then stop and tell the user to run `implement-ticket` manually.
>
> **Guardrail:** do not write, edit, or execute implementation code; do not run builds/tests of the product; do not start `implement-ticket` — even if asked to "just do it" in the same run.

## Workflow

### Step 1 — Parse the Request

Load `issue-tracker`. Match the input against **Identity** `ticket_id_pattern` (or extract the id from a browse URL). If it matches an **open** ticket, get it via **Operations** get. If not, treat it as an idea or improvement request. Gather context, requirements, and constraints. If the ticket or request references a PRD that matches **Identity**, get that ticket via **Operations** get and extract relevant information.

**Done when:** you have a written set of context, requirements, and constraints (from issue, PRD, and/or user text).

### Step 2 — Generate Implementation Plan

Produce a plan that includes:

- Summary of the improvement or idea (with ticket/request context)
- Step-by-step implementation guide (code, config, infrastructure)
- Challenges/risks and mitigations
- Required tests and validation steps

Load [`references/research-grill-decisions.md`](references/research-grill-decisions.md) and complete its research → grill → decision-capture sequence before the expert consult.

#### Mandatory expert consult

**Always** invoke the `ask-the-expert` skill in **Consultant** mode before finalizing — every run, not conditional on confidence or on whether you already “know” the stack.

When branching out:

1. **Invoke the skill** (do not impersonate domain children yourself — that orchestration belongs to `ask-the-expert`). Pass a screen, flow, or design-system question through with the draft plan.
2. **Pass full context**: draft plan, ticket/PRD requirements and constraints, relevant paths, and any open questions.
3. **Hand in the current codebase as reference.** Tell `ask-the-expert` this is **Consultant** mode with screening corpus = **whole current workspace** (the live tree on disk). Experts consult against today’s architecture — do not point them at an older release unless the user explicitly asked to target one.
4. **Do not pre-filter technologies** for the consult. `ask-the-expert` must scan that **current workspace**, match **every** available expert domain, and dispatch to **all** matched experts (that skill’s inventory and dispatch). Your job is to supply the plan and question, not to decide which experts run.
5. **Incorporate** the synthesized guidance (risks, recommended approach, tradeoffs) into the plan. If the consult’s “Experts consulted” list is missing or looks incomplete relative to the repo, re-invoke `ask-the-expert` rather than proceeding on a partial consult.

**Done when:** the plan has summary, steps, risks, tests/validation; [`research-grill-decisions.md`](references/research-grill-decisions.md) **Done when** criteria are met; `ask-the-expert` was actually invoked in Consultant mode against the **current workspace** as codebase reference; its Experts consulted / inventory outcome is reflected; feedback is incorporated; open questions resolved or explicitly listed.

### Step 3 — Work breakdown and ticket filing

Load [`references/tracer-ticket-breakdown.md`](references/tracer-ticket-breakdown.md). Split the plan into tracer-bullet (or expand–contract) tickets, file/update the main issue and linked children, and meet that file’s **Work breakdown** and **Ticket creation / management** **Done when** before Step 4.

**Done when:** that file’s filing **Done when** is met.

### Step 4 — Persist plan artifacts, then stop

Load **Persist plan artifacts** in [`references/tracer-ticket-breakdown.md`](references/tracer-ticket-breakdown.md). Report the plan summary, issue URLs, and the persist result (baseline branch, commit SHA, draft PR URL, or that nothing changed). Then stop; the user runs `implement-ticket` manually.

**Done when:** that file’s persist **Done when** is met.
