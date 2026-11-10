---
name: code-reviewer
description: Load this skill when the user wants an expert code review of a pull
  request, diff, branch, whole repository (main branch), or a named
  path/snippet. It collects the changeset or source code, delegates to the
  'ask-the-expert' skill in Reviewer mode, formats all returned review comments
  into a structured report (overall assessment, critical issues, warnings,
  suggestions, strengths), and, for PR triggers, posts/updates inline and
  summary comments on the PR.
---
# Code Reviewer

Act as the orchestrator for an expert code review. The flow is always:
**collect input → invoke `ask-the-expert` (mode `Reviewer`) → format results → (PR only) publish comments back to the PR**.

## Step 1: Collect the code to review

Determine the trigger and collect the relevant code. Never invent code — read it from the actual source (GitHub connector tools, repository filesystem, or user-provided snippets).

a) **PR or diff**: Fetch the PR's changed files and unified diff (patch). Include file paths, line ranges, and enough surrounding context for each hunk to be understandable on its own. Also fetch any existing review comments already on the PR.

b) **Branch or whole repository**: Collect the full source code from the `main` branch (or the branch the user names). Skip vendored/dependency directories (`node_modules`, `vendor`, `dist`, lock files) unless the user asks for them. For large repos, prioritize entry points, configuration, and source directories, and state what was excluded.

c) **Named path or snippet**: Collect exactly the files/directories or snippets the user named, with file names and, for files, the relevant line ranges.

## Step 2: Invoke ask-the-expert in Reviewer mode

Load the `ask-the-expert` skill and follow its instructions with mode **Reviewer**. Pass it the collected code/diff plus any useful context (repo language, framework, PR description). Record **all** review comments it returns — location, severity, problem, and suggested fix — without dropping or softening any of them.

## Step 3: Format the review report

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
```

Omit an empty section's heading entirely. Sort comments within each severity section by importance, and give each comment the location (file and line/hunk) it was reported for.

## Step 4: Publish back to the PR (PR triggers only)

If the initial trigger was a PR:

1. Check the PR for existing review comments (from step 1).
2. Push new comments to the PR: one summary comment with the full formatted report, plus inline comments (with potential fixes included) on the exact files/lines each finding refers to.
3. If a finding repeats or extends an existing comment, update that comment or reply to it instead of creating a duplicate.
4. Confirm in your final answer what was posted, updated, or replied to, and link the PR.
