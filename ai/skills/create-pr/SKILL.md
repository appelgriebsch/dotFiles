---
name: create-pr
description: "Create or update a pull request for GitHub repositories. Use when: creating a PR, opening a pull request, pushing changes to an existing PR, rebasing with main, squashing commits, force-pushing with lease, updating a PR branch."
argument-hint: "Optionally provide a GitHub Issue id or describe the changes"
---

# Create / Update Pull Request

Workflow for creating new pull requests or pushing updates to existing PRs in GitHub repositories. Ensures a clean git history with rebased, single-commit branches.

## When to Use

- Creating a new pull request from local changes
- Pushing additional changes to an existing open PR
- Rebasing a feature branch with `main`

## Core Principles

1. **Always rebase with `main`** — the feature branch must be up to date before any push
2. **Single commit per PR** — squash all local changes into one well-formatted commit
3. **Never force push** — always use `--force-with-lease` to avoid overwriting remote changes
4. **Check for existing PRs** — before creating a new PR, verify if one already exists for the branch

---

## Naming Conventions

Inherited from the implement workflow. These apply to branches, commits, and PR titles.

### Branch Name

| Scenario | Format | Example |
|----------|--------|---------|
| With GitHub Issue | `feature/gh-{GITHUB_ISSUE_ID}` or `feature/gh-{GITHUB_ISSUE_ID}-{short-description}` | `feature/gh-123` or `feature/gh-123-add-min-rate-kpis` |
| Without GitHub Issue | `feature/{meaningful-name}` | `feature/add-billing-kpis` |

**Rules:**
- Branch MUST start with `feature/`
- Use lowercase kebab-case for the description portion
- Keep it concise — branch names are not sentences

### Commit Message

| Scenario | Format | Example |
|----------|--------|---------|
| With GitHub Issue | `GH-{GITHUB_ISSUE_ID}: {description}` | `GH-123: Refactor KPI aggregation to use BillingKpis.accumulate()` |
| Without GitHub Issue | `{description}` | `Fix typo in field zone service` |

### PR Title

| Scenario | Format | Example |
|----------|--------|---------|
| With GitHub Issue | `GH-{GITHUB_ISSUE_ID}: {Description}` | `GH-123: Add min rate KPI fields to execution service` |
| Without GitHub Issue | `{Proper description}` | `Fix KPI accumulation logic in execution service` |

### PR Description

Must include:
- Summary of what changed and why
- Related GitHub Issue links (if applicable)
- Must accurately reflect the actual code changes — never fabricate or guess endpoint URLs, class names, or behavior

---

## Pre-Push Checklist

Before committing and pushing, verify:

1. **No unused imports** — remove ALL unused `import` statements from every changed file. Java files must not contain imports that are not referenced in the code.
2. **No commented-out code** — remove dead code instead of commenting it out.

---

## Procedure: Create a New PR

Use this flow when the user asks to **create a PR** or **open a pull request**.

### Step 1: Identify Context

1. **Determine the GitHub Issue** (if any):
   - If the user provides an issue ID → use it for naming
   - If the current branch already follows `feature/gh-{GITHUB_ISSUE_ID}` → extract the issue ID
   - If neither → ask the user for a short description of the changes, or derive one from the diff
2. **Confirm the branch name** follows the naming convention above. If the user is on `main` or an incorrectly named branch, create and switch to the correct feature branch first.

### Step 2: Rebase with Main

```bash
# Fetch latest main
git fetch origin main

# Rebase current branch onto main
git rebase origin/main
```

If there are **rebase conflicts**:
- Show the conflicts to the user
- Help resolve them interactively
- Continue the rebase: `git rebase --continue`

### Step 3: Squash into a Single Commit

All local changes must be squashed into one commit with a proper message.

```bash
# Find the merge base with main
MERGE_BASE=$(git merge-base HEAD origin/main)

# Soft reset to the merge base (keeps all changes staged)
git reset --soft "$MERGE_BASE"

# Create the single commit
git commit -m "GH-{GITHUB_ISSUE_ID}: {description}"
```

If there are **no changes** after reset (branch is identical to main), inform the user.

### Step 4: Check for Existing PRs

Before creating a new PR, check if the current branch already has an open PR:

```bash
# Get current branch name
BRANCH=$(git branch --show-current)
```

Then use GitHub MCP tools to search for open PRs with `head` matching the current branch.

- If an **open PR exists** → inform the user and ask whether to update the existing PR or create a new one
- If **no open PR** → proceed to create

### Step 5: Push the Branch

```bash
# Push with force-with-lease (safe rewrite after squash/rebase)
git push --force-with-lease origin "$(git branch --show-current)"
```

### Step 6: Create the Pull Request

1. **Search for PR templates** in the repo:
   - Check `.github/PULL_REQUEST_TEMPLATE.md` or `.github/PULL_REQUEST_TEMPLATE/`
   - Use the template if found
2. **Create the PR** using GitHub MCP tools:
   - **Title**: Follow naming convention (see above)
   - **Description**: Accurate summary of changes, GitHub Issue links
   - **Base branch**: `main`
3. **Share the PR link** with the user

---

## Procedure: Push Changes to an Existing PR

Use this flow when the user asks to **push changes**, **update the PR**, or **add a commit** — without explicitly asking to create a new PR.

### Step 1: Verify Existing PR

```bash
BRANCH=$(git branch --show-current)
```

Use GitHub MCP tools to check for an open PR on the current branch.

- If **no open PR** exists → inform the user and ask if they want to create one (switch to the "Create a New PR" flow)
- If an **open PR** exists → proceed

### Step 2: Rebase with Main

```bash
git fetch origin main
git rebase origin/main
```

Resolve any conflicts if they arise.

### Step 3: Commit the Changes

Stage and commit the new changes with a proper message:

```bash
git add -A
git commit -m "GH-{GITHUB_ISSUE_ID}: {description of this change}"
```

This adds a **new commit on top** of the existing PR commits — it does NOT squash.

### Step 4: Push with Force-with-Lease

```bash
git push --force-with-lease origin "$(git branch --show-current)"
```

**Why `--force-with-lease`?** After rebasing, a regular `git push` will be rejected because the history diverged. `--force-with-lease` safely force-pushes only if the remote branch hasn't been updated by someone else since our last fetch. This prevents accidentally overwriting a teammate's commits.

### Step 5: Update PR Description

If the new changes significantly alter the scope, update the PR description using GitHub MCP tools to reflect the latest state.

---

## Quick Reference: Command Cheat Sheet

| Action | Command |
|--------|---------|
| Fetch latest main | `git fetch origin main` |
| Rebase onto main | `git rebase origin/main` |
| Squash all commits into one | `git reset --soft $(git merge-base HEAD origin/main) && git commit -m "msg"` |
| Push (safe force) | `git push --force-with-lease origin $(git branch --show-current)` |
| Check current branch | `git branch --show-current` |
| Check for open PRs | Use GitHub MCP tools: search PRs with `head:{branch}` |
