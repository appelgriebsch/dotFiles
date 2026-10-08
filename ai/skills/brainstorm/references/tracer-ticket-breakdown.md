# Tracer-ticket breakdown and ticket filing

Shared by `brainstorm` and `troubleshoot`. Load after the plan is written. Not a skill.

- Skill Step 3 → **Work breakdown** then **Ticket creation / management** — meet each **Done when**.
- Skill Step 4 → **Persist plan artifacts** — meet that **Done when**.

This file owns filing and persist. Identity, MCP tool names, label meanings, and git templates live in `issue-tracker`.

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
4. If a slice **cannot** be planned fully yet (outcome of a prior ticket, live investigation, or unknown API shape), still file a **best-effort** plan: known steps, explicit unknowns, and what must be true after blockers land before implementation can finish. Mark residual unknowns in that plan. The plan stays filled in.

File a child with a workable plan whenever the parent plan and codebase context already in hand can support one (goal + acceptance criterion alone only when that is all that can be written).

**Done when:** every ticket has a one-line goal, a demoable/verifiable criterion, an explicit blockers list (or “none”), and a per-ticket implementation plan (full or best-effort with stated unknowns). That plan is what filing posts as the `PLAN` doc comment.

### Wide refactors (exception)

**Wide refactors are the exception to vertical slicing.** A **wide refactor** is one mechanical change — rename a column, retype a shared symbol — whose **blast radius** fans across the whole codebase, so a single edit breaks thousands of call sites at once and no vertical slice can land green. Sequence it as **expand–contract**.

1. **Expand:** add the new form beside the old so nothing breaks.
2. **Migrate:** move call sites over in batches sized by blast radius (per package, per directory), each batch its own ticket blocked by the expand, keeping CI green batch to batch because the old form still exists.
3. **Contract:** delete the old form once no caller remains, in a ticket blocked by every migrate batch.

When even the batches can't stay green alone, keep the sequence but let them share an integration branch that all block a final integrate-and-verify ticket — green is promised only there.

Each expand / migrate-batch / contract ticket still gets its **own** implementation plan (what changes, where, how to keep CI green for that step).

## Ticket creation / management

Load `issue-tracker` before any get/create/update/comment. Use **Operations** tool names, **Extras** labels, and **Extras** issue types.

One tracer bullet files a **leaf**. Two or more file an **EPIC**: one parent plus one sub-task per bullet.

| Shape | Main issue type | Sub-tasks |
| --- | --- | --- |
| **Leaf** | `brainstorm` → extras `issue_type_improvement`; `troubleshoot` → extras `issue_type_bug` | none |
| **EPIC** | same as the leaf row | one extras `issue_type_subtask` per bullet; parent = the main issue |

### Description and `PLAN`

Write descriptions in **STE-100** (ASD Simplified Technical English): short sentences, one action per sentence, terms from `GLOSSARY.md` when that file exists.

| Ticket | Description | `PLAN` comment |
| --- | --- | --- |
| Leaf | STE-100 summary of the plan: what changes, why, the next step, and blocker ids when any | the full implementation plan |
| EPIC parent | the whole epic plan in STE-100, every slice and its order | none |
| Sub-task | STE-100 summary of that slice, including blocker ids when any | that slice’s implementation plan |

The `PLAN` comment is the per-ticket plan from the breakdown, in ordinary technical prose: scope, steps, tests/validation, local risks, and **Depends on** (blocker ids, or none). No secrets (API keys, passwords, PII). `implement-ticket` executes this comment.

Write the files under **Scratch** in [`research-grill-decisions.md`](research-grill-decisions.md). The leaf file is `{scratch}/PLAN.md`. Each sub-task file is `{scratch}/{slice-slug}/PLAN.md` until it is posted. Create **Scratch** when this run has none yet.

### Filing steps

1. **Main issue** — **Operations** update when the run started from an existing ticket; **Operations** create otherwise. Set `type` from the table. Set the body to the STE-100 description for this shape. Apply labels per **Extras** (`epic` + `has-plan` when this is an EPIC whose description is the whole plan; a leaf gets `has-plan` when its `PLAN` file has concrete steps; grooming flags only when gaps remain).

2. **Sub-tasks** (EPIC only) — **Operations** create each bullet with `type` = extras `issue_type_subtask`, `parent_issue_number` = the main issue number, and that slice’s STE-100 summary as the body. Labels per **Extras** (`has-plan` when that slice’s `PLAN` file has concrete steps; never `epic`).

3. **Ids in the text** — after every issue exists, update any description that still names a slice or a blocker without its ticket id, so the epic plan and each sub-task summary use those ids (or “none”).

4. **Post `PLAN`** — **Post a doc comment** for `PLAN` from the leaf file onto the leaf, or from each slice file onto that sub-task. The description stays the STE-100 text.

5. **Ticket context** — on the **main** issue only. When **Scratch** has inquiry files, write `{scratch}/RESEARCH.md` as **Ticket context files** in [`research-grill-decisions.md`](research-grill-decisions.md). **Post a doc comment** for `RESEARCH` and for `DECISION` when each file exists.

6. **User summary** — return the main STE-100 description, each issue URL, the issue that carries the `PLAN` comment (the leaf, or every sub-task), which of `RESEARCH` / `DECISION` are on the main issue, the labels, and the next step (`implement-ticket`).

Delete **Scratch** after every post attempted above succeeds, including a post that published an oversized file on `ticket_ref`. When a post fails, leave that file, report the path and the error, and keep the description as the STE-100 text.

**Done when:** the main issue has the issue type from the table and its STE-100 description; a leaf has a `PLAN` doc comment; an EPIC has one sub-task per tracer bullet, each with its STE-100 summary, the sub-task type, the main issue as parent, and its own `PLAN` doc comment; `RESEARCH` and `DECISION` doc comments are on the main issue when this run produced them; labels match **Extras**; the user has the URLs and the STE-100 text.

## Persist plan artifacts

Skill Step 4 — after filing. When this run changed root `GLOSSARY.md` (including a rename from `CONTEXT.md`), a context-local `GLOSSARY.md`, or ADRs (`docs/adr/` or a context-local `docs/adr/`), commit those paths on the **implement-ticket baseline branch** and open a **draft** PR for that head. Skip when none of those files changed. They land with the work they inform — they merge when that work merges. `PLAN`, `RESEARCH`, and `DECISION` stay on the issue comment or on `ticket_ref`. The baseline branch carries the glossary and ADRs only.

`{BASELINE_ID}` is the **main issue** from filing above.

| Kind | Baseline branch | Create from / PR target |
| --- | --- | --- |
| **EPIC** (`epic` label and/or children linked) | `issue-tracker` `branch_with_ticket` for `{BASELINE_ID}` | repo default branch (`main` or `master`) |
| **Leaf** (no children) | `issue-tracker` `branch_with_ticket` for `{BASELINE_ID}` | that ticket’s **parent base** — same order as `implement-ticket` Step 2 (blocker branch if one exists, else parent EPIC branch if one exists, else default) |

1. Fetch. Stash unrelated dirty files. Checkout the baseline branch; create it from the parent in the table if it is missing locally and on `origin`. If it already exists, use it (fast-forward from origin) — do not recreate it from default.
2. Commit only changed glossary and ADR paths: root `GLOSSARY.md`, a rename from root `CONTEXT.md`, context-local `GLOSSARY.md`, and ADR paths. Message from **Git naming** `commit_with_ticket` with `{BASELINE_ID}`.
3. Push the baseline branch to `origin`.
4. If no open PR exists for this head: open a **draft** PR targeting the parent in the table. Title from `pr_title_with_ticket` for `{BASELINE_ID}`. Body: these are glossary / ADR artifacts; `PLAN`, `RESEARCH`, and `DECISION` are doc comments on the ticket (an oversized one names its `ticket_ref` in the comment); implementation follows via `implement-ticket`; include ticket browse URLs (and sub-task ids when this is an EPIC).
5. If a PR already exists for this head: keep it draft, retarget its base if it does not match the parent in the table, report its URL.
6. Restore the previous checkout.

Then stop. Tell the user to run `implement-ticket` manually when ready.

**Guardrail:** do not write implementation code or start `implement-ticket` from this run.

**Done when:** changed plan artifacts are on `origin` of the baseline branch and a draft PR URL exists for that head (or none of those files changed), and the user has been told to run `implement-ticket` manually when ready.
