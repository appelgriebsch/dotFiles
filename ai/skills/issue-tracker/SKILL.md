---
name: issue-tracker
description: >-
  Ticket identity, issue MCP, readiness labels, and git naming. Use when
  parsing a ticket id, fetching or creating a tracker issue, applying
  readiness labels, resolving parent/Epic or children, or naming a branch,
  commit, or PR from a ticket.
---

# Issue tracker

**Apply:** before parsing a ticket id, calling issue MCP, applying readiness labels, posting or reading a `PLAN` / `RESEARCH` / `DECISION` doc comment, or naming a branch, commit, or PR. Substitute `{TICKET_ID}` from **Identity**. Use **Operations** tool names. Format git names from **Git naming**. Read **Extras** when creating, updating, labeling, linking, setting an issue type, or checking `implement-ticket` readiness.

**Done when:** every ticket id, browse URL, issue MCP tool, label, issue type, and git name in the run comes from the tables below.

## Identity

| Key | Value |
| --- | --- |
| `ticket_id_pattern` | `\d+` |
| `ticket_id_prefix` | (none — id is the issue number) |
| `ticket_id_example` | `42` |
| `ticket_id_aliases` | optional `#` or `gh-` prefix; or a **Git naming** `branch_with_ticket` |
| `browse_url_template` | `https://github.com/{owner}/{repo}/issues/{TICKET_ID}` |
| `mcp_server` | `github` |

`{owner}` / `{repo}` come from the current workspace `origin` remote. Pass them on every MCP call; do not hard-code a repository.

A value matches a ticket id when:

- it is a browse URL from which `{TICKET_ID}` can be extracted, or
- it matches `ticket_id_aliases` (`#42`, `gh-42`, `feature/gh-42`), or
- it matches `ticket_id_pattern` (`42`) **and** **Operations** get returns an issue in the current repo (prefer **open** when the caller requires an open ticket).

Otherwise it is not a ticket id.

## Operations

| Operation | MCP tool | Notes |
| --- | --- | --- |
| get | `github__issue_read` | method=`get`; `issue_number` = ticket id. Returns body, labels, and best-effort hierarchy flags. |
| update | `github__issue_write` | method=`update`; existing issues only; `issue_number` required |
| create | `github__issue_write` | method=`create`; returns the new issue number. `type` from **Extras** issue types. A sub-task also sets `parent_issue_number` to the parent issue number (`parent_issue_number` is not combined with `issue_fields`). |
| comment | `github__add_issue_comment` | a new doc comment, or any other comment |
| comment_update | `github__update_issue_comment` | replace an existing doc comment; `comment_id` is that comment’s id |
| comments | `github__issue_read` | method=`get_comments`; page with `perPage` 100 until a short page |
| post_doc | see **Post a doc comment** | one comment per kind; body is the document or a ticket-ref pointer |
| read_doc | see **Read a doc comment** | latest comment for that kind; follow a ticket-ref pointer |
| delete_ticket_ref | see **Delete a ticket ref** | after the implementing PR has merged |
| parent | `github__issue_read` | method=`get_parent` |
| children | `github__issue_read` | method=`get_sub_issues` |
| link_child | `github__sub_issue_write` | method=`add`; `issue_number` = parent; `sub_issue_id` is the child's **id**, not its number |
| list | `github__list_issues` | list/filter issues in the repo |
| search | `github__search_issues` | natural-language issue search |
| labels_list | `github__list_label` | repo labels |
| labels_create | `github__label_write` | method=`create`; name required |
| list_issue_types | `github__list_issue_types` | types enabled for `{owner}` / `{repo}` |

### Post a doc comment

`{KIND}` is `PLAN`, `RESEARCH`, or `DECISION`. `{FILE}` is `{KIND}.md`. One issue comment holds that document. The issue description stays the STE-100 text from filing. These files stay off every branch that merges.

When `# {KIND}`, a blank line, and the scratch file together are at most 65536 characters, the comment body is that text:

```
# {KIND}

{scratch file}
```

When they are longer, publish `{FILE}` on **Git naming** `ticket_ref` for this issue, in a temporary worktree so the current checkout stays put:

1. `git fetch origin`.
2. When `origin/` + `ticket_ref` exists, check that ref out in the worktree. Otherwise `git switch --orphan` to `ticket_ref` in the worktree.
3. Write `{FILE}` at the worktree root. Commit only that path. Message from `commit_with_ticket` for this issue.
4. `git push -u origin` the `ticket_ref`. Remove the worktree. Open no pull request for this ref.

The comment body is then the header, a blank line, and one pointer line:

```
# {KIND}

ticket/gh-{TICKET_ID}:{FILE}
```

The first line is exactly `# {KIND}`. Then:

1. **Operations** comments on the issue.
2. When a comment’s first non-empty line is `# {KIND}`, **Operations** comment_update that comment. Several matches: update the one with the latest `updated_at`.
3. Otherwise **Operations** comment with the body above.

A later post that fits in 65536 characters replaces the comment with the full text. The file on the ref stays until **Delete a ticket ref**.

### Read a doc comment

Page **Operations** comments. Take the comment with the latest `updated_at` whose first non-empty line is `# {KIND}`. Remove that header line and the following blank line. No such comment means this issue has no `{KIND}`.

When what remains is exactly one line `ticket/gh-{id}:{FILE}` and `{FILE}` is `{KIND}.md`, `git fetch origin ticket/gh-{id}` and `git show origin/ticket/gh-{id}:{FILE}`. That output is the document. A missing ref or path: report it and treat this issue as having no `{KIND}`.

Otherwise what remains is the document. `PLAN` is the implementation plan. `RESEARCH` and `DECISION` are ticket context on the main issue.

A comment whose whole body is `[{filename}](url)`, with `{filename}` `PLAN.md`, `RESEARCH.md`, or `DECISION.md`, is an older upload of that kind (`PLAN.md` → `PLAN`). Download the URL with the bearer token from `gh auth token`. Prefer a `# {KIND}` comment when both exist.

### Delete a ticket ref

Run only after the implementing pull request has merged. For a leaf, that is the leaf’s PR. For an EPIC, that is the EPIC PR that targets the default branch. Delete **Git naming** `ticket_ref` for the leaf, or for the EPIC and each sub-task:

`git push origin --delete` that ref, and delete the local branch when it exists. A missing remote ref is already gone.

## Git naming

| Kind | Template | Example |
| --- | --- | --- |
| `branch_with_ticket` | `feature/gh-{TICKET_ID}` | `feature/gh-42` |
| `branch_without_ticket` | `feature/{meaningful-name}` | `feature/add-billing-kpis` |
| `ticket_ref` | `ticket/gh-{TICKET_ID}` | `ticket/gh-42` |
| `commit_with_ticket` | `#{TICKET_ID}: {description}` | `#42: Refactor KPI aggregation` |
| `commit_without_ticket` | `{description}` | `Fix typo in field zone service` |
| `pr_title_with_ticket` | `#{TICKET_ID}: {Description}` | `#42: Add min rate KPI fields` |
| `pr_title_without_ticket` | `{Proper description}` | `Fix KPI accumulation logic` |

`branch_with_ticket` and `branch_without_ticket` start with `feature/`. Keep those names short. `ticket_ref` starts with `ticket/` and is never a pull request. It holds an oversized `PLAN.md`, `RESEARCH.md`, or `DECISION.md` for that issue until **Delete a ticket ref**.

PR description includes a summary of what changed and why, plus related ticket browse URLs when a ticket id exists. The description must match the actual diff. For EPIC work, also mention the parent EPIC ticket id.

## Extras

Used by `brainstorm` / `troubleshoot` filing and by `implement-ticket` readiness.

### Labels (apply on every create and update)

Use these **exact** four names. Before applying, **Operations** labels_list; if a name is missing, **Operations** labels_create. Colors/descriptions are optional; names are not.

| Label | Meaning | When to apply | implement-ticket |
| --- | --- | --- | --- |
| `epic` | Parent of tracer-bullet (or expand–contract) child issues | Main issue **after** at least one child is linked. Never on a leaf/child ticket. | Run EPIC path. Prefer this label; if missing but children are linked, treat as EPIC anyway. |
| `has-plan` | A leaf or sub-task has a `PLAN` doc comment `implement-ticket` can follow. An EPIC parent’s description is the whole plan in STE-100. | The `PLAN` comment (or the EPIC description) has concrete steps, including a best-effort plan with stated unknowns. Empty or “TBD only” does not qualify. | Plan was filed; still verify the `PLAN` comment or, on an EPIC parent, the description. The label alone is not enough. |
| `needs-brainstorm` | Product/design/scope still needs grooming before implement | Open questions, unresolved preferences, or residual unknowns that `brainstorm` should close. Prefer on the issue that owns the gap (often a child with a thin plan, or the main issue if the whole idea is under-specified). | **Hard abort** — user must re-run `brainstorm` first. |
| `needs-troubleshoot` | Diagnosis/root-cause still needs work before implement | Open incident questions, unconfirmed root cause, or missing reproduce/validation path that `troubleshoot` should close. | **Hard abort** — user must re-run `troubleshoot` first. |

**Rules**

1. **Set labels from current state** on every create **and** every update — do not leave stale grooming flags after a plan lands.
2. **`has-plan` vs grooming flags**
   - Full, implementable plan and no material open questions → add `has-plan`; **remove** `needs-brainstorm` and `needs-troubleshoot` on that issue.
   - Best-effort plan with residual unknowns → keep `has-plan` **and** the matching grooming label (`needs-brainstorm` for product/scope gaps, `needs-troubleshoot` for diagnosis gaps).
   - No workable plan yet → do **not** add `has-plan`; add `needs-brainstorm` and/or `needs-troubleshoot` as appropriate.
3. **`epic`** only when the main issue is a real parent (children exist). A single leaf with a plan gets `has-plan` only — not `epic`.
4. **Which grooming label:** improvements/ideas → `needs-brainstorm`; bugs/incidents/traces → `needs-troubleshoot`. An issue may carry both only if both kinds of gap remain.
5. Use these four names only (`epic`, `has-plan`, `needs-brainstorm`, `needs-troubleshoot`) so filters and `implement-ticket` stay consistent. Do not invent alternates (`Epic`, `planned`, `needs-grooming`).

### Issue types

`brainstorm` / `troubleshoot` set `type` on create and update. Confirm the name is in **Operations** list_issue_types for this repo. When it is missing, stop and report the list.

| Key | Value | When |
| --- | --- | --- |
| `issue_type_improvement` | `Feature` | `brainstorm` main issue (leaf or EPIC). This account’s type for an improvement. |
| `issue_type_bug` | `Bug` | `troubleshoot` main issue (leaf or EPIC). |
| `issue_type_subtask` | `Task` | Each tracer-bullet sub-task. |

## Switching trackers

Replace these keys in this file (GitHub stays live until then): `ticket_id_pattern`, `ticket_id_prefix`, `ticket_id_example`, `ticket_id_aliases`, `browse_url_template`, `mcp_server`, every **Operations** tool name, **Git naming** templates, and **Extras** (map labels to the new tracker’s fields, or drop them).
