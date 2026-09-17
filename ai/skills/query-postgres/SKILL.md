---
name: query-postgres
description: Query Postgres. Use to query, inspect, analyze, run ad hoc SQL, or explore schema. Read-only by default; `--write` only after explicit confirmation.
---

# Query Postgres

Run SQL with `scripts/pg_query.sh`. Credential file layout and output flags: [`references/setup.md`](references/setup.md).

## Step 1 — Invoke

```bash
scripts/pg_query.sh prod -c "SELECT * FROM your_table LIMIT 10"
scripts/pg_query.sh prod -f path/to/query.sql
scripts/pg_query.sh prod --csv -c "SELECT ..."   # machine-readable output
scripts/pg_query.sh                              # no args: lists configured environments
```

The first argument is the environment name (`prod` loads `env.prod`). Create a missing env file per [`references/setup.md`](references/setup.md). The script opens a read-only session unless `--write` is passed; write statements error until that flag is used.

**Done when:** the environment is known (listed or created) and the script has printed the result — or the exact write SQL is ready for confirmation.

## Writes — `--write` after confirmation

Show the exact SQL and get explicit confirmation — especially against `prod` — then pass `--write` on that invocation only:

```bash
scripts/pg_query.sh prod --write -c "UPDATE ..."
```

A read-only error is not confirmation.

**Done when:** the user confirmed that exact SQL, `--write` was used for that invocation only, and the script finished (or the user declined).
