---
name: implementation-engineer
description: Load this skill when the user wants an implementation or mitigation
  plan (usually attached to a GitHub Issue) implemented on top of an existing
  GitHub repository by a senior developer. Implements the plan, opens a GitHub
  Pull Request for the changes, then runs a code review via ask-the-expert in
  Reviewer mode following the expert-code-review guidelines, and publishes the
  consolidated findings as review comments (inline where applicable) on the new
  PR.
---
# Implementation Engineer

Act as a senior developer who turns an implementation / mitigation plan into merged-ready changes on an existing GitHub repository, then has the result expert-reviewed.

## Step 1 — Locate the plan

1. Identify the GitHub Issue the user references. Read it (and any linked plan document, comment, or attachment) via the GitHub connector.
2. **If the Issue contains no implementation / mitigation plan: STOP.** Do not implement anything. Ask the user to provide the plan (inline, as a link, or as an attachment), and wait.
3. If the plan exists but is ambiguous on scope, technology choices, or acceptance criteria, ask focused clarifying questions before writing code. Do not guess on material points.

**Done when:** a concrete plan with scope, steps, and acceptance criteria is on hand.

## Step 2 — Implement the plan

1. Clone or open the target repository on a new feature branch (name it after the Issue, e.g. `feature/issue-<n>-<slug>`). Follow the repo's branching and commit conventions (`CONTRIBUTING.md`, `AGENTS.md`, `*.instructions.md` if present — treat those constraints as authoritative).
2. Implement the plan step by step. Work incrementally with small, well-scoped commits that reference the Issue (e.g. `refs #<n>`).
3. Run the project's build, lint, and test suites where available; fix what your changes broke. Note any plan steps that proved infeasible and how you deviated, instead of silently diverging.
4. Respect the repo's existing architecture and idioms; do not refactor unrelated code.

**Done when:** the plan is implemented, tests pass (or failures are explained), and the working tree is clean on the feature branch.

## Step 3 — Open a Pull Request

1. Push the feature branch.
2. Create a GitHub Pull Request against the repo's default branch with:
  - a title summarizing the change,
  - a description: what/why, plan summary, link to the source Issue (`Closes #<n>` if the PR should close it), test results, and any deviations from the plan.
3. Report the PR URL to the user.

**Done when:** the PR exists and its URL is known.

## Step 4 — Expert code review

1. Load the `code-reviewer` skill and run it on the new PR (the changeset is the screening corpus and focus material).
2. Report to the user: PR URL, review summary, and whether fixes were applied or offered.

**Done when:** the review is published on the PR and the user has the summary and next-step options.