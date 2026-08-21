---
name: implement-ticket
description: Execute a brainstorm/troubleshoot plan for a tracker ticket or EPIC (branch, implement, PR; one review on the final PR). Abort if needs-brainstorm/needs-troubleshoot labels remain; require has-plan (or a body plan). For EPICs, require every sub-ticket plan, sequence by blockers, implement independent tickets in parallel, stack only the sub-ticket PRs onto the EPIC branch at the end using gh-stack (EPIC is the stack trunk, not a member targeting main), then review that stack once.
argument-hint: "Please provide the ticket ID for the improvement, bug ticket, or EPIC you would like to implement."
disable-model-invocation: true
---

## Workflow

### Step 1 — Parse the Request

Load `issue-tracker`. Match the input against **Identity** `ticket_id_pattern` (or extract the id from a browse URL). If it matches, get the ticket via **Operations** get (**body, labels, links**) and require it is **open**. Detect **EPIC** vs **leaf** from **Extras** labels (`epic` and/or **Operations** children). Prefer extras `epic` when present; if the label is missing but children are linked, treat as EPIC anyway.

#### Readiness gates (leaf and every EPIC sub-ticket)

Apply **before** branching or coding. Label names and abort meaning come from `issue-tracker` **Extras**. Order matters:

1. **Grooming labels (hard abort).** If the issue has `needs-brainstorm` and/or `needs-troubleshoot`:
   - List the issue id/title and which grooming label(s) are set.
   - Tell the user which skill to run (`brainstorm` and/or `troubleshoot`) to clear the gap.
   - **Abort.** Do not implement while either grooming label remains — even if `has-plan` is also present (best-effort plan with residual unknowns).
2. **Plan presence.** The issue is ready only when **both**:
   - The body contains an **implementation plan** (step-by-step guidance from `brainstorm` / `troubleshoot`, not only a goal or title), **and**
   - Preferably `has-plan` is set. If `has-plan` is **missing** but a clear body plan exists (legacy tickets), proceed and note the missing label. If `has-plan` is set but the body has no workable plan, **abort** and tell the user to re-run `brainstorm` / `troubleshoot` so the plan is written into the issue.
3. If there is no plan and no grooming label: tell the user to run `brainstorm` or `troubleshoot` first, and **abort**.
4. Resolve the parent EPIC (**Operations** parent). Record `{EPIC_ID}` or none.
5. Record this ticket’s blockers (issue ids that must finish first, or none).

**Leaf ticket**

- Run the readiness gates on this issue only.
- If ready: proceed to Step 2 with this ticket’s plan.

**EPIC**

1. Collect **every** sub-ticket via **Operations** children, then get full details for each (body, **labels**, state, links, blockers).
2. Run the readiness gates on the **EPIC** issue itself (grooming labels on the parent also abort the whole run).
3. Run the readiness gates on **every** sub-ticket.
4. If **any** sub-ticket fails (grooming label, missing plan, or `has-plan` without a body plan): list those issue ids/titles and reasons, tell the user what to re-run, and **abort**. Do not implement partial EPICs.
5. If all sub-tickets are ready: read each ticket’s **blocking edges** (ticket ids that must finish first, or “none”) and build an execution sequence — a dependency graph ordered into **waves**. A wave is the set of remaining tickets whose blockers are already done (or have none); tickets in the same wave may run **in parallel**. Tickets with blockers wait for later waves.

**Done when:** a leaf ticket that passes readiness is loaded, its parent EPIC is resolved (`{EPIC_ID}` or none), and its blockers are recorded; **or** an EPIC has all sub-tickets loaded, every one (and the parent) passes readiness, and the wave sequence is written; **or** the run aborted with a clear report (grooming labels, missing plan, or missing issue).

### Step 2 — Resolve and sync the parent base

The **parent base** is the branch this ticket is created from and the PR target until any later restack. First match after `git fetch`:

1. **Blocker:** the ticket has blockers and a `branch_with_ticket` branch exists (local or `origin`) for at least one of them → that blocker branch. Several blockers: the last one in wave order (standalone leaf: last by ticket id among those with an active branch).
2. **EPIC:** parent `{EPIC_ID}` and `origin/` + `branch_with_ticket` for `{EPIC_ID}` exists (or this run just created it) → that EPIC branch.
3. **Default:** the repo default branch (`main` or `master`).

Fetch and fast-forward the chosen parent base (pull the default branch when that is the match). Tickets with no blockers share the EPIC (or default) parent. A ticket with blockers uses its blocker branch — the previous wave’s work it depends on.

**Done when:** this ticket’s parent base is chosen by that order and is current locally, or the user was asked to resolve conflicts and the run stopped.

### Step 3 — Implement (leaf or EPIC waves)

**Hard rule — background implement unit:** for every ticket (leaf or EPIC sub-ticket), dispatch **Steps 4–6 as one background task** (`task` / `general-purpose`, `mode: "background"`). Do this **always**, including when only one ticket is in flight — background is for **context isolation**, not only for parallelism. The parent conversation **orchestrates only**: prepare branch/worktree, launch the task, wait, read the task report. It must **not** implement, verify, or open the PR inline.

Prompt each background task with the full ticket plan, ticket id, branch name (and worktree path if used), that ticket’s parent base (PR target), any `AGENTS.md` / `*.instructions.md` paths, and the full Step 4–6 instructions below. When the task finishes, take status only from its report (PR URL, deferred items, failures) — do not re-run the plan in the parent context.

#### Leaf ticket

Use branch name from `issue-tracker` **Git naming** `branch_with_ticket`. Create it from this ticket’s parent base if missing; check it out if it exists. Then launch **one** background task for Steps 4–6 on that branch. The task’s PR targets that same parent base.

**Done when:** the working branch is `branch_with_ticket` for this ticket (based on this ticket’s parent base) and the background task has completed Steps 4–6 (or failed with a clear report).

#### EPIC — sequence and parallel

Before starting any wave, create the EPIC's own integration branch from `issue-tracker` `branch_with_ticket` for `{EPIC_ID}` off the up-to-date default branch. Push it and open a **draft** PR for it targeting the default branch (title from **Git naming** `pr_title_with_ticket` for the EPIC id, body summarizes the EPIC and lists the sub-tickets). That draft PR is the only PR that targets the default branch; it stays draft through Step 8. Sub-ticket work reaches it in Step 7 (stack trunk + fast-forward), not by committing on the EPIC branch during waves.

Walk the waves from Step 1 in order. Within each wave, start **every** ticket in that wave as its **own** background Steps 4–6 task **in parallel** when possible (isolated branches / worktrees so work does not clobber a shared working tree). Parallelism stacks on top of the always-on background rule — it does not replace it. For each sub-ticket:

1. Resolve this sub-ticket’s parent base (Step 2). Branch: `branch_with_ticket` for that sub-ticket, created from that parent base (create or check out; use a worktree when running in parallel). The sub-ticket PR targets that same parent base until Step 7 restacks it.
2. Launch a **background** task that runs **Steps 4–6** for that sub-ticket only.
3. Treat the sub-ticket as **done for sequencing** only after that task reports a PR (and required verification passed), so later waves see correct blockers.

Do not start a later wave until every ticket in the current wave has finished its background Steps 4–6 task (or failed with a reported blocker). If a parallel unit fails, report which sub-ticket failed and stop starting new waves that depend on it; finish other in-flight independent work when safe.

**Done when:** every sub-ticket with a plan has been through a background Steps 4–6 task in dependency order, or the user has a clear report of which wave/ticket blocked progress.

### Step 4 — Implement the plan

*(Runs inside the background task from Step 3 — never in the parent conversation.)*

Apply the plan’s changes (code, config, infrastructure) for the **current** ticket only. If `AGENTS.md` or `*.instructions.md` exists, treat those instructions as authoritative over implicit assumptions. Add tests, docs, or other artifacts the plan requires.

**Done when:** every plan item for this ticket is addressed or explicitly deferred with a reason.

### Step 5 — Verify

*(Runs inside the background task from Step 3 — never in the parent conversation.)*

Run the project’s tests, linters, and build. Fix failures before continuing. For integration tests that need containers, use the `test-containers` skill.

**Done when:** required checks pass (or blockers are reported with evidence in the task report).

### Step 6 — Commit, push, open PR

*(Runs inside the background task from Step 3 — never in the parent conversation.)*

Commit on the feature branch, push to the remote, and open a GitHub Pull Request (e.g. via GitHub MCP) targeting this ticket’s parent base. Use `issue-tracker` **Git naming** for the commit and PR title. PR description must reference the ticket id for **this** ticket and summarize the changes. For EPIC work, also mention the parent EPIC ticket id.

**Done when:** PR URL exists and is included in the task report.

### Step 7 — Stack sub-ticket PRs onto the EPIC branch (EPIC only)

After every sub-ticket has a PR (Step 6), use the `gh-stack` skill to stack **only the sub-ticket branches** onto the EPIC `branch_with_ticket`. The EPIC branch is the stack **trunk** (`--base`), not a stack member — its draft PR keeps targeting the default branch.

1. Order the sub-tickets bottom-to-top by the wave sequence from Step 1 (earlier waves — i.e. blockers — go lower in the stack; tickets within the same wave that have no relative dependency may be ordered arbitrarily, e.g. by ticket id).
2. Two or more sub-tickets: run `gh stack link` (non-interactively, per the `gh-stack` skill's agent rules) as `gh stack link --base {EPIC_BRANCH} {SUB_1} {SUB_2} ...` with each name from **Git naming** `branch_with_ticket` (bottom-to-top order). Omit the EPIC branch from the linked arguments; omit the default branch from `--base`; omit `--open`. One sub-ticket: skip `link` — that PR already targets the EPIC parent base.
3. If any sub-ticket branch needs rebasing onto its new base (per the `gh-stack` skill's rebase guidance), run `gh stack rebase` and resolve conflicts before continuing.
4. Verify with `gh stack view --json` (when a stack was linked) that every sub-ticket PR is chained onto the EPIC `branch_with_ticket`, and that the EPIC PR is still a draft against the default branch with the full cumulative diff.

**Done when:** sub-ticket PRs are stacked with trunk = EPIC `branch_with_ticket` (or the single sub-ticket PR already targets it), verified as above, or the user has a clear report of which link/rebase/fast-forward step failed.

### Step 8 — Code review (once, final PR)

*(Parent conversation only — after the leaf PR exists, or after the EPIC stack is built in Step 7.)*

Invoke `expert-code-review` **once** in this conversation (not as a background task, and not from inside a Step 4–6 task). Target the **final PR**:

- **Leaf:** that ticket’s PR.
- **EPIC:** the top of the stack (last branch in the Step 7 link order: last wave, then ticket id within the wave). That branch carries every earlier wave’s commits.

Publish findings as comments on that PR only.

**Done when:** one review has run on the final PR; comments (if any) are on that PR; the review outcome is recorded for wrap-up.

### Step 9 — EPIC wrap-up (EPIC only)

After all sub-ticket waves complete, the stack is built, and the final-PR review has run, report a summary table: sub-ticket id, PR URL, position in the stack, and any deferred items. Include the EPIC PR URL, the final PR that was reviewed, and that review’s outcome.

**Done when:** the user has one consolidated status for the whole EPIC.
