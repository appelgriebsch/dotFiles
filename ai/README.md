# AI Configs

Configuration, skills, and personas for [Grok Build](https://x.ai) (`~/.grok/`), [Mistral Vibe](https://github.com/mistralai/vibe) (`~/.vibe/`), and related agent CLIs.

## Contents

| Path | Description |
| --- | --- |
| `grok/config.toml` | Portable Grok Build config — models, UI theme, LSP feature flag, MCP servers, and permission rules. Uses **`${ENV}` placeholders** for secrets (see [MCP config](#mcp-config)). |
| `grok/lsp.json` | LSP server configurations for TypeScript (typescript-language-server), Python (pyright), and Rust (rust-analyzer). |
| `vibe/config.toml` | Portable Mistral Vibe config — active model (`mistral-large-4`), default agent, MCP servers (crates-io, bun-mcp, github, datadog). Uses **`${ENV}` placeholders** for secrets. |
| `skills/` | Agent skills (portable instructions invoked by name or automatically based on their description). See [Skills](#skills-skills). |
| `personas/` | Vibe personas — senior specialist roles with quality gates, user-invoked only (except `domain-expert`). See [Personas](#personas-personas). |

---

## Skills (`skills/`)

Agent skills are portable instructions invoked by name or automatically based on their description.

| Skill | Model-invocable | Description |
| --- | --- | --- |
| `ask-the-expert` | yes | Consult domain specialists in **Consultant** mode (ideation, brainstorming, troubleshooting, plan improvements) or **Reviewer** mode (explicit review of a PR, branch, repository, or snippet). Covers server-side JavaScript/TypeScript, CI/CD automation, observability, GIS, PostgreSQL, Python, Rust, Java with Spring Boot, Swift, web front-end, and web UI/UX. Dispatches a general-purpose child per matched domain — see [Domain specialists](#domain-specialists). Target repos can add their own experts via `## Expert: <id>` sections in the root `AGENTS.md` and set the output wording via a root `GLOSSARY.md`. |
| `query-postgres` | yes | Query Postgres. Use to query, inspect, analyze, run ad hoc SQL, or explore schema. Read-only by default; `--write` only after explicit confirmation. Uses `scripts/pg_query.sh` with per-environment credential files (`env.<environment>` in the skill directory). |
| `test-containers` | yes | IT test containers. Use to start or stop the containers a project's integration tests need. Supports **docker**, **podman**, or the **macOS container CLI** (auto-detected via `scripts/detect_tool.sh`). Discovers the project's container setup from `AGENTS.md` → `*.instructions.md` → `README.md` → config files. |

### Domain specialists

`ask-the-expert` dispatches a general-purpose child per matched domain — a table domain or a repo-defined expert. The child reads [`skills/ask-the-expert/references/modes.md`](skills/ask-the-expert/references/modes.md) and one domain definition: a file under [`skills/ask-the-expert/references/domains/`](skills/ask-the-expert/references/domains/), or the matching `## Expert: <id>` section of the target repo's root `AGENTS.md` (inline, or the file it links to).

| Mode | When |
| --- | --- |
| **Consultant** | Default. Ideation, brainstorming, troubleshooting, and improvements to an implementation plan. Researches candidate libraries and leaves a choice among several to the user. |
| **Reviewer** | Only when the caller explicitly asks to review a pull request, branch, repository, or snippet. Creates or updates the repository bill of materials (name, version, license) and notes critical updates and CVEs. |

Both modes apply [Ponytail](https://github.com/DietrichGebert/ponytail): the smallest complete change that still finishes the task.

| Domain file | Purpose |
| --- | --- |
| `domains/bun.md` | Server-side JavaScript/TypeScript on Node.js, preferably Bun. |
| `domains/ci-cd.md` | Automation: GitHub Actions, Helm charts, Terraform, shell, container builds, Make / Just. |
| `domains/gis.md` | GIS and geospatial data: reading and writing datasets, clipping, merging, distance, and related operations. |
| `domains/observability.md` | Application performance monitoring, tracing, logging, metrics, and KPIs. Datadog is one platform. |
| `domains/postgres.md` | PostgreSQL queries and operations: SQL performance, missing indexes, query optimization. |
| `domains/python.md` | Server-side Python, serverless Python (for example AWS Lambda), and data analysis in Python. |
| `domains/rust.md` | Client- and server-side Rust. Servers prefer Tokio. Clients prefer the web and WebAssembly; cross-platform GUI and CLI/TUI are in scope. |
| `domains/spring-cloud.md` | Server-side Java on an LTS release, using Spring Boot and Spring Cloud. |
| `domains/swift.md` | Client- and server-side Swift, including desktop, mobile, web, WebAssembly, and CLI/TUI. |
| `domains/web-frontend.md` | Client-side JavaScript/TypeScript, HTML/CSS, and current browser platform features such as WebGPU. |
| `domains/ui-ux-design.md` | Progressive, fluent, mobile-first web UI/UX: design system, craft, and how a screen looks and flows. |

#### Repo-defined experts and GLOSSARY.md

A target repo declares its own experts in the root `AGENTS.md`, one `## Expert: <id>` section per expert. An optional `Signals:` line scopes when the expert dispatches; without it the expert always dispatches. An id that matches a table domain above overrides that domain's file for the run. When the screening corpus contains a technology no expert covers, the technology inventory ends with a hint that shows how to add the section. When the corpus root has a `GLOSSARY.md`, its terms are used verbatim in the inventory, the child prompts, and the synthesis.

---

## Personas (`personas/`)

Vibe personas are senior specialist roles. They **enforce** quality gates, **require** user interaction, and **produce** standardized, ASD-STE100 compliant outputs. All personas except `domain-expert` have `disable-model-invocation: true` — they are **only** triggered manually by the user.

See [`personas/README.md`](personas/README.md) for full details.

| Persona | Model-invocable | Description |
| --- | --- | --- |
| `domain-expert` | **yes** | Wrapper that loads the external `ask-the-expert` skill from `ai/skills/ask-the-expert` (cached from GitHub via `MANIFEST.json`, auto-updated on each run). Chooses **Consultant** or **Reviewer** mode and delegates execution. **Never** modifies the external skill's instructions. |
| `code-reviewer` | no | Orchestrates expert code reviews. Collects code based on trigger type (PR/diff, branch, paths), invokes `domain-expert` in Reviewer mode, **merges and contextualizes findings**, applies review standards, eliminates duplicates, and publishes a structured report (Overall Assessment, Critical Issues, Warnings, Suggestions, Strengths, Bill of Materials, Ponytail). For PR triggers, posts inline and summary comments. **Never** invents code. |
| `software-engineer` | no | Acts as a senior developer who turns an implementation or mitigation plan into merged-ready changes on an existing GitHub repo. Handles **leaf** tickets (implement → PR → review) and **EPICs** (detect sub-tickets → resolve dependency waves → implement one-by-one stacking branches via `gh-stack` with the EPIC branch as trunk → draft PR with cumulative diff → `code-reviewer` on top of stack). **Requires** a concrete plan — **stops** if none exists. **Never** implements without a plan. |
| `product-strategy` | no | Acts as a senior business consultant / product manager. Gathers domain context from `AGENTS.md`, `*.instructions.md`, and `GLOSSARY.md`. Defines features (problem → solution → persona → metric), analyzes competitors with web search, prioritizes with RICE or MoSCoW, and recommends roadmaps (Now/Next/Later). Delivers artifacts as Canvas or documents. Ends with top 3 recommendations, highest-risk assumption, and next step. |
| `solution-engineer` | no | Runs full solution-engineering pass: **Ponytail FULL** option-space research → architecture/technology selection (pressure-tested via `domain-expert` Consultant mode) → **grilling** the user to resolve unknowns (decision-tree rounds) → implementation plan with **two reviews**: Step 4a `domain-expert` (Consultant), Step 4b `ui-ux-expert` (only when frontend work exists — screens, components, web front-end, design system) → Step 4c complexity assessment (COMPLEX vs SIMPLE: very complex, multi-area, deep refactoring, or > ~256K-token context). **MANDATORY HARD STOP** after planning — on explicit continue, Phase 5 records the plan as GitHub Issue(s): ONE Issue for a SIMPLE plan, or ONE EPIC plus tracer-bullet sub-tickets for a COMPLEX plan; Phase 6 records ADRs; then the process STOPS — never any implementation. Never writes code unless asked. Ends with ASD-STE100 summary and Mermaid architecture diagram. |
| `support-engineer` | no | Diagnoses production problems (stacktrace, error, trace ID from Datadog/Cloudflare/Grafana/Sentry/CloudWatch). Triages → collects evidence (traces, spans, logs, stack frames) → locates code and identifies root cause with explicit confidence levels → hands over to `solution-engineer` with a complete package. **ALWAYS stops** when the plan is ready. Ends with ASD-STE100 summary: problem, evidence, root cause, next steps. |
| `test-engineer` | no | Runs automated API/web tests against deployed environments (typically staging after PR merge). Writes test plans with explicit expected results, runs PR-focused tests first, then full E2E regression, measures performance KPIs (p50/p95/p99 latency, throughput, error rates), compares against previous version baselines. Produces structured test reports using `report-template.md`. **Never** modifies application code. |
| `ui-ux-expert` | no | Senior UI/UX expert for progressive, fluent, mobile-first web design. Provides concrete design guidance (layout, hierarchy, typography, spacing, color, interaction states, WCAG accessibility, responsive behavior). Follows **shadcn** component model by default (Radix primitives, Tailwind, CSS variables). Builds working prototypes with production-like test data — never lorem ipsum. |

### Persona dependencies

| Persona | Depends On |
| --- | --- |
| `domain-expert` | `ask-the-expert` skill (external, cached from GitHub via `ai/skills/ask-the-expert`) |
| `code-reviewer` | `domain-expert` persona (Reviewer mode) |
| `solution-engineer` | `domain-expert` persona (Consultant, Step 4a) + `ui-ux-expert` persona (Step 4b, when frontend work exists) |
| `software-engineer` | `code-reviewer` persona (final review, Step 4); `gh-stack` skill (EPIC branch stacking, Step 2b) |

### Persona-to-persona references

| From | To | When |
| --- | --- | --- |
| `support-engineer` | `solution-engineer` | Phase 3 handover (plan only) |
| `solution-engineer` | `domain-expert` | Step 4a — plan review (Consultant mode) |
| `solution-engineer` | `ui-ux-expert` | Step 4b — UI/UX review (only if frontend work in plan) |
| `software-engineer` | `code-reviewer` | Step 4 — final review on leaf PR or top of EPIC stack |

---

## Required External Skills

The following skills are **not included** in this repo but may be required by workflows. Install them from their upstream sources.

| Skill | Description | Source |
| --- | --- | --- |
| `gh-stack` | Manage stacked branches and pull requests with the gh-stack GitHub CLI extension. Used by `software-engineer` for EPIC branch stacking. | [github/gh-stack](https://github.com/github/gh-stack) |
| `ponytail` | Lazy senior dev mode: the smallest change that fully solves the task. | [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) |

### Optional external skills

| Skill | Description | Source |
| --- | --- | --- |
| `convert-documents-to-markdown` | Convert Word, PowerPoint, Excel, OpenDocument, RTF, EPUB, CSV, and PDF files to GitHub-Flavored Markdown. | [firecrawl/anydoc](https://github.com/firecrawl/anydoc/tree/main/skills/convert-documents-to-markdown) |

#### Install external skills

**gh-stack** (CLI extension + agent skill):

```sh
gh extension install github/gh-stack
gh skill install github/gh-stack
```

**firecrawl/anydoc** (optional):

```sh
npx skills add firecrawl/anydoc
```

---

## Installation

### Grok Build

Grok loads user config from `~/.grok/`. Project-scoped MCP/plugins/permissions can also live in `.grok/config.toml` inside a repo.

```sh
mkdir -p ~/.grok
ln -sfn "$(pwd)/ai/skills" ~/.grok/skills
```

### Mistral Vibe

Vibe loads user config from `~/.vibe/`. Project-scoped config can also live in `.vibe/config.toml` inside a repo.

```sh
mkdir -p ~/.vibe
ln -sfn "$(pwd)/ai/personas" ~/.vibe/personas
```

### Config (`grok/config.toml`)

**Do not blind-overwrite** `~/.grok/config.toml` if it already has marketplace or personal settings. Merge the sections you want from `ai/grok/config.toml`:

| Section | What it carries |
| --- | --- |
| `[models]` | Default + web_search model (`grok-4.7`) |
| `[ui]` | Theme `auto` (system light/dark) |
| `[features]` | `lsp_tools = true` |
| `[session]` | Auto-compact threshold |
| `[mcp_servers.*]` | crates-io, bun-mcp, datadog, github |
| `[permission]` | GitHub MCP ask/allow-read patterns |

### Config (`vibe/config.toml`)

| Section | What it carries |
| --- | --- |
| `active_model` | `mistral-large-4` |
| `default_agent` | `smart-approve` |
| `[[mcp_servers]]` | crates-io, bun-mcp, github, datadog |

### Layout reference

| Scope | Grok Build | Mistral Vibe |
| --- | --- | --- |
| User config | `~/.grok/config.toml` | `~/.vibe/config.toml` |
| User skills | `~/.grok/skills/<name>/SKILL.md` | — |
| User personas | — | `~/.vibe/personas/<name>/SKILL.md` |
| Project config | `.grok/config.toml` | `.vibe/config.toml` |
| Project skills | `.grok/skills/` | — |
| Project personas | — | `.vibe/personas/` |

### MCP config

MCP servers are defined under `[mcp_servers.*]` in `ai/grok/config.toml` and `ai/vibe/config.toml`. Several need **per-user secrets** before they work. The repo uses `${ENV}` expansion so nothing sensitive is shared by default.

| Server | Env / fields | Notes |
| --- | --- | --- |
| `github` | `GITHUB_PERSONAL_ACCESS_TOKEN` | Classic or fine-grained PAT. Requires the `github-mcp-server` binary on `PATH`. |
| `datadog` | `DATADOG_MCP_TOKEN` | Used as `Bearer ${DATADOG_MCP_TOKEN}` for `mcp.datadoghq.eu`. **Disabled by default** in both configs. |
| `crates-io` | usually none | Needs `cratesio-mcp` available on `PATH`. |
| `bun-mcp` | usually none | Needs `bunx` available on `PATH`. |

Export tokens in your shell profile (or a secrets manager) before launching:

```sh
export GITHUB_PERSONAL_ACCESS_TOKEN=ghp_...
export DATADOG_MCP_TOKEN=...   # when enabling Datadog MCP
```

> [!WARNING]
> Never commit a populated config with real tokens. Only `${ENV}` placeholders should be tracked. Before `git add`/`commit`, confirm `git diff ai/grok/config.toml ai/vibe/config.toml` does not contain PATs, Bearer tokens, or other secrets.
