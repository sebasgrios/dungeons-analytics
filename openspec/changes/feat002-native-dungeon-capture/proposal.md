## Why

Dungeons Analytics needs to capture actual Forever dungeon runs before history, summaries and the interactive timeline can consume them. The diagnostic observed two solo pulls with distinct catalogue entries on build `1.60.1.71139`. It also observed reused session IDs after a reset, changing durations across checkpoints and selection of an earlier historical entry on exit. The queued run recorded boss outcomes and a late damage update. The tester confirmed completion, and the export contained no delivery of the registered completion event.

## What Changes

- Start a bounded, in-memory run automatically when the Forever client identifies a dungeon. Record observed map, difficulty, timing, roster revisions and partial coverage.
- Correlate combat segments and encounter attempts. Preserve uncertain boundaries and completion provenance, and allow the player to finish a run explicitly.
- Project readable native damage meter observations after combat. Record the source, timing, identity coverage and confidence needed by later aggregation.
- Provide a localized, read-only capture preview so the first implementation can be verified against a real run.

## Capabilities

### New Capabilities

- `native-dungeon-capture` records a reviewable run from native client events and readable meter observations.

### Modified Capabilities

None. The opted-in diagnostic remains available for investigating client behavior.

## Impact

This is the first production increment of the MVP. The following increments add bounded persistent history and aggregation, native summaries and filters, and the interactive timeline. The MVP is a native addon using real client data. Its acceptance includes an installable build and a real dungeon that can be reviewed after capture. This proposal's implementation can be rolled back by reverting it or disabling the addon; it introduces no new saved schema.

Separate client tests still cover finality, automatic completion and controlled group healing. The production capture preserves unknown and partial observations while these capabilities are evaluated. [Product scope](https://github.com/sebasgrios/dungeons-analytics/blob/961a6377146c6928884cd3f2d3c1dba2d074709e/docs/PRODUCT.md) · [Forever evidence](https://github.com/sebasgrios/dungeons-analytics/blob/d7cb38bef02f63b523334ef820868d3221f4b136/docs/TESTING.md)
