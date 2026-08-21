---
name: issue-tracker
description: >-
  Issue tracker identity, MCP operations, labels, and git naming. Use when
  parsing a ticket id, fetching or creating a tracker issue, applying
  readiness labels, resolving parent/Epic or children, or naming a branch,
  commit, or pull request from a ticket.
---

# Issue tracker

Single source for ticket identity, issue MCP operations, readiness labels, and git name templates.

**Apply:** invoke or read this skill before parsing a ticket id, calling issue MCP, applying readiness labels, or naming a branch, commit, or PR. Substitute `{TICKET_ID}` from **Identity**. Use **Operations** tool names. Format git names from **Git naming**. Read **Extras** only when creating, updating, labeling, or linking issues.

**Done when:** every ticket id, browse URL, issue MCP tool, label, and git name in the run comes from the tables below.

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
| create | `github__issue_write` | method=`create`; returns the new issue number |
| comment | `github__add_issue_comment` | STE summary on the main ticket |
| parent | `github__issue_read` | method=`get_parent` |
| children | `github__issue_read` | method=`get_sub_issues` |
| link_child | `github__sub_issue_write` | method=`add`; `issue_number` = parent; `sub_issue_id` is the child's **id**, not its number |
| list | `github__list_issues` | list/filter issues in the repo |
| search | `github__search_issues` | natural-language issue search |
| labels_list | `github__list_label` | repo labels |
| labels_create | `github__label_write` | method=`create`; name required |

## Git naming

| Kind | Template | Example |
| --- | --- | --- |
| `branch_with_ticket` | `feature/gh-{TICKET_ID}` | `feature/gh-42` |
| `branch_without_ticket` | `feature/{meaningful-name}` | `feature/add-billing-kpis` |
| `commit_with_ticket` | `#{TICKET_ID}: {description}` | `#42: Refactor KPI aggregation` |
| `commit_without_ticket` | `{description}` | `Fix typo in field zone service` |
| `pr_title_with_ticket` | `#{TICKET_ID}: {Description}` | `#42: Add min rate KPI fields` |
| `pr_title_without_ticket` | `{Proper description}` | `Fix KPI accumulation logic` |

Branch names start with `feature/`. Keep names short.

PR description includes a summary of what changed and why, plus related ticket browse URLs when a ticket id exists. The description must match the actual diff. For EPIC work, also mention the parent EPIC ticket id.

## Extras

Used by `brainstorm` / `troubleshoot` filing and by `implement-ticket` readiness.

### Labels (apply on every create and update)

Use these **exact** label names. Before applying, **Operations** labels_list; if a name is missing, **Operations** labels_create. Colors/descriptions are optional; names are not.

| Label | Meaning | When to apply | implement-ticket |
| --- | --- | --- | --- |
| `epic` | Parent of tracer-bullet (or expand–contract) child issues | Main issue **after** at least one child is linked. Never on a leaf/child ticket. | Run EPIC path. Prefer this label; if missing but children are linked, treat as EPIC anyway. |
| `has-plan` | Issue body has an implementation (or fix) plan that `implement-ticket` can follow | Full plan **or** best-effort plan with concrete steps (not empty / “TBD only”). Apply to main and each child that qualifies. | Plan was filed; still verify body has steps (label alone is not enough if the body is empty). |
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
5. Do **not** invent alternate names (`Epic`, `planned`, `needs-grooming`, etc.). Reuse these four so filters and `implement-ticket` stay consistent.

## Switching trackers

Replace these keys in this file (GitHub stays live until then): `ticket_id_pattern`, `ticket_id_prefix`, `ticket_id_example`, `ticket_id_aliases`, `browse_url_template`, `mcp_server`, every **Operations** tool name, **Git naming** templates, and **Extras** (map labels to the new tracker’s fields, or drop them).
