# Discovering how a project starts its IT containers

Table of contents:
- Where to look, in order
- Patterns to grep for
- Extracting the actual commands
- Fallback: inferring from config when no instructions exist

## Where to look, in order

1. `AGENTS.md` at the repo root (or nearest ancestor directory).
2. Any `*.instructions.md` file (root or `.github/instructions/`, `.copilot/instructions/`, etc.).
3. `README.md` sections mentioning "integration test", "docker", "IT", "containers".
4. Fallback config files (see below) if none of the above mention container setup.

## Patterns to grep for

```bash
grep -rEn "docker (compose|run|kill|rm|ps)|podman|container (system|run|list)|docker:start|testcontainers" \
  AGENTS.md README.md **/*.instructions.md 2>/dev/null
```

Look specifically for fenced code blocks near headings like "Integration Test", "IT Test", "Docker", "Prerequisites", "Development Commands" — these usually contain the exact copy-pasteable commands the project expects (e.g. this repo's AGENTS.md documents `docker kill $(docker ps -q) && docker rm $(docker ps -qa) && mvn -Pit docker:start ...`).

## Extracting the actual commands

Once found, copy the command(s) verbatim as the starting point, then:
1. Identify the container tool named in the command (usually `docker`).
2. Determine the tool actually selected by `scripts/detect_tool.sh` (docker > podman > container priority).
3. If the selected tool differs from the one named in the instructions, translate using `references/command-mapping.md`. For Maven/Testcontainers-driven flows, prefer bridging via `DOCKER_HOST` (podman) over rewriting every CLI call, since the plugin itself still shells out to a `docker`-named binary or Docker API — not to the literal instruction commands.

## Fallback: inferring from config when no instructions exist

If no instructions file documents container startup, look for:

| File | What it tells you |
|---|---|
| `docker-compose.yml` / `compose.yaml` (repo root or `src/test/resources/`) | Services, images, ports to bring up — run via `docker compose up -d` / `podman compose up -d` |
| `pom.xml` — `docker-maven-plugin` / `fabric8` config | Maven goals like `docker:start`/`docker:stop`, and the images/ports Maven manages | 
| `pom.xml` — Testcontainers dependency | Containers are usually started automatically by the test JVM; you may only need the daemon/socket running, not manual `docker run` commands |
| `build.gradle(.kts)` equivalents of the above | Same idea for Gradle projects |

When falling back to config-derived commands, state clearly to the user which file you inferred them from, since this is a best-effort guess rather than an explicit project instruction.
