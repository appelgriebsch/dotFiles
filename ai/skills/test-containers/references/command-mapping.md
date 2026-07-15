# Command mapping: docker vs podman vs container

Table of contents:
- Daemon/service startup
- Basic container lifecycle (ps/kill/rm)
- Compose support
- Bridging tools that shell out to "docker" (Testcontainers, docker-maven-plugin, Maven `docker:start`)
- Known gaps of the macOS `container` CLI

## Daemon/service startup

| Tool | Start service | Notes |
|---|---|---|
| docker | Docker Desktop must be running (`open -a Docker` on macOS) | `docker info` fails if the daemon isn't up |
| podman | `podman machine start` (macOS, once per boot) | On Linux podman is daemonless, no start needed |
| container | `container system start` | Installs a Linux kernel on first run if missing |

## Basic container lifecycle

| Action | docker | podman | container |
|---|---|---|---|
| List running | `docker ps` | `podman ps` | `container list` (alias `container ls`) |
| List all | `docker ps -a` | `podman ps -a` | `container list --all` (alias `-a`) |
| Kill all running | `docker kill $(docker ps -q)` | `podman kill $(podman ps -q)` | `container kill $(container ls -q)` |
| Remove all | `docker rm $(docker ps -qa)` | `podman rm $(podman ps -qa)` | `container delete $(container ls -a -q)` (alias `container rm`) |
| Logs | `docker logs <id>` | `podman logs <id>` | `container logs <id>` |
| Run | `docker run ...` | `podman run ...` (drop-in compatible) | `container run ...` (flag set differs, e.g. `--memory`, `--cpus`; see `container run --help`) |

podman's CLI is a near drop-in replacement for docker — when instructions say `docker <subcommand>`, substituting the binary name to `podman` almost always works unchanged.

The `container` CLI has different subcommand names/aliases (`list`/`ls`, `delete`/`rm`) and does **not** support `docker-compose`-style multi-service files natively — there is no `container compose` subcommand as of CLI version 1.x. Do not assume flag-for-flag compatibility; check `container <subcommand> --help` before running an unverified command.

## Compose support

| Tool | Compose command |
|---|---|
| docker | `docker compose up -d` / `docker compose down` |
| podman | `podman compose up -d` if `podman-compose` (or docker-compose) is installed; otherwise install `podman-compose` |
| container | No native compose. Either translate each service in `docker-compose.yml` into an individual `container run` command, or fall back to docker/podman for that project. Report this limitation to the user instead of guessing. |

## Bridging tools that shell out to "docker" (Testcontainers, docker-maven-plugin)

Many Java integration-test setups (via `mvn -Pit docker:start` / fabric8 docker-maven-plugin, and Testcontainers) don't call the `docker` binary directly — they talk to the Docker Engine API over a socket referenced by `DOCKER_HOST`.

- **podman**: exposes a Docker-API-compatible socket. Point tooling at it instead of translating each CLI command:
  ```bash
  podman machine start   # macOS only
  export DOCKER_HOST="unix://$(podman machine inspect --format '{{.ConnectionInfo.PodmanSocket.Path}}')"
  # Linux (rootless): export DOCKER_HOST="unix:///run/user/$(id -u)/podman/podman.sock"
  ```
  With `DOCKER_HOST` set, `mvn -Pit docker:start`, Testcontainers, etc. work unmodified.
- **container**: does **not** expose a Docker-API-compatible socket. Tools that require the Docker API (docker-maven-plugin, Testcontainers) will not work against it. If `container` is the only tool available and the project's IT setup depends on the Docker API, tell the user this is unsupported and ask before attempting any workaround.

### Manual extraction fallback (container CLI only, user opts in)

If the user explicitly asks to proceed anyway with the `container` CLI, don't try to run the Maven/Testcontainers goal itself — instead manually extract the declared container config and start each one directly:

1. **Find the plugin config.** The `docker-maven-plugin`/fabric8 `<imagesMap>` (or equivalent Testcontainers setup) may live in a parent POM inherited via Maven's reactor rather than the module's own `pom.xml`. Search cached parent POMs under `~/.m2/repository/**/*.pom` (`grep -n "docker-maven-plugin\|<imagesMap>\|<image>" ...`) if the module pom itself has no hits — walk up the `<parent>` chain if needed.
2. **Read each `<image>` block** for: image name (resolve any `${property}` placeholders from `<properties>` in the module or parent POMs), `<alias>` (container name), `<env>` vars, `<ports>` (`hostPort:containerPort`), and any `<wait>` config (informs what port/log to poll for readiness).
3. **Check for stale state**: `container ls -a` for leftover containers from a prior run; `container delete <name>` any before restarting with the same alias.
4. **Start each container** with `container run -d --name <alias> -e KEY=VALUE -p <hostPort>:<containerPort> <image>` for every declared image (e.g. Postgres, RabbitMQ). Reuse the exact alias/env/ports from the plugin config so downstream test config (e.g. `application-*.yml` pointing at `localhost:<hostPort>`) matches unchanged.
5. **Verify** with `container ls` (state, ports) and a raw TCP check per port, e.g. `nc -zv localhost <hostPort>`, before declaring containers ready.
6. **Skip the plugin's own docker step** in later Maven invocations with `-Ddocker.skip=true` so it doesn't also try (and fail) to talk to the Docker API — let Maven handle only the parts that don't need it (schema migration, tests).

## Known gaps of the macOS `container` CLI

- No compose equivalent.
- No Docker-API-compatible socket (breaks Testcontainers / docker-maven-plugin / docker-java clients).
- Requires macOS 26+ and Apple silicon.
- Different default resource limits (1 GiB RAM / 4 CPUs) — adjust with `--memory` / `--cpus` on `container run` if a project's compose file specifies resource limits.