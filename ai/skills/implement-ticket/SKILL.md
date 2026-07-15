---
name: implement-ticket
description: Execute a brainstorm/troubleshoot plan for a GitHub issue (branch, implement, PR, review).
argument-hint: "Please provide the GitHub Issue id for the improvement or bug ticket you would like to implement."
disable-model-invocation: true
---

## Workflow

### Step 1 — Parse the Request

Verify the input is an open GitHub Issue via the GitHub MCP and that it contains an implementation plan.

**Done when:** issue loaded with a plan, or the user was told to run `brainstorm` / `troubleshoot` first and the run stopped.

### Step 2 — Sync main

Ensure the local repo is up to date with the main branch. Pull and resolve merge conflicts when possible.

**Done when:** main is current, or the user was asked to resolve conflicts manually and the run stopped.

### Step 3 — Ensure feature branch

Use branch name `feature/gh-{GITHUB_ISSUE_ID}`. Create it if missing; check it out if it exists.

**Done when:** the working branch is `feature/gh-{id}`.

### Step 4 — Implement the plan

Apply the plan’s changes (code, config, infrastructure). If `AGENTS.md` or `*.instructions.md` exists, treat those instructions as authoritative over implicit assumptions. Add tests, docs, or other artifacts the plan requires.

**Done when:** every plan item is addressed or explicitly deferred with a reason.

### Step 5 — Verify

Run the project’s tests, linters, and build. Fix failures before continuing. For integration tests that need containers, use the `test-containers` skill.

**Done when:** required checks pass (or blockers are reported to the user with evidence).

### Step 6 — Commit, push, open PR

Commit on the feature branch, push to the remote, and open a GitHub Pull Request (e.g. via `gh pr create`). PR description must reference the GitHub Issue id and summarize the changes.

**Done when:** PR URL exists and is reported.

### Step 7 — Code review

Run the `expert-code-review` skill on the branch/PR. Offer to publish findings to the PR when appropriate.

**Done when:** review delivered to the user (and published to the PR if the user agreed); PR URL + review outcome reported.
