## Why

The MVP needs a native report that explains what happened across a real Forever dungeon. Existing exports show that a pull can have several observed checkpoints, a duration can change, and player coverage varies by metric. The report needs an interactive timeline with the actual resolution of those observations.

## What Changes

- Open a localized native window for the latest or a saved dungeon, with views for summary, timeline, encounters, players and history.
- Show supported metrics and known coverage, combat and downtime, encounter outcomes and drilldowns for players and pulls.
- Add a pooled timeline with metric and interval filters, player toggles, tooltips, encounter markers, zoom, pan and range selection.
- Persist report preferences and let users opt in to opening the report after a run.

## Capabilities

### New Capabilities

- `native-run-report` presents recorded Forever runs through a native summary and interactive timeline.

### Modified Capabilities

None. The report consumes the capture and history contracts.

## Impact

Implementation follows the accepted capture and history increments and reviews their relevant live evidence. The MVP is ready when an installable build can capture a real Forever dungeon, reopen the result from history and show its summary, filters and timeline with explainable coverage. Advanced comparisons and public distribution are separate increments. Reverting this change removes the report window while retaining capture and saved runs.

[Product scope](https://github.com/sebasgrios/dungeons-analytics/blob/961a6377146c6928884cd3f2d3c1dba2d074709e/docs/PRODUCT.md) · [History proposal](https://github.com/sebasgrios/dungeons-analytics/blob/f96b47b5dfd9244827d29307ae60dd25f690f982/openspec/changes/feat003-dungeon-history/design.md) · [Client evidence](https://github.com/sebasgrios/dungeons-analytics/blob/42c60baa032e804fac9439c1916ff4fa7ca6c116/docs/TESTING.md)
