## Why

The diagnostic writes historical and current meter notifications to the same bounded stream as dungeon transitions. Interleaved notification IDs repeatedly clear the existing single-ID filter. Background meter samples can likewise displace the baseline, combat and manual samples needed to interpret a run. The result can be a saved record with recent meter activity and insufficient evidence about how the run started or ended.

## What Changes

- Reserve bounded retention for lifecycle records and for baseline, combat and manual samples when meter notifications are frequent.
- Coalesce repeated meter updates without losing the bounded sampling needed to observe late totals. Corroborate historical detail IDs with the readable session catalogue.
- Preserve existing account SavedVariables and the ability to export their retained records. Record the remaining client acceptance separately from automated checks.

## Capabilities

### New Capabilities
- `diagnostic-evidence-retention`: Preserve the evidence needed to interpret a diagnostic capture under repeated meter updates.

## Impact

Affects the diagnostic recorder, local store, targeted tests and diagnostic documentation. The change does not add a capture source, change opt-in behavior, control the native meter or modify the report window.
