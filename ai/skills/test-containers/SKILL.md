---
name: it-test-containers
description: Brings up (and tears down) the containers a project needs for its integration tests, using whichever container runtime is available — docker, podman, or the macOS-native "container" CLI, checked in that priority order. Use when the user asks to prepare/start/stop containers for integration tests, e.g. "prepare for IT tests", "start the docker containers for integration tests", "bring up containers for the ITs", "spin up podman for tests", or before running an integration test suite that requires a database/broker/etc. running in containers.
---

# IT Test Containers

## Overview

Integration test suites usually depend on containers (Postgres, RabbitMQ, etc.) being up before tests run. This skill discovers how a given project starts those containers, picks an available container tool, and executes the (possibly translated) start/stop commands.

## Workflow

1. **Detect the available tool.** Run `scripts/detect_tool.sh`. It checks `docker` → `podman` → `container` in that order and prints the first one whose binary AND daemon/service are both available. If it exits 1, relay its stderr message to the user (no tool found, or a daemon needs manual starting) and stop.

2. **Discover the project's container setup**, in this order:
   - Grep `AGENTS.md`, `*.instructions.md`, and `README.md` for container startup instructions.
   - If nothing found, fall back to detecting `docker-compose.yml`/`compose.yaml`, a Maven `docker-maven-plugin`/fabric8 config, Testcontainers usage, or Gradle equivalents.
   - See `references/config-discovery.md` for exact grep patterns and file locations to check.

3. **Reconcile the discovered commands with the detected tool.** If the instructions name a different tool than the one detected (e.g. instructions say `docker` but only `podman` is installed), translate:
   - For plain CLI commands (`ps`, `kill`, `rm`, `run`, `logs`), substitute per the table in `references/command-mapping.md`.
   - For Maven/Testcontainers-driven flows (e.g. `mvn -Pit docker:start`), prefer bridging via `DOCKER_HOST` pointed at podman's Docker-API-compatible socket rather than rewriting Maven goals — the plugin itself talks to the Docker API, not literal shell commands.
   - If the only available tool is the macOS `container` CLI and the project needs compose or the Docker API (Testcontainers, docker-maven-plugin), first tell the user this combination isn't natively supported and ask how they want to proceed. If they ask you to translate the plugin's declared containers into direct `container run` commands, extract the image/alias/env/port config manually — see "Manual extraction fallback" in `references/command-mapping.md` — instead of running the Maven goal itself. Run the rest of the Maven lifecycle (migrations, tests) with `-Ddocker.skip=true` so Maven doesn't also try to talk to the Docker API.

4. **Execute** the resulting start command(s). Prefer running any documented cleanup step first (e.g. killing/removing stale containers) exactly as instructed, translated per step 3.

5. **Verify** containers are actually up: list containers with the tool-appropriate list command (`docker ps` / `podman ps` / `container list`) and confirm the expected services/ports are present before telling the user IT tests are ready to run.

6. **Stopping/cleanup**: when asked to tear down, run the project's documented stop command (translated the same way), or fall back to killing/removing all containers started by this session if no explicit stop command is documented. Confirm with the user before removing containers not obviously related to this project.

## Resources

- `scripts/detect_tool.sh` — deterministic tool-detection script (docker > podman > container priority, checks daemon reachability too).
- `references/command-mapping.md` — command-equivalence table across docker/podman/container, `DOCKER_HOST` bridging for Maven/Testcontainers, and macOS `container` CLI limitations (no compose, no Docker-API socket).
- `references/config-discovery.md` — where and how to find a project's documented container startup steps, and fallback config-file signals when no instructions exist.