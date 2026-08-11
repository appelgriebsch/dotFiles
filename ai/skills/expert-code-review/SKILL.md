---
name: expert-code-review
description: Expert code review via domain specialists. Use when the user wants recently written or modified code reviewed, a branch or PR reviewed, or feedback on security, performance, idioms, architecture, or CI/CD delivery automation (GitHub Actions, Terraform, Helm, shell pipelines).
argument-hint: "Please provide the branch, or GitHub Pull Request you would like reviewed."
---

Orchestrate review: scope the code for **expert routing only**, consult experts via `ask-the-expert` in **Review** mode, then merge and deliver one prioritized review. You are **not** the domain expert.

## Hard rules

1. **No pre-review** — Do **not** produce findings, severities, strengths, suggested fixes, or quality judgments before experts return. Do not “skim for issues,” “first-pass review,” or draft Critical/Warning/Suggestion items yourself at any point before Step 3.
2. **Screening = routing only** — Any pass over code before experts run exists solely to (a) define the review corpus and (b) decide which experts `ask-the-expert` should call. It is never a review.
3. **Screening corpus matches the call shape**
   - **PR or diff** → screen **only the changeset** (changed paths + patch hunks). Do not inventory the rest of the tree for expert matching.
   - **Branch or whole-repo** (or an explicit full-source request) → screen the **whole source** (tree, manifests, lockfiles, configs, migrations, workflows, Terraform/Helm/IaC as needed for detection).
   - **Named paths / snippet only** → screen those paths/snippet (expand only if required to resolve the named target).
4. **Experts own domain judgment** — All domain findings come from matched experts via `ask-the-expert`. If a technology in the corpus has no expert, surface the gap; do not fill it with your own generalist domain review (non-domain process notes are fine).

## Workflow

### Step 1 — Scope (routing material only)

Identify **mechanically** — collect material, do not analyze quality:

- **Call shape:** PR/diff · branch/whole-repo · named paths/snippet
- **Screening corpus** (per hard rule 3) and the **focus material** experts will review (same corpus unless the user narrowed further)
- User concerns (security, performance, idioms, correctness, architecture, etc.)
- Constraints (runtime, conventions). If unspecified, ask experts to cover quality, security, performance, testing, and dependency hygiene
- Branch/PR: ensure the correct repo and branch (stash uncommitted work before switching). If not in the right repo, offer a temp clone

If `AGENTS.md` or `*.instructions.md` exists, treat those constraints as authoritative **pass-through** to experts — not as something you review against yourself in this step.

**Forbidden in this step:** reading the corpus “to form an opinion,” summarizing problems, or drafting any finding list.

**Done when:** call shape, screening corpus, focus material, and concerns are listed; working tree is on the right branch/repo (or user declined); **zero findings** produced.

### Step 2 — Consult experts

Invoke `ask-the-expert` in **Review** mode with:

- Call shape + explicit **screening corpus** definition (changeset vs whole source vs named paths)
- Exact focus material (diff, paths, or tree)
- User questions/concerns
- Architecture/runtime context and AGENTS/instructions constraints

`ask-the-expert` owns technology discovery **inside that screening corpus** and **must** dispatch to every expert matched from it. Do not pre-filter, substitute, or run a parallel generalist review. Use the severity groups it returns.

**Done when:** `ask-the-expert` has completed; every technology it matched has expert findings (or an explicit no-expert gap). Still no orchestrator-originated domain findings.

### Step 3 — Merge and contextualize

Merge **expert** findings only — do not re-derive severity from scratch or invent new domain issues. Eliminate duplicates; lead with impact; answer the user’s questions first. If a PR exists, skip comments already addressed on the PR. If the branch/PR maps to a GitHub Issue, validate the implementation against that ticket (use the GitHub MCP for retrieval).

Before delivery, apply [`references/review-standards.md`](references/review-standards.md).

**Done when:** one non-redundant finding list exists (sourced from experts) and standards have been applied.

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
