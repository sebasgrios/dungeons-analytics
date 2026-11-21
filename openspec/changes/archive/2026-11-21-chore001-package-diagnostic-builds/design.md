## Context

[PR #2](https://github.com/sebasgrios/dungeons-analytics/pull/2) integrated the diagnostic. The [release policy](../../../docs/RELEASES.md) requires creator attribution and explicit owner control for releases. The [installation instructions](../../../docs/INSTALLATION.md) distinguish the installable tree from GitHub's source archive.

## Goals and Non-Goals

Make a diagnostic for a recorded main commit installable from one ZIP. Keep game validation and release publication independent of packaging. The artifact is a temporary test build generated through Actions.

## Decisions

- Use the Python standard library for the ZIP, hashing and package tests on the Actions runner. Python is a development dependency of the packager only.
- Read the installed TOC and declared relative Lua or XML files from one immutable Git commit. Include the tracked LICENSE and NOTICE under DungeonsAnalytics/. Reject missing, repeated, escaping, absolute or case-colliding archive paths. Keep the exact tracked bytes and leave files outside the approved payload out of the ZIP.
- Sort the paths and normalize ZIP member metadata with a fixed timestamp, file permissions and storage mode. Confirm two builds of the same commit have identical SHA-256 digests. Report the full commit, TOC interface and development version in the workflow summary. The ZIP file name carries a short commit identifier.
- Add a separate workflow dispatched on main. Resolve the exact selected main commit from GitHub, run package and archive checks with a read-only token, and upload only the checked ZIP with a short retention period. Use the documented direct single-file upload from [GitHub's artifact action](https://github.com/actions/upload-artifact) so the installable ZIP keeps its name. The workflow writes neither releases nor tags and is independent of the four required PR checks.
- Verify the real archive has a single DungeonsAnalytics directory, a readable TOC and every declared file and attribution notice. Existing source install remains available for unpublished branches. Future runtime assets can extend the package contract under an approved change.

## Risks and Trade-offs

A short retention window limits reliance on old binaries. Testers should record the full source commit from the Actions summary before reporting a result. The upload and extraction checks establish package integrity. WoW loads and behavioral tests still need real-client acceptance.

## Rollout

Verify repository and packaging tests in the implementation PR. After merge, dispatch once from main and inspect the emitted file, source commit, contents and digest. Document the verified distribution steps and leave in-game checks pending wherever evidence is missing.
