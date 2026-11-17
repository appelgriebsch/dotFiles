---
name: code-reviewer
description: Load this skill when the user wants an expert code review of a pull
  request, diff, branch, whole repository (main branch), or a named
  path/snippet. It collects the changeset or source code, delegates to the
  'domain-expert' persona in Reviewer mode, merges and contextualizes the findings,
  applies review standards, formats all returned review comments into a
  structured report (overall assessment, critical issues, warnings, suggestions,
  strengths), and, for PR triggers, posts/updates inline and summary comments on the PR.
disable-model-invocation: true
---
# Code Reviewer

Act as the orchestrator for an expert code review. The flow is always:
**collect input → invoke `domain-expert` (mode `Reviewer`) → merge and contextualize findings → apply review standards → format results → (PR only) publish comments back to the PR**.

## Step 1: Collect the code to review

Determine the trigger and collect the relevant code. Never invent code — read it from the actual source (GitHub connector tools, repository filesystem, or user-provided snippets).

Mechanically identify:
- **Call shape:** PR/diff · branch/whole-repo · named paths/snippet
- **Screening corpus** follows `domain-expert` (PR/diff → changeset; branch/whole-repo → whole source; named paths → those paths) and the **focus material** experts will review
- User concerns (security, performance, idioms, correctness, architecture, etc.)
- Constraints (runtime, conventions). If unspecified, ask experts to cover quality, security, performance, testing, and dependency hygiene
- Branch/PR: ensure the correct repo and branch (stash uncommitted work before switching). If not in the right repo, offer a temp clone

**Done when:** call shape, screening corpus, focus material, and concerns are listed; working tree is on the right branch/repo (or user declined); **zero findings** produced.

## Step 2: Invoke domain-expert in Reviewer mode

Load the `domain-expert` persona (which wraps and caches the external `ask-the-expert` skill) and follow its instructions with mode **Reviewer**. Pass it the collected code/diff plus any useful context (repo language, framework, PR description). Record **all** review comments it returns — location, severity, problem, and suggested fix — without dropping or softening any of them.

**Done when:** `domain-expert` has completed; every technology it matched has expert findings (or an explicit no-expert gap).

## Step 3: Merge and contextualize findings

Merge **expert** findings only. Eliminate duplicates; lead with impact; answer the user's questions first. If a PR exists, skip comments already addressed on the PR. Apply review standards to ensure consistency and quality.

**Done when:** one non-redundant finding list exists (sourced from experts) and standards have been applied.

## Step 4: Format the review report

Present every recorded comment in exactly this shape:

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

**Bill of materials**
Path, created or updated, critical updates, and CVEs from the consult.

**Ponytail**
The consult's close: what was skipped or not checked, and the risk.
```

Omit an empty section's heading entirely. Sort comments within each severity section by importance, and give each comment the location (file and line/hunk) it was reported for.

## Step 5: Publish back to the PR (PR triggers only)

If the initial trigger was a PR:

1. Check the PR for existing review comments (from step 1).
2. Push new comments to the PR: one summary comment with the full formatted report, plus inline comments (with potential fixes included) on the exact files/lines each finding refers to.
3. If a finding repeats or extends an existing comment, update that comment or reply to it instead of creating a duplicate.
4. Confirm in your final answer what was posted, updated, or replied to, and link the PR.
