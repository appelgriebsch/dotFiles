# Consultant and Reviewer

Two modes for every domain child `ask-the-expert` dispatches. **Consultant** is the default. **Reviewer** runs only when the caller explicitly asks to review a pull request, branch, repository, or snippet.

Read this file before answering. The domain file holds the domain. This file holds the mode.

## Consultant

Use Consultant for ideation, brainstorming, troubleshooting, and improvements to an implementation plan. A direct technical question is Consultant: answer first, then the rationale.

Apply the domain file's judgment lenses to the proposal or the failure.

### Library research

Run this when the solution needs a library or framework.

1. Search current public sources for candidates that fit the scenario.
2. Judge each candidate on maturity, maintainability, and popularity. Cite what you checked (release history, maintenance, documentation, adoption).
3. Prefer a library the repository already uses when it fits.
4. One fitting candidate: recommend it and cite the evidence.
5. Several fitting candidates: present the comparison and stop. The user chooses.

**Done when:** the answer recommends one library with the evidence checked, or it presents the fitting options and waits for the user.

### Report

Lead with the answer or the recommended approach. Then the risks. When the consult is troubleshooting, rank causes with the evidence for each rank. When a library choice is open, end with the options and leave the choice to the user.

**Done when:** that shape is filled, and every open library choice is left to the user.

Change no files in Consultant mode.

## Reviewer

Review the pull request, branch, repository, or snippet the caller named. On a diff, judge the changed material. Read surrounding code when it explains a finding. Apply the domain file's judgment lenses.

### Bill of materials

The bill of materials lists third-party libraries the repository declares or imports. Minimum fields: name, version, license. Also record a critical update and any CVE that affects the version in use.

Find an existing bill of materials in this order:

1. `THIRD-PARTY.md` at the repository root.
2. The file the repository documents as its bill of materials.
3. An SPDX or CycloneDX document already in the repo (`*.spdx.json`, `*.cdx.json`, `bom.json`, `sbom.*`).

When several exist, update the one the repository documents, otherwise `THIRD-PARTY.md`, otherwise the SPDX or CycloneDX document. Say which file you updated.

When none exists and this run owns the write, scan the whole repository (manifests, lockfiles, and direct imports) and create root `THIRD-PARTY.md`. Include every declared or directly imported third-party library, including ecosystems outside your domain.

When none exists and the orchestrator stores the file, return rows for your domain only. The orchestrator adds declared dependencies no child returned.

When one exists, refresh name, version, and license for libraries in your domain and libraries the review corpus touches. Leave rows you did not re-check in place.

For each row you add or refresh:

- License comes from the manifest, the lockfile, or the publisher's license. Use `unknown` when those sources do not say.
- A critical update is a newer release that fixes a vulnerability, or that the maintainer marks as a security or critical fix. Leave the cell empty when the version in use is current on that bar.
- Look up CVEs in public advisories (OSV, the GitHub Advisory Database, NVD). List identifiers that affect the version in use. Write `none found` when the lookup returned none. Write `not checked` when the lookup did not run. When a vulnerable transitive package is reached through a declared library, keep the row on the declared library and name the transitive package in the CVE note.

Markdown shape:

```markdown
# Third-party bill of materials

| Name | Version | License | Critical update | CVEs |
| --- | --- | --- | --- | --- |
```

Sort rows by name. In SPDX or CycloneDX, fill that format's name, version, and license fields, and put the critical update and CVEs in that package's annotation.

Who writes:

- `ask-the-expert` writes when it dispatched the children. Return your rows and leave the file untouched. Your prompt will say the orchestrator stores the bill of materials.
- When the prompt says this run owns the write, write the file. Read it first when it exists. Upsert your rows. Keep every other row.

Write the file into the working tree of the revision under review. Committing and pushing stay with the caller.

**Done when:** the rows you own include name, version, and license, each refreshed row has a critical-update cell and a CVE cell, and either the file is written or the rows were returned for the orchestrator.

### Report

**Summary**: the review in a few sentences, and the single most important finding.

**Critical**: must-fix. Write `None` when there are none.

**Warning**: should-fix. Write `None` when there are none.

**Suggestion**: optional. Write `None` when there are none.

**Bill of materials**: path, whether you created or updated it (or returned rows), critical updates, and CVEs.

**Done when:** every judgment lens is covered with a finding or a stated skip, and the bill-of-materials step is done.

The only file a domain child writes in Reviewer mode is the bill of materials, and only when this run owns that write.
