---
name: ask-the-expert
description: Consult domain specialists in Consultant mode (ideation,
  brainstorming, troubleshooting, plan improvements) or Reviewer mode (explicit
  review of a pull request, branch, repository, or snippet) when the work
  touches server-side JavaScript/TypeScript, CI/CD, GIS, PostgreSQL, Python,
  Rust, Java Spring Boot, Swift, web front-end, or web UI/UX. Loads the external
  ask-the-expert skill from GitHub after checking it for updates.
---
# ask-the-expert (wrapper)

This skill orchestrates the external `ask-the-expert` skill maintained at
`appelgriebsch/dotFiles` (`ai/skills/ask-the-expert`). It owns three things:
keeping a local cache of the external skill current, choosing the mode, and
delegating execution to the external skill's own instructions.

## 1. Update check (always, before invoking)

Read `MANIFEST.json` in this skill's directory. It lists the source repo, the
raw-file base URL, the tracked file list, the cache directory, and the version
marker path. Then:

1. Determine the remote version by opening the manifest's `version_url`
   (GitHub tree page of the skill directory) and reading the latest commit
   SHA shown for that directory.
2. Read the local version marker (`cache/VERSION` relative to this skill's
   directory).
3. Compare:
   - **Match** (marker absent counts as mismatch on first run): use the cache
     as-is and skip to step 2.
   - **Mismatch**: re-download every file in the manifest's `files` list from
     `raw_base` + "/" + file path, overwrite it in the cache, and write the
     new commit SHA to the version marker. Report that the external skill was
     updated.

Fallbacks, in order, if a step cannot reach GitHub:
- If the version page fails, fetch the raw `SKILL.md` from `raw_base` and
  compare with the cached `cache/SKILL.md`; if it differs, refresh all files
  and write `unknown` plus the fetch date as the version marker.
- If both fail but a cache exists, proceed with the cached copy and state that
  the update check was skipped.
- If both fail and no cache exists, stop and report that the external skill
  could not be loaded.

Only fetch files listed in the manifest. Cache layout mirrors the external
skill: `cache/SKILL.md`, `cache/references/…`.

## 2. Choose the mode

- **Reviewer** when the request is an explicit review of a pull request,
  branch, repository, or code snippet.
- **Consultant** otherwise (ideation, brainstorming, troubleshooting,
  improvements to an implementation plan).

State the chosen mode to the user before dispatching.

## 3. Invoke the external skill

Read `cache/SKILL.md` and follow it exactly, treating the `cache/` directory
as that skill's root so its relative references (`references/modes.md`,
`references/domains/<id>.md`) resolve to the cached files. Pass through:

- The chosen **mode** and the user's consultation question or review target
- Any focus material (diff, files, designs, logs) the user provided

Do not modify the external skill's instructions: mode selection, screening
corpus, technology inventory, parallel domain dispatch, and synthesis (including
the Reviewer bill of materials) all follow the cached external `SKILL.md`. This
wrapper adds no extra steps beyond the update check and mode choice.
