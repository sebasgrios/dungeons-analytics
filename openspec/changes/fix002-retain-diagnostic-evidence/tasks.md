## 1. Preserve bounded diagnostic evidence

- [x] 1.1 Coalesce recurring and interleaved meter notifications while retaining update counts and delayed observations.
- [x] 1.2 Preserve lifecycle and explicit checkpoints within the current event and sample caps, including after reopening an existing save.
- [x] 1.3 Corroborate chosen historical session IDs with a readable catalogue and retain unavailable or restricted outcomes.
- [x] 1.4 Exercise burst retention, prior saves, session selection and callback invalidation with isolated Lua regressions.

## 2. Verify the diagnostic capture

- [x] 2.1 Run repository validation, OpenSpec traceability, Lua compatibility and Lua regressions.
- [ ] 2.2 Capture an actual Forever dungeon with repeated native meter updates. Verify build, combat, instance, encounter and available completion observations after the run from the export or saved table. Record missing evidence separately.
- [ ] 2.3 Update the testing and capability documentation, run documentation-sync and evaluate archival readiness using the real-client evidence.

## Verification evidence

GitHub Actions on PR #12 passed repository validation, traceability, Lua compatibility, the isolated Lua regressions and package verification. The regressions exercise protected records when the event and sample windows fill, reopening the previous schema, listed and unlisted candidate IDs, and an unavailable catalogue. The revised in-game capture remains NOT RUN, so archive readiness is pending.
