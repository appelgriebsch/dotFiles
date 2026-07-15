#!/usr/bin/env bash
#
# pg_query.sh - Connect to a Postgres database using per-environment
# credential files and run psql non-interactively (or interactively).
#
# Usage:
#   pg_query.sh                              List available environments
#   pg_query.sh <environment> [psql-args...]
#   pg_query.sh <environment> --write [psql-args...]
#
# Examples:
#   pg_query.sh prod -c "SELECT 1"
#   pg_query.sh prod -f query.sql
#   pg_query.sh prod --csv -c "SELECT * FROM your_table LIMIT 5"
#   pg_query.sh prod --write -c "UPDATE ..."   # only after explicit user confirmation
#
# Credentials come from <skill-dir>/env.<environment>, e.g. env.prod:
#   PGHOST=...
#   PGPORT=5432
#   PGDATABASE=...
#   PGUSER=...
#   PGPASSWORD=...
#
# Safety: by default the session is forced read-only at the Postgres level
# (any INSERT/UPDATE/DELETE/DDL statement will error). Pass --write to lift
# this for the current invocation only.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"

list_environments() {
  local found=0
  for f in "$SKILL_DIR"/env.*; do
    [[ -e "$f" ]] || continue
    echo "  $(basename "$f" | sed 's/^env\.//')"
    found=1
  done
  if [[ "$found" -eq 0 ]]; then
    echo "  (none found -- create $SKILL_DIR/env.<environment>, see SKILL.md)"
  fi
}

print_usage() {
  echo "Usage: $(basename "$0") <environment> [--write] [psql-args...]"
  echo
  echo "Available environments:"
  list_environments
}

if [[ $# -lt 1 ]]; then
  print_usage
  exit 1
fi

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  print_usage
  exit 0
fi

ENVIRONMENT="$1"
shift

ENV_FILE="$SKILL_DIR/env.$ENVIRONMENT"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "Error: no credentials file found for environment '$ENVIRONMENT' ($ENV_FILE)" >&2
  echo >&2
  echo "Available environments:" >&2
  list_environments >&2
  echo >&2
  echo "See SKILL.md for how to create one." >&2
  exit 1
fi

WRITE_MODE=0
ARGS=()
for arg in "$@"; do
  if [[ "$arg" == "--write" ]]; then
    WRITE_MODE=1
  else
    ARGS+=("$arg")
  fi
done

set -a
# shellcheck disable=SC1090
source "$ENV_FILE"
set +a

if [[ "$WRITE_MODE" -eq 1 ]]; then
  echo "Write mode enabled for '$ENVIRONMENT' -- statements may modify data." >&2
else
  export PGOPTIONS="${PGOPTIONS:-} -c default_transaction_read_only=on"
fi

exec psql -P pager=off -v ON_ERROR_STOP=1 "${ARGS[@]}"
