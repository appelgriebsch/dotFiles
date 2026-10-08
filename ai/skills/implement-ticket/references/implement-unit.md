# Implement unit (background)

Runs inside the background task dispatched from `implement-ticket` Step 3 — never in the parent conversation. The task prompt supplies this ticket’s plan, any `RESEARCH` / `DECISION` text, ticket id, branch (and worktree path if used), **parent base** (PR target), and any `AGENTS.md` / `*.instructions.md` paths.

Load `issue-tracker` for **Git naming** and ticket browse URLs.

## Step 4 — Implement the plan

Apply the plan’s changes (code, config, infrastructure) for the **current** ticket only. If `AGENTS.md` or `*.instructions.md` exists, treat those instructions as authoritative over implicit assumptions. When the prompt includes `RESEARCH` or `DECISION` text, treat the first as the facts behind the plan and the second as settled choices, including rejected alternatives, and follow them where they constrain the work. Add tests, docs, or other artifacts the plan requires.

**Done when:** every plan item for this ticket is addressed or explicitly deferred with a reason.

## Step 5 — Verify

Run the project’s tests, linters, and build. Fix failures before continuing. For integration tests that need containers, use the `test-containers` skill.

**Done when:** required checks pass (or blockers are reported with evidence in the task report).

## Step 6 — Commit, push, open PR

Commit on the feature branch and push to the remote. If an open PR already exists for this head (including a grooming **draft** from `brainstorm` / `troubleshoot`), reuse it: retarget its base to this ticket’s parent base if needed, update the body for the implementation diff, and mark it ready for review. Otherwise open a GitHub Pull Request (e.g. via GitHub MCP) targeting this ticket’s parent base.

Commit and PR titles from `issue-tracker` **Git naming**. PR description per that same **Git naming** section (this ticket’s id; parent EPIC id when this is EPIC work).

**Done when:** PR URL exists and is included in the task report.
