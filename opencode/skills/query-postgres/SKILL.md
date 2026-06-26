---
name: query-postgres
description: Connect to Postgres databases via the psql CLI using per-environment credential files (e.g. env.prod) and run SQL queries. Use when the user wants to query a Postgres database, inspect or analyze data, run ad hoc SQL, or explore schema. Defaults to a read-only session and requires explicit user confirmation plus --write to run INSERT/UPDATE/DELETE/DDL statements.
---

# Query Postgres

Wraps `psql` with per-environment credential files and safe non-interactive
defaults (no pager, abort on error, read-only unless explicitly overridden).
Use `scripts/pg_query.sh` instead of invoking `psql` directly.

## One-Time Setup

Create a credentials file per environment at `env.<environment>`, directly in
this skill's root directory (gitignored, never commit):

```bash
cat > <skill-dir>/env.prod <<'EOF'
PGHOST=<hostname>
PGPORT=5432
PGDATABASE=<database>
PGUSER=<username>
PGPASSWORD=<password>
PGSSLMODE=require
EOF
```

Replace `<skill-dir>` with this skill's actual directory.

## Running Queries

```bash
scripts/pg_query.sh prod -c "SELECT * FROM your_table LIMIT 10"
scripts/pg_query.sh prod -f path/to/query.sql
scripts/pg_query.sh prod --csv -c "SELECT ..."   # machine-readable output
scripts/pg_query.sh                              # no args: lists configured environments
```

Every invocation runs with `-P pager=off -v ON_ERROR_STOP=1`, so it's safe to
call from a non-interactive shell.

## Safety: Read-Only By Default

Every session is opened read-only at the Postgres level
(`default_transaction_read_only=on`) -- INSERT/UPDATE/DELETE/DDL statements
fail with a Postgres error unless `--write` is passed:

```bash
scripts/pg_query.sh prod --write -c "UPDATE ..."
```

**Before ever adding `--write`**, show the exact SQL statement to the user
and get explicit confirmation -- especially against `prod`. Never assume a
write is wanted just because a query fails read-only.

## Output Tips

- Default aligned table output is fine for reading results directly.
- Use `--csv` (or `-A -F ','`) when the result needs to be parsed or exported.
- For very wide rows, add `-x` (expanded output, one column per line).
