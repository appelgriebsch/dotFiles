---
name: expert-code-review
description: Expert code review via domain specialists. Use when the user wants recently written or modified code reviewed, a branch or PR reviewed, or feedback on security, performance, idioms, or architecture.
argument-hint: "Please provide the branch, or GitHub Pull Request you would like reviewed."
---

Orchestrate review: scope the code, consult experts via `ask-the-expert` in **Review** mode, deliver one prioritized review. You are not the domain expert.

## Workflow

### Step 1 — Scope

Identify:

- Code in scope (default: only what the user most recently wrote or explicitly named — not a full codebase audit unless requested)
- User concerns (security, performance, idioms, correctness, architecture, etc.)
- Constraints (runtime, conventions). If unspecified, cover quality, security, performance, testing, and dependency hygiene.
- Branch/PR: ensure the correct repo and branch (stash uncommitted work before switching). If not in the right repo, offer a temp clone.

If `AGENTS.md` or `*.instructions.md` exists, treat those constraints as authoritative.

**Done when:** in-scope paths/diff and concerns are listed; working tree is on the right branch/repo (or user declined).

### Step 2 — Consult experts

Invoke `ask-the-expert` in **Review** mode with: exact code in scope, user questions, architecture/runtime context, and AGENTS/instructions constraints.

`ask-the-expert` owns whole-repo technology discovery and **must** dispatch to every matched domain expert; do not pre-filter experts to the diff languages alone. Use the severity groups it returns. If it reports no dedicated expert for a technology, surface that gap — do not quietly replace it with your own generalist domain review (you may still merge non-domain process notes).

**Done when:** `ask-the-expert` has completed; every technology it matched has expert findings (or an explicit no-expert gap).

### Step 3 — Merge and contextualize

Merge findings without re-deriving severity from scratch. Eliminate duplicates; lead with impact; answer the user’s questions first. If a PR exists, skip comments already addressed on the PR. If the branch/PR maps to a GitHub Issue, validate the implementation against that ticket.

Before delivery, apply [`references/review-standards.md`](references/review-standards.md).

**Done when:** one non-redundant finding list exists and standards have been applied.

### Step 4 — Deliver

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
