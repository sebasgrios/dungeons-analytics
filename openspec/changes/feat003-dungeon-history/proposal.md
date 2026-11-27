## Why

The MVP needs to reopen previous Forever dungeons and calculate results from observations that can be attributed to real fights. In the solo test, session IDs repeated after a meter reset and the two catalogue entries survived a clean reload. The queued run showed that readable group totals and matched player rows have different coverage. History and aggregation need to preserve these distinctions.

## What Changes

- Save captured runs and one recoverable active checkpoint in a bounded, versioned SavedVariables store.
- Offer a localized history index and let players reopen an individual run after reload or restart.
- Calculate observed group and player totals, eligible rates, contribution shares and encounter counts with explicit coverage. Preserve whole-segment resolution for range queries.
- Keep a queryable model for the native summary, filters and interactive timeline.

## Capabilities

### New Capabilities

- `dungeon-history` persists captured runs and provides coverage-aware queries and aggregates.

### Modified Capabilities

None. History consumes the normalized run records from the native capture increment.

## Impact

The implementation depends on the approved native capture contract and its relevant real-client evidence. This increment adds a separate local store. Reverting the implementation disables its history features and leaves the saved data available for a compatible version. Native navigation, summary presentation and the interactive timeline follow in their own increments.

[Native capture proposal](https://github.com/sebasgrios/dungeons-analytics/blob/1d61fda3d746c77dd88f3de4e5771cd1f8101046/openspec/changes/feat002-native-dungeon-capture/design.md) · [Product scope](https://github.com/sebasgrios/dungeons-analytics/blob/961a6377146c6928884cd3f2d3c1dba2d074709e/docs/PRODUCT.md) · [Client evidence](https://github.com/sebasgrios/dungeons-analytics/blob/42c60baa032e804fac9439c1916ff4fa7ca6c116/docs/TESTING.md)
