#!/usr/bin/env bash
# Detects which container runtime to use, in priority order: docker > podman > container.
# Prints the tool name on stdout ("docker", "podman", or "container") and exits 0.
# Exits 1 with a message on stderr if none are available.
#
# Usage: detect_tool.sh

set -euo pipefail

check_daemon() {
    local tool="$1"
    case "$tool" in
        docker)
            docker info >/dev/null 2>&1
            ;;
        podman)
            podman info >/dev/null 2>&1
            ;;
        container)
            container system status >/dev/null 2>&1
            ;;
    esac
}

for tool in docker podman container; do
    if command -v "$tool" >/dev/null 2>&1; then
        if check_daemon "$tool"; then
            echo "$tool"
            exit 0
        else
            echo "found '$tool' binary but its daemon/service is not running (see references/command-mapping.md for how to start it)" >&2
        fi
    fi
done

echo "No supported container tool found. Install docker, podman, or the macOS 'container' CLI." >&2
exit 1
