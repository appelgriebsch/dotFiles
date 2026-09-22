---
name: ask-the-expert
description: Consult domain specialists. Use for Consultant work (ideation, brainstorming, troubleshooting, improvements to an implementation plan) or an explicit review of a pull request, branch, repository, or snippet, when that work touches server-side JavaScript/TypeScript, CI/CD automation, observability, GIS, PostgreSQL, Python, Rust, Java with Spring Boot, Swift, web front-end, or UI/UX — or whenever another skill needs specialist input.
argument-hint: "Describe the code, technology, design question, or problem you would like expert input on."
---

Orchestrate specialist input: match every technology in the screening **corpus** to a table expert, dispatch all matches in parallel, synthesize by mode. Domain judgment comes from those experts. Modes, library research, and the bill of materials are defined in [`references/modes.md`](references/modes.md).

`deployment-engineer` and `test-engineer` are outside this skill. When the caller asks to execute a deploy or an end-to-end test, name that persona and leave the work to a direct invocation or to process automation. Continue this consult for any remaining Consultant or Reviewer ask.

## Available experts

| Technology / Domain | Expert Sub-Agent | Detection signals (non-exhaustive) |
|---|---|---|
| Server-side JavaScript/TypeScript on Node.js, preferably Bun | `bun-expert` | Bun config or lockfile, a Node or Bun server entry, server handlers, workers, server runtime config. A client-only UI tree does not match |
| CI/CD automation — GitHub Actions, Helm charts, Terraform, shell, container builds, Make / Just | `ci-cd-expert` | `.github/workflows/**`, `action.yml`/`action.yaml`, `**/*.{tf,tfvars,hcl}`, `**/Chart.yaml`, `values*.yaml`, `Dockerfile*`, `docker-compose*.yml`, CI shell, `Makefile`, `justfile`, `helmfile` |
| GIS / geospatial — dataset read/write, clip, merge, distance, CRS | `gis-expert` | Vector or raster datasets, CRS or projection use, spatial predicates, clip/merge/distance operations. Tabular SQL with no spatial column does not match |
| Application performance monitoring, tracing, logging, metrics, KPIs | `observability-expert` | Instrumentation or exporter config, monitors, dashboards, SLOs, or a consultation about traces, logs, metrics, or KPIs. Datadog is one platform that matches |
| PostgreSQL queries, schema, indexes, and SQL performance | `postgres-expert` | `**/*.sql`, migration directories, a Postgres connection setting, SQL aimed at PostgreSQL |
| Server-side Python, serverless Python, data analysis in Python | `python-expert` | `**/*.py`, `pyproject.toml`, `requirements*.txt`, `Pipfile`, `*.ipynb`, serverless function handlers |
| Client- and server-side Rust | `rust-expert` | `**/*.rs`, `Cargo.toml`, `Cargo.lock`, `rust-toolchain*` |
| Server-side Java (LTS) on Spring Boot / Spring Cloud | `spring-cloud-expert` | `**/*.java` with `pom.xml` or `build.gradle*`, Spring Boot or Spring Cloud markers, `application*.yml` in a Java service |
| Client- and server-side Swift, including desktop, mobile, web, and CLI | `swift-expert` | `**/*.swift`, `Package.swift`, `*.xcodeproj`, `*.xcworkspace` |
| Client-side JavaScript/TypeScript, HTML/CSS, browser platform (WebGPU and the rest) | `web-frontend-expert` | `**/*.{html,css,scss}`, client components, browser DOM or GPU API use |
| UI/UX design — hierarchy, flow, mobile-first layout, design systems, clickable prototypes | `ui-ux-expert` | Caller text about a screen, page, layout, flow, usability, design system, or clickable prototype (interface design, not schema or API design alone). View, layout, or stylesheet files in a changeset or named focus. Whole-source consult only when the caller's focus includes how those screens look or behave |

Dispatch only table ids. Unmatched technologies in the corpus: record as *no expert available*.

## Step 1 — Mode, corpus, revision

Pick one mode. **Reviewer** when the caller explicitly asks to review a pull request, branch, repository, or snippet. Otherwise **Consultant**.

**Screening corpus** (matching runs only against this):

- **PR / diff** → **changeset** (changed paths + patch hunks)
- **Branch / whole-repo** → **whole source** (manifests, lockfiles, source trees, IaC, migrations, configs)
- **Named paths / snippet / design-only** → those materials (plus any extra paths the caller included)
- Caller omitted corpus: **Reviewer** → stated focus (diff if given, else named paths, else whole tree); **Consultant** → whole workspace unless the question is clearly scoped

**Codebase revision** handed to experts:

| Situation | Revision |
|---|---|
| **Consultant**, and the caller is troubleshooting an incident or a trace | **Ticket/trace version if present** (prefer git tag / matching SHA); else current workspace with that fallback called out |
| **Consultant**, otherwise | **Current workspace** (live tree). Use an older release only when the caller asked to consult against one |
| **Reviewer** | Caller-stated revision, else the pull request or branch under review, else current workspace |

For an incident or trace, resolve the production revision **before** Step 2 from ticket text, comments, labels, fix versions, stack traces, deploy notes, and trace/telemetry tags (`version`, `git.commit.sha`, `git.repository_url`, image/tag, chart appVersion, release name, etc.). Prefer a **git tag** (or commit SHA mappable to a tag). Materialize that tree (worktree/checkout/export) as the screening corpus root and the expert focus codebase. If signals conflict, pick the best-supported one and state the choice. If no version signal is found, fall back to the current workspace and record that assumption.

**Done when:** mode, screening corpus, and revision (tag/SHA/`HEAD`/fallback) are recorded, incident version resolution is documented when the caller is troubleshooting, and all three will be passed into every expert prompt.

## Step 2 — Technology inventory (routing only)

Walk **every row** of Available experts against the screening corpus. A technology is present if any detection signal (or clear design/problem evidence **in the corpus**) hits. Multi-stack corpora are expected. Signals that name the consultation question, ticket, or draft plan use that text as evidence.

Legwork on the screening corpus, plus the consultation question, ticket, and draft plan for rows whose signals name that text:

1. **PR/diff:** list changed paths and skim patch language and platform signals (and any manifests/lockfiles **in the changeset**).
2. **Branch/whole-repo:** list top-level layout and key manifests, then sample/search for detection signals.
3. **Named/snippet/design:** inspect only those materials; treat ticket text, stack traces, and design notes as additional signals when provided.
4. **Consultation question, ticket, or draft plan:** apply this text to every row whose detection signals name it.

Load `AGENTS.md` / `*.instructions.md` when present; pass constraints through to every expert.

Write the routing artifact:

```
### Technology inventory
Screening corpus: [changeset | whole source | named paths/snippet] — [brief identifier]
Codebase revision: [git tag | commit SHA | HEAD/current workspace] — [source of version signal, or "no signal; fallback to workspace"]

For every Available experts row: Matched? yes/no — evidence (paths / signals in corpus).
Unmatched technologies in corpus (no expert): …
```

Inventory is routing only: detection signals and evidence paths. Domain findings, recommendations, and answers wait for experts.

**Done when:** every table row has yes/no with in-corpus evidence for each yes, unmatched non-table tech is listed, and the consultation answer has not been started.

## Step 3 — Dispatch every match

If inventory has zero `yes` rows: say no listed expert applies to the screening corpus and **stop**.

Otherwise Task-invoke **every** `yes` row **in parallel** (one turn when the runtime allows). Dispatch each matched domain to its own table expert, including signals that look minor, infra-only, or tests-only inside the corpus.

Each expert prompt includes:

- Consultation **mode** + the specific question
- The instruction to follow `~/.grok/skills/ask-the-expert/references/modes.md`
- **Focus material** (diff/changeset, files, design, logs the caller cares about)
- **Screening corpus** (PR diff vs full tree vs named paths)
- **Codebase revision** (tag/SHA/`HEAD`) and how it was chosen
- Paths/content from **that revision** for layouts, configs, and related modules the expert needs (excerpts and paths, not findings)
- Architecture/runtime constraints and AGENTS/instructions excerpts
- Note that other experts are running in parallel on sibling domains (cover cross-cutting concerns in your domain; drop pure duplicate work)
- On **Reviewer**, for every expert except `ui-ux-expert`: "Return your bill-of-materials rows. The orchestrator stores the bill of materials."

When the caller asked for a clickable prototype, the `ui-ux-expert` prompt requires that expert to build one and return its path and how to open it. Only that expert writes files.

**Done when:** every `yes` row has expert output in hand (or a hard invocation failure reported for that expert). When a clickable prototype was asked for, `ui-ux-expert` was among the `yes` rows and its prototype output is in hand.

## Step 4 — Synthesize

Merge into one coherent answer. Lead with **Experts consulted** (names + why, tied to corpus evidence). Resolve contradictions with explicit tradeoffs; drop pure redundancy. For unmatched non-table tech, state that no specific expert exists.

When any expert leaves a library choice open, list the options and leave the choice to the user. When experts recommend different libraries for the same job, present each option with the evidence that expert cited and leave the choice to the user.

On **Reviewer**, store the bill of materials as [`references/modes.md`](references/modes.md) defines. Merge returned rows by name. When two experts report the same name and version, keep one row and combine the CVE notes. When no bill of materials existed, add a row for a declared dependency no expert returned, with license `unknown` and CVEs `not checked`, and name it here as outside the matched domains.

Shape by mode:

- **Consultant:** the answer or recommended approach, risks, and ranked causes when the consult is troubleshooting
- **Reviewer:** Critical / Warning / Suggestion, then the bill-of-materials path, critical updates, and CVEs

Return only the consultation — no code writes or tickets unless explicitly asked. A clickable prototype is that ask: `ui-ux-expert` writes it, and the synthesis includes its path and how to open it. The Reviewer bill of materials is that ask: the synthesis includes its path.

**Done when:** synthesized answer is returned, every matched expert’s input is reflected (or failure called out), and the Experts consulted list matches the inventory `yes` set. When a prototype was asked for, the synthesis includes its path and how to open it. On Reviewer, the bill of materials is stored and named in the synthesis, including critical updates and CVEs.
