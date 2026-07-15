# Setup and output tips

## One-time setup

Create a credentials file per environment at `env.<environment>`, directly in this skill's root directory (gitignored, never commit):

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

## Output tips

- Default aligned table output is fine for reading results directly.
- Use `--csv` (or `-A -F ','`) when the result needs to be parsed or exported.
- For very wide rows, add `-x` (expanded output, one column per line).
