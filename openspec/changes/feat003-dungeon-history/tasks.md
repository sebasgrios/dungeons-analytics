## 1. Versioned local history

- [ ] 1.1 Verify the merged native capture contract and review its relevant Forever evidence before implementing.
- [ ] 1.2 Add a versioned SavedVariables store with deterministic retention, idempotent finalization and an interrupted-checkpoint path.
- [ ] 1.3 Verify preserved newer stores, bounded malformed input, known migration fixtures and recovery at reload boundaries.
- [ ] 1.4 Provide a localized native history index, individual run reopening, retention controls and confirmed deletion.

## 2. Evidence-aware queries

- [ ] 2.1 Expose pure history queries and coverage-aware group, player, timing and encounter results.
- [ ] 2.2 Verify missing and zero observations, overlapping ranges, duplicate samples, reset ID reuse, actor changes and incompatible denominators in Lua fixtures.
- [ ] 2.3 Document the history controls, SavedVariables schema, metric semantics and acceptance gaps.

## 3. Verification

- [ ] 3.1 Run repository, OpenSpec, Lua 5.1 and package checks.
- [ ] 3.2 Install the exact package in Forever and capture two real dungeon runs. Reopen both after reload and after a clean restart. Compare saved run identity, selected pull readings, group and actor coverage, and reported totals against the capture evidence.
- [ ] 3.3 Verify interrupted-run recovery and one native meter reset between runs. Confirm that repeated native IDs do not alter the earlier run or cause duplicate sums. Exercise retention and confirmed deletion against disposable test records.
- [ ] 3.4 Run documentation-sync, review the four PR checks and record archive readiness.

The native capture proposal and its relevant acceptance are prerequisites. The history implementation and its client scenarios are `NOT RUN`.
