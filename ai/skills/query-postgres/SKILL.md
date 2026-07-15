---
name: query-postgres
description: Connect to Postgres databases via the psql CLI using per-environment credential files (e.g. env.prod) and run SQL queries. Use when the user wants to query a Postgres database, inspect or analyze data, run ad hoc SQL, or explore schema. Defaults to a read-only session and requires explicit user confirmation plus --write to run INSERT/UPDATE/DELETE/DDL statements.
---

# Query Postgres

**Read-only by default.** Wraps `psql` with per-environment credential files and safe non-interactive defaults (no pager, abort on error). Use `scripts/pg_query.sh` instead of invoking `psql` directly.

Credential file layout and output flags: [`references/setup.md`](references/setup.md).

## Running queries

```bash
scripts/pg_query.sh prod -c "SELECT * FROM your_table LIMIT 10"
scripts/pg_query.sh prod -f path/to/query.sql
scripts/pg_query.sh prod --csv -c "SELECT ..."   # machine-readable output
scripts/pg_query.sh                              # no args: lists configured environments
```

Every invocation runs with `-P pager=off -v ON_ERROR_STOP=1`.

## Safety: read-only by default

Every session opens with `default_transaction_read_only=on`. Writes fail unless `--write` is passed:

```bash
scripts/pg_query.sh prod --write -c "UPDATE ..."
```

**Before ever adding `--write`**, show the exact SQL to the user and get explicit confirmation — especially against `prod`. Do not assume a write is wanted because a query failed read-only.
