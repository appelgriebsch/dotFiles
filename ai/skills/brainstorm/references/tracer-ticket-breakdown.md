# Tracer-ticket breakdown and ticket filing

Shared external reference for `brainstorm` and `troubleshoot`. Load after the plan (implementation or troubleshooting) is written. Not a skill — not invocable on its own.

## Work breakdown

Break the work into **tracer bullet** tickets.

### Vertical-slice rules

- Each slice cuts a narrow but COMPLETE path through every layer (schema, API, UI, tests) — vertical, NOT a horizontal slice of one layer
- A completed slice is demoable or verifiable on its own
- Each slice is sized to fit in a single fresh context window
- Any prefactoring should be done first

Give each ticket its **blocking edges** — the other tickets that must complete before it can start. A ticket with no blockers can start immediately.

### Per-ticket implementation plan (required when possible)

The parent plan is the source of truth for the whole effort. **Before filing**, decompose it so **every** tracer-bullet (or expand–contract) ticket carries its **own** implementation plan — enough that `implement-ticket` can execute that child in isolation without re-deriving steps from the EPIC.

For each ticket, work out (when possible):

- **Scope** — what this slice includes and explicitly excludes
- **Step-by-step implementation** — ordered code/config/infra steps for **this ticket only** (paths, modules, APIs, migrations as known)
- **Tests / validation** — how this slice proves its done criterion
- **Risks or open points local to this slice** — only if they affect how to implement it
- **Depends on** — what prior tickets must have delivered (interfaces, data, flags) so the steps assume the right preconditions

**How to derive it**

1. Map each parent-plan step (or root-cause fix step) onto the ticket that owns it.
2. Rewrite those steps at child granularity: concrete enough to implement, free of work that belongs on sibling tickets.
3. Prefer a **full** plan when the approach, surfaces, and validation are already known from research/expert consult.
4. If a slice **cannot** be planned fully yet (outcome of a prior ticket, live investigation, or unknown API shape), still file a **best-effort** plan: known steps, explicit unknowns, and what must be true after blockers land before implementation can finish. Mark residual unknowns in the body — do not leave the plan section empty or “TBD only”.

Do **not** file a child that is only a goal + acceptance criterion when a workable plan can be written from the parent plan and codebase context already in hand.

**Done when:** every ticket has a one-line goal, a demoable/verifiable criterion, an explicit blockers list (or “none”), and a per-ticket implementation plan (full or best-effort with stated unknowns).

### Wide refactors (exception)

**Wide refactors are the exception to vertical slicing.** A **wide refactor** is one mechanical change — rename a column, retype a shared symbol — whose **blast radius** fans across the whole codebase, so a single edit breaks thousands of call sites at once and no vertical slice can land green. Don't force it into a tracer bullet; sequence it as **expand–contract**.

1. **Expand:** add the new form beside the old so nothing breaks.
2. **Migrate:** move call sites over in batches sized by blast radius (per package, per directory), each batch its own ticket blocked by the expand, keeping CI green batch to batch because the old form still exists.
3. **Contract:** delete the old form once no caller remains, in a ticket blocked by every migrate batch.

When even the batches can't stay green alone, keep the sequence but let them share an integration branch that all block a final integrate-and-verify ticket — green is promised only there.

Each expand / migrate-batch / contract ticket still gets its **own** implementation plan (what changes, where, how to keep CI green for that step).

## Ticket creation / management

Load `issue-tracker` before any get/create/update/comment/link. Use **Operations** tool names and **Extras** labels.

### Filing steps

1. **Main issue**
   - If work started from an existing ticket: **update** it with a summary of the plan (**Operations** update).
   - If work started from an idea, improvement request, or trace ID only: **create** a new ticket with that summary (**Operations** create).
   - Keep the **full** parent plan (or a clear summary + pointer) on the main/EPIC issue so the overall story stays visible.
   - Apply labels per **Extras** (typically `epic` + `has-plan` when children and a parent plan exist; grooming flags only if gaps remain).

2. **Child issues** — for each tracer-bullet ticket from the breakdown, **create** a ticket (**Operations** create) and **link** it to the main issue (**Operations** link_child). Each child body must include:
   - Goal (one line) — fits Context **What**
   - Context references (paths, issue URLs, ADRs — not duplicated full specs)
   - Blocking edges (ticket ids or “none”)
   - Demoable/verifiable done criterion — fits Acceptance Criteria
   - **Implementation plan** — the per-ticket plan from the breakdown (step-by-step for this child; full or best-effort with unknowns). This is what `implement-ticket` will execute for leaf work and for each EPIC sub-ticket.
   - No secrets (API keys, passwords, PII)
   - Apply labels per **Extras** (`has-plan` and/or grooming flags; never `epic`).

3. **STE summary on main** — write a human-readable summary of the **full** plan and next steps in ASD-STE100 Simplified Technical English (ubiquitous language from `CONTEXT.md` when present). **Post it as a comment on the main ticket** (**Operations** comment) (required — chat-only is not enough) and repeat it in the skill output to the user.

4. **User summary** — return the STE summary, main + child issue links (noting that each child carries its own plan), labels assigned to each issue, and next-step recommendations.

**Done when:** main issue exists/updated with the parent plan; every child linked to main was created via **Operations** create + link_child with goal/context/blockers/done criterion/**implementation plan**; the main ticket has an **STE summary comment** attached; and the user has the URLs plus that summary.
