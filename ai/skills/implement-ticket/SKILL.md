---
name: implement-ticket
description: Execute a brainstorm/troubleshoot plan for a GitHub issue or EPIC (branch, implement, PR, review). For EPICs, require every sub-ticket plan, sequence by blockers, and implement independent tickets in parallel.
argument-hint: "Please provide the GitHub Issue id for the improvement, bug ticket, or EPIC you would like to implement."
disable-model-invocation: true
---

## Workflow

### Step 1 — Parse the Request

Verify the input is an open GitHub Issue via the GitHub MCP. Load the issue and detect whether it is an **EPIC** (parent with one or more linked sub-tickets / child issues) or a **leaf ticket** (no sub-tickets).

**Leaf ticket**

- Confirm the issue body contains an **implementation plan** (step-by-step implementation guidance from `brainstorm` / `troubleshoot`, not only a goal or title).
- If there is no plan: tell the user to run `brainstorm` or `troubleshoot` first, and **abort**.

**EPIC**

1. Collect **every** sub-ticket (full details for each — body, state, links, blockers).
2. Validate that **every** sub-ticket has an implementation plan attached.
3. If **any** sub-ticket lacks a plan: list those issue ids/titles, tell the user every sub-ticket needs a plan before the EPIC can be implemented, and **abort**. Do not implement partial EPICs.
4. If all sub-tickets have plans: read each ticket’s **blocking edges** (issue numbers that must finish first, or “none”) and build an execution sequence — a dependency graph ordered into **waves**. A wave is the set of remaining tickets whose blockers are already done (or have none); tickets in the same wave may run **in parallel**. Tickets with blockers wait for later waves.

**Done when:** a leaf ticket with a plan is loaded, **or** an EPIC has all sub-tickets loaded, every one has a plan, and the wave sequence is written; **or** the run aborted with a clear missing-plan / missing-issue report.

### Step 2 — Sync main

Ensure the local repo is up to date with the main branch. Pull and resolve merge conflicts when possible.

**Done when:** main is current, or the user was asked to resolve conflicts manually and the run stopped.

### Step 3 — Implement (leaf or EPIC waves)

#### Leaf ticket

Use branch name `feature/gh-{GITHUB_ISSUE_ID}`. Create it if missing; check it out if it exists. Then run **Steps 4–7** for this single ticket.

**Done when:** the working branch is `feature/gh-{id}` and Steps 4–7 for that ticket are complete.

#### EPIC — sequence and parallel

Walk the waves from Step 1 in order. Within each wave, start **every** ticket in that wave **in parallel** when possible (isolated branches / worktrees / subagents so work does not clobber a shared working tree). For each sub-ticket:

1. Branch: `feature/gh-{SUB_ISSUE_ID}` (create or check out).
2. Run **Steps 4–7** for that sub-ticket only (implement its plan, verify, PR, review).
3. Treat the sub-ticket as **done for sequencing** only after its PR exists (and required verification passed), so later waves see correct blockers.

Do not start a later wave until every ticket in the current wave has finished Steps 4–7 (or failed with a reported blocker). If a parallel unit fails, report which sub-ticket failed and stop starting new waves that depend on it; finish other in-flight independent work when safe.

**Done when:** every sub-ticket with a plan has been through Steps 4–7 in dependency order, or the user has a clear report of which wave/ticket blocked progress.

### Step 4 — Implement the plan

Apply the plan’s changes (code, config, infrastructure) for the **current** ticket only. If `AGENTS.md` or `*.instructions.md` exists, treat those instructions as authoritative over implicit assumptions. Add tests, docs, or other artifacts the plan requires.

**Done when:** every plan item for this ticket is addressed or explicitly deferred with a reason.

### Step 5 — Verify

Run the project’s tests, linters, and build. Fix failures before continuing. For integration tests that need containers, use the `test-containers` skill.

**Done when:** required checks pass (or blockers are reported to the user with evidence).

### Step 6 — Commit, push, open PR

Commit on the feature branch, push to the remote, and open a GitHub Pull Request (e.g. via `gh pr create`). PR description must reference the GitHub Issue id for **this** ticket and summarize the changes. For EPIC work, also mention the parent EPIC issue id.

**Done when:** PR URL exists and is reported.

### Step 7 — Code review

Run the `expert-code-review` skill on the branch/PR. Offer to publish findings to the PR when appropriate.

**Done when:** review delivered to the user (and published to the PR if the user agreed); PR URL + review outcome reported.

### Step 8 — EPIC wrap-up (EPIC only)

After all sub-ticket waves complete, report a summary table: sub-ticket id, PR URL, review outcome, and any deferred items. Note the parent EPIC issue.

**Done when:** the user has one consolidated status for the whole EPIC.
