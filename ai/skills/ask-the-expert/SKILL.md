---
name: ask-the-expert
description: Consult domain specialists. Use when Review, Plan, Diagnose, or Question work touches Rust, Bun/TypeScript, Java/Spring Cloud, Python (web, Lambda, data/ML), GIS, web front-end, UI/UX design, API or web end-to-end verification, Swift, PostgreSQL, Datadog, CI/CD (GitHub Actions, Terraform, Helm, shell pipelines), or cloud deployment of build artifacts — or whenever another skill needs specialist input.
argument-hint: "Describe the code, technology, design question, or problem you would like expert input on."
---

Orchestrate specialist input: match every technology in the screening **corpus** to a table expert, dispatch all matches in parallel, synthesize by mode. Domain judgment comes from those experts.

## Available experts

| Technology / Domain | Expert Sub-Agent | Detection signals (non-exhaustive) |
|---|---|---|
| Rust source, Cargo.toml, unsafe code, lifetimes, ownership | `rust-expert` | `**/*.rs`, `Cargo.toml`, `Cargo.lock`, `rust-toolchain*`, Axum/Tokio/sqlx usage |
| TypeScript/JavaScript on Bun runtime, Bun APIs, bun config | `bun-expert` | `bun.lock`/`bun.lockb`, `bunfig.toml`, `bun:*` imports, TS/JS with Bun scripts |
| Java / Spring Boot, Spring Cloud, Maven/Gradle, JVM performance | `spring-cloud-expert` | `**/*.java`, `pom.xml`, `build.gradle*`, Spring annotations, `application*.yml` |
| Python — web services (FastAPI/Flask/Django), AWS Lambda/serverless, data analysis (pandas/NumPy/Polars), ML (TensorFlow/Keras/scikit-learn) | `python-expert` | `**/*.py`, `pyproject.toml`, `requirements*.txt`, `Pipfile`, `*.ipynb`, FastAPI/Flask/Django/Lambda/TF/pandas imports |
| GIS / geospatial data processing (GeoTools, GDAL, Turf.js, PostGIS, Shapely) | `gis-expert` | GeoTools/JTS, GDAL/OGR, Shapely/Fiona/rasterio/pyproj, Turf.js, PostGIS/`geometry` SQL, CRS/proj usage |
| HTML, CSS, and web front-end (React, Next.js, accessibility, responsiveness) | `web-frontend-expert` | `**/*.{tsx,jsx,vue,svelte,css,scss,html}`, React/Next/Svelte deps, frontend app dirs |
| UI/UX design — hierarchy, flow, mobile-first layout, design systems, clickable prototypes | `ui-ux-expert` | Question, ticket, or plan text about a screen, page, layout, flow, usability, design system, or clickable prototype (interface design, not schema or API design alone). View, layout, or stylesheet files in a changeset or named focus. Whole-source review or plan only when the caller's focus includes how those screens look or behave |
| Swift — client-side (SwiftUI/UIKit/AppKit), server-side (Vapor/Hummingbird/SwiftNIO), and CLI (swift-argument-parser, SwiftPM) | `swift-expert` | `**/*.swift`, `Package.swift`, `*.xcodeproj`, `*.xcworkspace`, Vapor/SwiftUI usage |
| PostgreSQL queries, schemas, migrations, indexing, and query performance | `postgres-expert` | `**/*.{sql}`, Flyway/Liquibase/Alembic dirs, `postgres`/`postgresql` deps or URLs, JPA/`sqlx`/SQLAlchemy SQL touching Postgres |
| Datadog observability data — metrics, logs, traces, dashboards, monitors, incidents | `datadog-analyzer` | Datadog client/SDK usage, `DD_*` env, trace/monitor/dashboard work, incident/APM investigation context |
| CI/CD & delivery automation — GitHub Actions, Terraform pipelines, Helm charts, container build/deploy, CI shell | `ci-cd-expert` | `.github/workflows/**`, `action.yml`/`action.yaml`, `**/*.{tf,tfvars,hcl}`, `**/Chart.yaml`, `values*.yaml`, `Dockerfile*`, `docker-compose*.yml`, CI shell under `.github/`/scripts, `helmfile`, Kustomize/Argo/Flux delivery manifests |
| Cloud deployment of a build artifact — Cloudflare Workers, Vercel, DigitalOcean, AWS, Kubernetes via Helm | `deployment-engineer` | The caller asks to deploy, ship, or promote a build artifact, or the request is a GitHub Actions deploy step, a release-success notification, or another deploy webhook. A workflow, chart, or Terraform diff with no deploy ask stays on `ci-cd-expert` |
| API or web end-to-end verification — PR preview or staging, regression suite, backend performance KPIs | `test-engineer` | The caller asks to execute end-to-end, API, or browser checks against a PR preview or a staging rollout. Match that ask in the question, ticket, or draft plan. A diff that contains tests, or a review that lists testing as a quality lens, is not this ask |

Dispatch only table ids. Unmatched technologies in the corpus: record as *no expert available*.

## Step 1 — Mode, corpus, revision

Pick one mode: **Review** · **Plan** · **Diagnose** · **Question**.

**Screening corpus** (matching runs only against this):

- **PR / diff** → **changeset** (changed paths + patch hunks)
- **Branch / whole-repo** → **whole source** (manifests, lockfiles, source trees, IaC, migrations, configs)
- **Named paths / snippet / design-only** → those materials (plus any extra paths the caller included)
- Caller omitted corpus: **Review** → stated focus (diff if given, else named paths, else whole tree); **Plan / Diagnose / Question** → whole workspace unless the question is clearly scoped

**Codebase revision** handed to experts:

| Mode | Revision |
|---|---|
| **Plan** | **Current workspace** (live tree). Use an older release only when the caller asked to plan against one. |
| **Diagnose** | **Ticket/trace version if present** (prefer git tag / matching SHA); else current workspace with that fallback called out |
| **Review** / **Question** | Caller-stated revision, else current workspace |

For **Diagnose**, resolve a production/incident revision **before** Step 2 from ticket text, comments, labels, fix versions, stack traces, deploy notes, and trace/telemetry tags (`version`, `git.commit.sha`, `git.repository_url`, image/tag, chart appVersion, release name, etc.). Prefer a **git tag** (or commit SHA mappable to a tag). Materialize that tree (worktree/checkout/export) as the screening corpus root and the expert focus codebase. If signals conflict, pick the best-supported one and state the choice. If no version signal is found, fall back to the current workspace and record that assumption.

**Done when:** mode, screening corpus, and revision (tag/SHA/`HEAD`/fallback) are recorded, Diagnose version resolution is documented when that mode applies, and all three will be passed into every expert prompt.

## Step 2 — Technology inventory (routing only)

Walk **every row** of Available experts against the screening corpus. A technology is present if any detection signal (or clear design/problem evidence **in the corpus**) hits. Multi-stack corpora are expected. Signals that name the consultation question, ticket, or draft plan use that text as evidence.

Legwork on the screening corpus, plus the consultation question, ticket, and draft plan for rows whose signals name that text:

1. **PR/diff:** list changed paths and skim patch language/framework signals (and any manifests/lockfiles **in the changeset**).
2. **Branch/whole-repo:** list top-level layout and key manifests, then sample/search for detection signals.
3. **Named/snippet/design:** inspect only those materials; treat ticket text, stack traces, and design notes as additional signals when provided.
4. **Question, ticket, or draft plan:** apply this text to every row whose detection signals name it.

Load `AGENTS.md` / `*.instructions.md` when present; pass constraints through to every expert.

Write the routing artifact:

```
### Technology inventory
Screening corpus: [changeset | whole source | named paths/snippet] — [brief identifier]
Codebase revision: [git tag | commit SHA | HEAD/current workspace] — [source of version signal, or "no signal; fallback to workspace"]

For every Available experts row: Matched? yes/no — evidence (paths / signals in corpus).
Unmatched technologies in corpus (no expert): …
```

Inventory is routing only: detection signals and evidence paths. Domain findings, plans, diagnoses, and answers wait for experts.

**Done when:** every table row has yes/no with in-corpus evidence for each yes, unmatched non-table tech is listed, and the consultation answer has not been started.

## Step 3 — Dispatch every match

If inventory has zero `yes` rows: say no listed expert applies to the screening corpus and **stop**.

Otherwise Task-invoke **every** `yes` row **in parallel** (one turn when the runtime allows). Dispatch each matched domain to its own table expert, including signals that look minor, infra-only, or tests-only inside the corpus.

Each expert prompt includes:

- Consultation **mode** + the specific question
- **Focus material** (diff/changeset, files, design, logs the caller cares about)
- **Screening corpus** (PR diff vs full tree vs named paths)
- **Codebase revision** (tag/SHA/`HEAD`) and how it was chosen
- Paths/content from **that revision** for layouts, configs, and related modules the expert needs (excerpts and paths, not findings)
- Architecture/runtime constraints and AGENTS/instructions excerpts
- Note that other experts are running in parallel on sibling domains (cover cross-cutting concerns in your domain; drop pure duplicate work)

When the caller asked for a clickable prototype, the `ui-ux-expert` prompt requires that expert to build one and return its path and how to open it. Only that expert writes files.

When the caller asked to run end-to-end checks, the `test-engineer` prompt requires that expert to run them and return each check's expectation, outcome, and result, plus the backend KPI comparison.

When the caller asked to deploy a build artifact, the `deployment-engineer` prompt requires that expert to consult `ci-cd-expert` before the deploy and return the deployed artifacts and the web URL when there is one.

**Done when:** every `yes` row has expert output in hand (or a hard invocation failure reported for that expert). When a clickable prototype was asked for, `ui-ux-expert` was among the `yes` rows and its prototype output is in hand. When end-to-end checks were asked for, `test-engineer` was among the `yes` rows and its report is in hand. When a deploy was asked for, `deployment-engineer` was among the `yes` rows and its deployment report is in hand.

## Step 4 — Synthesize

Merge into one coherent answer. Lead with **Experts consulted** (names + why, tied to corpus evidence). Resolve contradictions with explicit tradeoffs; drop pure redundancy. For unmatched non-table tech, state that no specific expert exists.

Shape by mode:

- **Review:** Critical 🔴 / Warning ⚠️ / Suggestion 💡 (attribute findings to the expert source when helpful)
- **Plan:** risks, recommended approach, open tradeoffs
- **Diagnose:** ranked root-cause hypotheses + evidence + next steps
- **Question:** answer first, then brief rationale

Return only the consultation — no code writes or tickets unless explicitly asked. A clickable prototype is that ask: `ui-ux-expert` writes it, and the synthesis includes its path and how to open it. An end-to-end run is that ask: the synthesis keeps `test-engineer`'s expectation, outcome, result, and backend KPI comparison rather than folding them into severity labels alone. A deploy is that ask: the synthesis keeps `deployment-engineer`'s artifact overview and URL.

**Done when:** synthesized answer is returned, every matched expert’s input is reflected (or failure called out), and the Experts consulted list matches the inventory `yes` set. When a prototype was asked for, the synthesis includes its path and how to open it. When end-to-end checks were asked for, the synthesis includes the test report. When a deploy was asked for, the synthesis includes the deployment report.
