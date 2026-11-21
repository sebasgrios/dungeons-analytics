## Why

OpenSpec archives preserve approved files byte-for-byte. Moving a change into the dated archive adds one directory level. Existing approved designs contain relative links to repository docs that are valid at their original location. The repository validator currently resolves every link from its physical file location, preventing an otherwise valid archival transaction.

## What Changes

- Validate legacy references from dated archives using their original change location when the linked file lies outside that change.
- Preserve archived content, check actual archived siblings and reject unresolved targets.
- Document portable link conventions for new approved specs and test the relocation behavior.

## Capabilities

### New Capabilities

- archival-reference-validation defines repository link checks for immutable OpenSpec archives.

### Modified Capabilities

None.

## Impact

Affects repository validation, tests and the OpenSpec guidance. The first affected acceptance unit is diagnostic ZIP packaging, whose workflow and verified artifact are available on main. Reverting the implementation restores the original validation behavior.
