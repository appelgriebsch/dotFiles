---
name: test-containers
description: IT test containers. Use to start or stop the containers a project's integration tests need (docker, podman, or the macOS container CLI).
---

# IT test containers

## Step 1 — Detect the tool

Run `scripts/detect_tool.sh`. It prints the selected tool on stdout. If it exits 1, relay stderr to the user and stop.

**Done when:** the tool name is known, or the run stopped on the script’s error.

## Step 2 — Discover the project's container setup

Follow [`references/config-discovery.md`](references/config-discovery.md): `AGENTS.md` → `*.instructions.md` → `README.md` → config-file fallback. Copy documented commands verbatim, then reconcile in step 3.

**Done when:** start (and optional stop) commands or the plugin flow are identified, including the file they came from.

## Step 3 — Reconcile commands with the detected tool

If the instructions name a different tool than the one detected, translate using [`references/command-mapping.md`](references/command-mapping.md):

- Plain CLI (`ps`, `kill`, `rm`, `run`, `logs`): substitute per that table.
- Maven/Testcontainers (e.g. `mvn -Pit docker:start`): prefer `DOCKER_HOST` pointed at podman's Docker-API-compatible socket over rewriting Maven goals — the plugin talks to the Docker API.
- macOS `container` CLI with compose or the Docker API (Testcontainers, docker-maven-plugin): tell the user this combination isn't natively supported and ask how to proceed. Manual extraction into `container run` only with user opt-in — see "Manual extraction fallback" in `command-mapping.md`. Run the rest of the Maven lifecycle with `-Ddocker.skip=true`.

**Done when:** the final command list (or user-approved fallback) is ready to run.

## Step 4 — Start

Run the start command(s). Prefer any documented cleanup first (kill/remove stale containers), translated per step 3.

**Done when:** start commands finished without unhandled failure.

## Step 5 — Verify

List containers with the tool-appropriate list command (`docker ps` / `podman ps` / `container list`) and confirm the expected services/ports are present before saying IT tests are ready.

**Done when:** expected services/ports appear in the list output, or every gap is reported.

## Step 6 — Stop / cleanup

When asked to tear down, run the project's documented stop command (translated the same way), or kill/remove containers started by this session if no stop command is documented. Confirm with the user before removing containers not obviously related to this project.

**Done when:** stop/cleanup completed, or the user declined those removals.
