---
name: expert-code-review
description: Review recently written or modified code, a branch, or a PR — including security, performance, idioms, architecture, or CI/CD (GitHub Actions, Terraform, Helm, shell pipelines).
argument-hint: "Please provide the branch, or GitHub Pull Request you would like reviewed."
---

Orchestrate review via `ask-the-expert` in **Review** mode, then merge and deliver one prioritized review. Domain findings come from matched experts. Screening and inventory are routing only.

## Step 1 — Scope (routing material only)

If scope is ambiguous, ask **one** focused clarifying question and wait; inventory and review start after scope is clear.

Identify **mechanically** — collect material, do not analyze quality:

- **Call shape:** PR/diff · branch/whole-repo · named paths/snippet
- **Screening corpus** follows `ask-the-expert` (PR/diff → changeset; branch/whole-repo → whole source; named paths → those paths) and the **focus material** experts will review (same corpus unless the user narrowed further)
- User concerns (security, performance, idioms, correctness, architecture, etc.)
- Constraints (runtime, conventions). If unspecified, ask experts to cover quality, security, performance, testing, and dependency hygiene
- Branch/PR: ensure the correct repo and branch (stash uncommitted work before switching). If not in the right repo, offer a temp clone

Load `issue-tracker` when the branch or PR may map to a ticket id.

If `AGENTS.md` or `*.instructions.md` exists, treat those constraints as authoritative **pass-through** to experts.

**Done when:** call shape, screening corpus, focus material, and concerns are listed; working tree is on the right branch/repo (or user declined); **zero findings** produced.

## Step 2 — Consult experts

Invoke `ask-the-expert` in **Review** mode with call shape, screening corpus, focus material, user questions/concerns, architecture/runtime context, and AGENTS/instructions constraints. Supply the corpus and question; that skill matches and dispatches. Use the severity groups it returns.

**Done when:** `ask-the-expert` has completed; every technology it matched has expert findings (or an explicit no-expert gap). Still no orchestrator-originated domain findings.

## Step 3 — Merge and contextualize

Merge **expert** findings only. Eliminate duplicates; lead with impact; answer the user’s questions first. If a PR exists, skip comments already addressed on the PR. If the branch/PR maps to **Identity** `ticket_id_pattern`, get the ticket via **Operations** get and validate the implementation against it.

Apply [`references/review-standards.md`](references/review-standards.md).

**Done when:** one non-redundant finding list exists (sourced from experts) and standards have been applied.

## Step 4 — Deliver

Format:

```
### Code Review: [what was reviewed]

**Overall Assessment**
2–4 sentences: quality, strengths, single most critical finding.

**Critical Issues 🔴** *(Must fix)*
- **Location** / **Problem** / **Fix**

**Warnings ⚠️** *(Should fix)*
Same shape as Critical.

**Suggestions 💡** *(Consider)*
Brief optional improvements.

**Strengths ✅**
2–3 concrete positives.
```

Then: if a PR exists and there are new findings, ask whether to publish comments (skip already-published ones; close outdated). If no PR, offer saving to `code_review_<project>_<commit>.md`.

**Done when:** review shown to the user; publish/save handled per their answer.
