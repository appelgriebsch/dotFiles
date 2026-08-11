---
name: implement-ticket
description: Execute a brainstorm/troubleshoot plan for a GitHub issue or EPIC (branch, implement, PR, review). Abort if needs-brainstorm/needs-troubleshoot labels remain; require has-plan (or a body plan). For EPICs, require every sub-ticket ready, sequence by blockers, implement independent tickets in parallel, and stack all sub-ticket PRs onto the EPIC PR at the end using gh-stack.
argument-hint: "Please provide the GitHub Issue id for the improvement, bug ticket, or EPIC you would like to implement."
disable-model-invocation: true
---

## Workflow

### Step 1 — Parse the Request

Verify the input is an open GitHub Issue via the GitHub MCP. Load the issue (**body, labels, links**). Detect whether it is an **EPIC** (has the `epic` label and/or is parent with one or more linked sub-tickets / child issues) or a **leaf ticket** (no sub-tickets). Prefer the `epic` label when present; if the label is missing but children are linked, treat as EPIC anyway.

Labels used by `brainstorm` / `troubleshoot` (exact names):

| Label | Implement-ticket meaning |
| --- | --- |
| `epic` | Parent of sub-tickets — run EPIC path |
| `has-plan` | Plan was filed; still verify body has steps (label alone is not enough if the body is empty) |
| `needs-brainstorm` | **Hard abort** — user must re-run `brainstorm` first |
| `needs-troubleshoot` | **Hard abort** — user must re-run `troubleshoot` first |

#### Readiness gates (leaf and every EPIC sub-ticket)

Apply **before** branching or coding. Order matters:

1. **Grooming labels (hard abort).** If the issue has `needs-brainstorm` and/or `needs-troubleshoot`:
   - List the issue id/title and which grooming label(s) are set.
   - Tell the user which skill to run (`brainstorm` and/or `troubleshoot`) to clear the gap.
   - **Abort.** Do not implement while either grooming label remains — even if `has-plan` is also present (best-effort plan with residual unknowns).
2. **Plan presence.** The issue is ready only when **both**:
   - The body contains an **implementation plan** (step-by-step guidance from `brainstorm` / `troubleshoot`, not only a goal or title), **and**
   - Preferably `has-plan` is set. If `has-plan` is **missing** but a clear body plan exists (legacy tickets), proceed and note the missing label. If `has-plan` is set but the body has no workable plan, **abort** and tell the user to re-run `brainstorm` / `troubleshoot` so the plan is written into the issue.
3. If there is no plan and no grooming label: tell the user to run `brainstorm` or `troubleshoot` first, and **abort**.

**Leaf ticket**

- Run the readiness gates on this issue only.
- If ready: proceed to Step 2 with this ticket’s plan.

**EPIC**

1. Collect **every** sub-ticket (full details for each — body, **labels**, state, links, blockers).
2. Run the readiness gates on the **EPIC** issue itself (grooming labels on the parent also abort the whole run).
3. Run the readiness gates on **every** sub-ticket.
4. If **any** sub-ticket fails (grooming label, missing plan, or `has-plan` without a body plan): list those issue ids/titles and reasons, tell the user what to re-run, and **abort**. Do not implement partial EPICs.
5. If all sub-tickets are ready: read each ticket’s **blocking edges** (issue numbers that must finish first, or “none”) and build an execution sequence — a dependency graph ordered into **waves**. A wave is the set of remaining tickets whose blockers are already done (or have none); tickets in the same wave may run **in parallel**. Tickets with blockers wait for later waves.

**Done when:** a leaf ticket that passes readiness is loaded, **or** an EPIC has all sub-tickets loaded, every one (and the parent) passes readiness, and the wave sequence is written; **or** the run aborted with a clear report (grooming labels, missing plan, or missing issue).

### Step 2 — Sync main

Ensure the local repo is up to date with the main branch. Pull and resolve merge conflicts when possible.

**Done when:** main is current, or the user was asked to resolve conflicts manually and the run stopped.

### Step 3 — Implement (leaf or EPIC waves)

**Hard rule — background implement unit:** for every ticket (leaf or EPIC sub-ticket), dispatch **Steps 4–7 as one background task** (`task` / `general-purpose`, `mode: "background"`). Do this **always**, including when only one ticket is in flight — background is for **context isolation**, not only for parallelism. The parent conversation **orchestrates only**: prepare branch/worktree, launch the task, wait, read the task report. It must **not** implement, verify, open the PR, or review inline.

Prompt each background task with the full ticket plan, ticket id, branch name (and worktree path if used), any `AGENTS.md` / `*.instructions.md` paths, and the full Step 4–7 instructions below. When the task finishes, take status only from its report (PR URL, review outcome, deferred items, failures) — do not re-run the plan in the parent context.

#### Leaf ticket

Use branch name `feature/gh-{GITHUB_ISSUE_ID}`. Create it if missing; check it out if it exists. Then launch **one** background task for Steps 4–7 on that branch.

**Done when:** the working branch is `feature/gh-{GITHUB_ISSUE_ID}` and the background task has completed Steps 4–7 (or failed with a clear report).

#### EPIC — sequence and parallel

Before starting any wave, create the EPIC's own integration branch: `feature/gh-{GITHUB_EPIC_ID}` off the up-to-date main branch. Push it and open a **draft** PR for it (title references the EPIC id, body summarizes the EPIC and lists the sub-tickets to be stacked onto it). This EPIC PR is the eventual base that every sub-ticket PR will be stacked onto in Step 9 — do not merge it manually or squash sub-ticket work into it directly.

Walk the waves from Step 1 in order. Within each wave, start **every** ticket in that wave as its **own** background Steps 4–7 task **in parallel** when possible (isolated branches / worktrees so work does not clobber a shared working tree). Parallelism stacks on top of the always-on background rule — it does not replace it. For each sub-ticket:

1. Branch: `feature/gh-{GITHUB_SUBISSUE_ID}` (create or check out; use a worktree when running in parallel).
2. Launch a **background** task that runs **Steps 4–7** for that sub-ticket only.
3. Treat the sub-ticket as **done for sequencing** only after that task reports a PR (and required verification passed), so later waves see correct blockers.

Do not start a later wave until every ticket in the current wave has finished its background Steps 4–7 task (or failed with a reported blocker). If a parallel unit fails, report which sub-ticket failed and stop starting new waves that depend on it; finish other in-flight independent work when safe.

**Done when:** every sub-ticket with a plan has been through a background Steps 4–7 task in dependency order, or the user has a clear report of which wave/ticket blocked progress.

### Step 4 — Implement the plan

*(Runs inside the background task from Step 3 — never in the parent conversation.)*

Apply the plan’s changes (code, config, infrastructure) for the **current** ticket only. If `AGENTS.md` or `*.instructions.md` exists, treat those instructions as authoritative over implicit assumptions. Add tests, docs, or other artifacts the plan requires.

**Done when:** every plan item for this ticket is addressed or explicitly deferred with a reason.

### Step 5 — Verify

*(Runs inside the background task from Step 3 — never in the parent conversation.)*

Run the project’s tests, linters, and build. Fix failures before continuing. For integration tests that need containers, use the `test-containers` skill.

**Done when:** required checks pass (or blockers are reported to the user with evidence).

### Step 6 — Commit, push, open PR

*(Runs inside the background task from Step 3 — never in the parent conversation.)*

Commit on the feature branch, push to the remote, and open a GitHub Pull Request (e.g. via GitHub MCP). PR description must reference the GitHub Issue id for **this** ticket and summarize the changes. For EPIC work, also mention the parent EPIC issue id.

**Done when:** PR URL exists and is included in the task report.

### Step 7 — Code review

*(Runs inside the background task from Step 3 — never in the parent conversation.)*

Run the `expert-code-review` skill on the branch/PR. Publish findings to the PR when appropriate (or leave them in the task report for the parent to offer).

**Done when:** review outcome and PR URL are in the task report.

### Step 8 — Stack sub-ticket PRs onto the EPIC PR (EPIC only)

After every sub-ticket has a PR (Step 6) and has been through review (Step 7), use the `gh-stack` skill to stack all sub-ticket PRs onto the EPIC PR created in Step 3:

1. Order the sub-tickets bottom-to-top by the wave sequence from Step 1 (earlier waves — i.e. blockers — go lower in the stack; tickets within the same wave that have no relative dependency may be ordered arbitrarily, e.g. by ticket id).
2. Run `gh stack link` (non-interactively, per the `gh-stack` skill's agent rules) with the EPIC branch first, `--base <main/default branch>`, followed by the sub-ticket branches/PR numbers in that bottom-to-top order, e.g.: `gh stack link --base main feature/{GITHUB_EPIC_ID} feature/{GITHUB_SUBISSUE_1} feature/{GITHUB_SUBISSUE_2} ...`. This pushes branches as needed, creates/corrects each PR's base so they chain in dependency order, and forms a single stack rooted at the EPIC PR.
3. If any sub-ticket branch needs rebasing onto its new base to produce a clean diff (per the `gh-stack` skill's rebase guidance), run `gh stack rebase` and resolve conflicts before reporting the stack as ready.
4. Verify the final structure with `gh stack view --json` and confirm every sub-ticket PR is chained beneath the correct dependent and ultimately based on the EPIC PR.

**Done when:** every sub-ticket PR is linked into one stack rooted at the EPIC PR, verified via `gh stack view --json`, or the user has a clear report of which link/rebase step failed.

### Step 9 — EPIC wrap-up (EPIC only)

After all sub-ticket waves complete and the stack is built, report a summary table: sub-ticket id, PR URL, review outcome, position in the stack, and any deferred items. Include the EPIC PR URL.

**Done when:** the user has one consolidated status for the whole EPIC.
