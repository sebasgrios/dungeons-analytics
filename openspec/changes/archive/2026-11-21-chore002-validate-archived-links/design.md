## Context

The [packaging spec](https://github.com/sebasgrios/dungeons-analytics/blob/1e57aa71094c5f084ca15a397b3949a4aa5e26dd/openspec/changes/chore001-package-diagnostic-builds/design.md) links to the release and installation guides with relative paths. The [first main build](https://github.com/sebasgrios/dungeons-analytics/actions/runs/44861373640) passed its round-trip checks and published a ZIP whose recorded and uploaded SHA-256 digests match. The [repository validator](https://github.com/sebasgrios/dungeons-analytics/blob/1e57aa71094c5f084ca15a397b3949a4aa5e26dd/scripts/validate-repository.mjs) currently checks those relative references from the new folder. The [traceability contract](https://github.com/sebasgrios/dungeons-analytics/blob/1e57aa71094c5f084ca15a397b3949a4aa5e26dd/docs/SDD_COMPLIANCE.md) requires byte-for-byte preservation.

## Goals and Non-Goals

Preserve the existing approved content and validate its intended repository references. Keep ordinary relative links and internal archive links under the existing checks. New approved documents should use full permalinks for references outside their change. Legacy GitHub-rendered links remain part of the preserved historical record and are available at their original proposal commit.

## Decisions

- Resolve the target in the current checkout first. Restrict the fallback to a recognized dated OpenSpec change archive.
- Reconstruct the original active artifact location by taking the dated change ID out of the archive folder name and retaining its internal path. Resolve the same relative reference from that location.
- Accept the reconstructed target only when it exists, stays within the repo and refers outside the original change folder. An internal archive link still requires its corresponding archived sibling. Missing, escaping or malformed targets fail validation.
- Add isolated regressions for direct links, legacy docs links, archived siblings, missing internal and external targets, and invalid archive paths. Preserve the existing merge and CI authorization model.

## Risks and Trade-offs

The compatibility path is deliberately limited to historical records. Keep full links to stable external documents in new specs so GitHub can render them after archival. Do not rewrite approved bytes or add mirrored project docs solely to satisfy the validator.

## Rollout

Run the Node regression and existing repository validation. Once this change lands, submit archival of the packaging spec with the successful main execution as evidence.
