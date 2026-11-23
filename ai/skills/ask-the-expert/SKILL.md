---
name: ask-the-expert
description: Consult domain specialists. Use for Consultant work (ideation, brainstorming, troubleshooting, improvements to an implementation plan) or an explicit review of a pull request, branch, repository, or snippet, when that work touches server-side JavaScript/TypeScript, CI/CD automation, observability, GIS, PostgreSQL, Python, Rust, Java with Spring Boot, Swift, web front-end, or web UI/UX — or whenever another skill needs specialist input. Target repos can also define their own experts in `## Expert: <id>` sections of the root AGENTS.md.
argument-hint: "Describe the code, technology, design question, or problem you would like expert input on."
---

Orchestrate specialist input: match every technology in the screening **corpus** to a table domain or a repo-defined expert, dispatch all matches in parallel as general-purpose children, synthesize by mode. Domain judgment comes from those children. Ponytail, the modes, library research, and the bill of materials are defined in [`references/modes.md`](references/modes.md). Each child reads that file and exactly one domain definition: a file under [`references/domains/`](references/domains/) for a table domain, or the matching `## Expert: <id>` section of the corpus-root `AGENTS.md` for a repo-defined expert. The domain definition holds scenarios, idiom, and judgment.

## Available experts

| Technology / Domain | Domain | Detection signals (non-exhaustive) |
|---|---|---|
| Server-side JavaScript/TypeScript on Node.js, preferably Bun | `bun` | Bun config or lockfile, a Node or Bun server entry, server handlers, workers, server runtime config. A client-only UI tree does not match |
| CI/CD automation — GitHub Actions, Helm charts, Terraform, shell, container builds, Make / Just | `ci-cd` | `.github/workflows/**`, `action.yml`/`action.yaml`, `**/*.{tf,tfvars,hcl}`, `**/Chart.yaml`, `values*.yaml`, `Dockerfile*`, `docker-compose*.yml`, CI shell, `Makefile`, `justfile`, `helmfile` |
| GIS / geospatial — dataset read/write, clip, merge, distance, CRS | `gis` | Vector or raster datasets, CRS or projection use, spatial predicates, clip/merge/distance operations. Tabular SQL with no spatial column does not match |
| Application performance monitoring, tracing, logging, metrics, KPIs | `observability` | Instrumentation or exporter config, monitors, dashboards, SLOs, or a consultation about traces, logs, metrics, or KPIs. Datadog is one platform that matches |
| PostgreSQL queries, schema, indexes, and SQL performance | `postgres` | `**/*.sql`, migration directories, a Postgres connection setting, SQL aimed at PostgreSQL |
| Server-side Python, serverless Python, data analysis in Python | `python` | `**/*.py`, `pyproject.toml`, `requirements*.txt`, `Pipfile`, `*.ipynb`, serverless function handlers |
| Client- and server-side Rust | `rust` | `**/*.rs`, `Cargo.toml`, `Cargo.lock`, `rust-toolchain*` |
| Server-side Java (LTS) on Spring Boot / Spring Cloud | `spring-cloud` | `**/*.java` with `pom.xml` or `build.gradle*`, Spring Boot or Spring Cloud markers, `application*.yml` in a Java service |
| Client- and server-side Swift, including desktop, mobile, web, and CLI | `swift` | `**/*.swift`, `Package.swift`, `*.xcodeproj`, `*.xcworkspace` |
| Client-side JavaScript/TypeScript, HTML/CSS, browser platform (WebGPU and the rest) | `web-frontend` | `**/*.{html,css,scss}`, client components, browser DOM or GPU API use |
| Web UI/UX — screens, flows, design systems, how an interface looks and behaves | `ui-ux-design` | A screen, flow, design system, usability failure, or how an interface looks or behaves, in the consultation question, ticket, or draft plan. View, layout, or stylesheet paths in the corpus |

Dispatch table domains and repo-defined experts (next section). Unmatched technologies in the corpus: record as *no expert available* and print the no-expert hint (Step 2).

## Repo-defined experts (root AGENTS.md)

A target repo declares its own experts in the `AGENTS.md` at the screening-corpus root, one section per expert:

```
## Expert: <id>

Signals: <optional detection signals, comma-separated>

<body in the references/domains/ shape — persona line, Scenarios, Idiom, Judgment, bill-of-materials note — or a single markdown link to a definition file in the repo for larger instructions>
```

- Parse only the exact `## Expert: ` heading prefix in the corpus-root `AGENTS.md`, outside fenced code blocks. `*.instructions.md` stay constraint files.
- `Signals:` is optional. When present, match the signals against the screening corpus like table rows. When absent, the expert always matches.
- When the section body contains a markdown link to a file in the repo, read that file as the definition. Otherwise use the inline body.
- An `<id>` equal to a table domain id overrides [`references/domains/<id>.md`](references/domains/) for that run. Record the override in the inventory.
- Duplicate ids in one `AGENTS.md`: the last section wins. Record the conflict.
- Keep sections compact: `AGENTS.md` loads in every agent session of the target repo. Offload long definitions through a link.

## Step 1 — Mode, corpus, revision

Pick one mode. **Reviewer** when the caller explicitly asks to review a pull request, branch, repository, or snippet. Otherwise **Consultant**.

**Screening corpus** (matching runs only against this):

- **PR / diff** → **changeset** (changed paths + patch hunks)
- **Branch / whole-repo** → **whole source** (manifests, lockfiles, source trees, IaC, migrations, configs)
- **Named paths / snippet / design-only** → those materials (plus any extra paths the caller included)
- Caller omitted corpus: **Reviewer** → stated focus (diff if given, else named paths, else whole tree); **Consultant** → whole workspace unless the question is clearly scoped

**Codebase revision** handed to children:

| Situation | Revision |
|---|---|
| **Consultant**, and the caller is troubleshooting an incident or a trace | **Ticket/trace version if present** (prefer git tag / matching SHA); else current workspace with that fallback called out |
| **Consultant**, otherwise | **Current workspace** (live tree). Use an older release only when the caller asked to consult against one |
| **Reviewer** | Caller-stated revision, else the pull request or branch under review, else current workspace |

For an incident or trace, resolve the production revision **before** Step 2 from ticket text, comments, labels, fix versions, stack traces, deploy notes, and trace/telemetry tags (`version`, `git.commit.sha`, `git.repository_url`, image/tag, chart appVersion, release name, etc.). Prefer a **git tag** (or commit SHA mappable to a tag). Materialize that tree (worktree/checkout/export) as the screening corpus root and the child focus codebase. If signals conflict, pick the best-supported one and state the choice. If no version signal is found, fall back to the current workspace and record that assumption.

**Glossary.** Look for `GLOSSARY.md` at the screening-corpus root. When present, read it and record its path and terms. Use its terms verbatim in the routing artifact, every child prompt, and the synthesis. Do not invent synonyms for defined terms; when a needed term is missing, flag it and propose a definition. When absent, record `Glossary: absent` and continue with domain-definition wording.

**Done when:** mode, screening corpus, revision (tag/SHA/`HEAD`/fallback), and glossary (path or absent) are recorded, incident version resolution is documented when the caller is troubleshooting, and all four will be passed into every child prompt.

## Step 2 — Technology inventory (routing only)

Walk **every row** of Available experts against the screening corpus. A technology is present if any detection signal (or clear design/problem evidence **in the corpus**) hits. Multi-stack corpora are expected. Signals that name the consultation question, ticket, or draft plan use that text as evidence.

Legwork on the screening corpus, plus the consultation question, ticket, and draft plan for rows whose signals name that text:

1. **PR/diff:** list changed paths and skim patch language and platform signals (and any manifests/lockfiles **in the changeset**).
2. **Branch/whole-repo:** list top-level layout and key manifests, then sample/search for detection signals.
3. **Named/snippet/design:** inspect only those materials; treat ticket text, stack traces, and design notes as additional signals when provided.
4. **Consultation question, ticket, or draft plan:** apply this text to every row whose detection signals name it.

Load `AGENTS.md` / `*.instructions.md` when present; pass constraints through to every child. Parse the corpus-root `AGENTS.md` for `## Expert: <id>` sections (see Repo-defined experts) and walk every repo-defined expert like a table row: matched per its `Signals:` (always when it has none), with any override of a table domain noted.

Write the routing artifact:

```
### Technology inventory
Screening corpus: [changeset | whole source | named paths/snippet] — [brief identifier]
Codebase revision: [git tag | commit SHA | HEAD/current workspace] — [source of version signal, or "no signal; fallback to workspace"]
Glossary: [GLOSSARY.md at corpus root | absent]

For every Available experts row: Matched? yes/no — evidence (paths / signals in corpus).
Repo-defined experts (root AGENTS.md):
- <id> — Matched? yes/no — [overrides table domain <id> | new domain] — source: [inline section | link to <path>] — evidence
Unmatched technologies in corpus (no expert): …
```

Inventory is routing only: detection signals and evidence paths. Domain findings, recommendations, and answers wait for the children.

**No-expert hint.** At the end of the inventory, print one line per unmatched technology:

> No expert available for `<technology>`. To add one, create an `## Expert: <id>` section in `AGENTS.md` at the repository root — inline, or linking a definition file in the repo for larger instructions.

**Done when:** every table row and every repo-defined expert has yes/no with in-corpus evidence for each yes, unmatched non-table tech is listed with the no-expert hint, the glossary is recorded, and the consultation answer has not been started.

## Step 3 — Dispatch every match

If inventory has zero `yes` rows (no table domain and no repo-defined expert): say no expert applies to the screening corpus, print the no-expert hint for the unmatched technologies, and **stop**.

Otherwise spawn **every** `yes` row **in parallel** (one turn when the runtime allows). Each spawn is a general-purpose child. The prompt selects the domain. Dispatch each matched domain, including signals that look minor, infra-only, or tests-only inside the corpus.

Each child prompt includes:

- Consultation **mode** + the specific question
- The instruction to follow `references/modes.md`
- The instruction to read the domain definition — `references/domains/<id>.md` for a table domain, or the `## Expert: <id>` section of the corpus-root `AGENTS.md` (inline body, or the file it links to) for a repo-defined expert — and apply its scenarios, idiom, and judgment
- **Focus material** (diff/changeset, files, design, logs the caller cares about)
- **Screening corpus** (PR diff vs full tree vs named paths)
- **Codebase revision** (tag/SHA/`HEAD`) and how it was chosen
- Paths/content from **that revision** for layouts, configs, and related modules the child needs (excerpts and paths, not findings)
- Architecture/runtime constraints and AGENTS/instructions excerpts
- **Glossary** terms from the corpus-root `GLOSSARY.md` (or `none`), with the instruction to use them verbatim in the answer and to flag a needed-but-missing term with a proposed definition
- Note that other children are running in parallel on sibling domains (cover cross-cutting concerns in your domain; drop pure duplicate work)
- On **Reviewer**: "Return your bill-of-materials rows. The orchestrator stores the bill of materials."

**Done when:** every `yes` row has child output in hand (or a hard invocation failure reported for that domain).

## One domain

Use this when a caller already names one domain and wants that child only. The domain id may be a table domain or a repo-defined `## Expert: <id>` id. Skip Step 2. Spawn one general-purpose child with the Step 3 prompt for that domain id, mode, question, focus, and revision. A signal-gathering run adds: "Leave the bill of materials unwritten."

**Done when:** that single child has returned, or the invocation failure is reported.

## Step 4 — Synthesize

Merge into one coherent answer. Lead with **Experts consulted** (domain ids + why, tied to corpus evidence, + source: table file or root-AGENTS.md expert section). Resolve contradictions with explicit tradeoffs; drop pure redundancy. Keep the recommendation inside the smallest complete change [`references/modes.md`](references/modes.md) defines. For unmatched non-table tech, state that no specific expert exists and repeat the no-expert hint from Step 2.

When any child leaves a library choice open, list the options and leave the choice to the user. When children recommend different libraries for the same job, present each option with the evidence that child cited and leave the choice to the user.

On **Reviewer**, store the bill of materials as [`references/modes.md`](references/modes.md) defines. Merge returned rows by name. When two children report the same name and version, keep one row and combine the CVE notes. When no bill of materials existed, add a row for a declared dependency no child returned, with license `unknown` and CVEs `not checked`, and name it here as outside the matched domains.

Shape by mode:

- **Consultant:** the answer or recommended approach, risks, and ranked causes when the consult is troubleshooting
- **Reviewer:** Critical / Warning / Suggestion, then the bill-of-materials path, critical updates, and CVEs

Merge the children's Ponytail closes into one close of one or two lines: what the consult skipped or did not check, and the risk. Keep a risk that is specific to a domain. Drop a duplicate.

Return only the consultation — no code writes or tickets unless explicitly asked. The Reviewer bill of materials is that ask: the synthesis includes its path.

**Done when:** synthesized answer is returned, every matched domain's input is reflected (or failure called out), the Experts consulted list matches the inventory `yes` set (table + repo-defined), and the Ponytail close is present. On Reviewer, the bill of materials is stored and named in the synthesis, including critical updates and CVEs.
