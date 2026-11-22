## 1. Preserve bounded diagnostic evidence

- [x] 1.1 Coalesce recurring and interleaved meter notifications while retaining update counts and delayed observations.
- [x] 1.2 Preserve lifecycle and explicit checkpoints within the current event and sample caps, including after reopening an existing save.
- [x] 1.3 Corroborate chosen historical session IDs with a readable catalogue and retain unavailable or restricted outcomes.
- [x] 1.4 Exercise burst retention, prior saves, session selection and callback invalidation with isolated Lua regressions.

## 2. Verify the diagnostic capture

- [x] 2.1 Run repository validation, OpenSpec traceability, Lua compatibility and Lua regressions.
- [x] 2.2 Capture an actual Forever dungeon with repeated native meter updates. Verify build, combat, instance, encounter and available completion observations after the run from the export or saved table. Record missing evidence separately.
- [x] 2.3 Update the testing and capability documentation, run documentation-sync and evaluate archival readiness using the real-client evidence.

## Verification evidence

GitHub Actions on PR #12 passed repository validation, traceability, Lua compatibility, the isolated Lua regressions and package verification. The regressions exercise protected records when the event and sample windows fill, reopening the previous schema, listed and unlisted candidate IDs, and an unavailable catalogue.

A 2026-11-22 queued Forever capture reported client 1.60.1.71037, Interface 16001 and locale enUS. It used the [verified diagnostic package](https://github.com/sebasgrios/dungeons-analytics/actions/runs/44902591399) from commit `06787d3fbe4eb92e6c422c76bfab2f74eaa20705`. The bounded export contained 200 events and 24 samples in order within each epoch, with individual records within their byte limits. It preserved capture start and stop, instance entry and exit, re-entry, 22 paired combat transitions and two successful encounter pairs under repeated meter notifications. Older lifecycle records and post-combat checkpoints remained in the export. The 21 detailed samples selected historical entries present in the readable catalogue. The catalogue scanner inspected 12 entries and reported a lower bound of 13.

The tester reported dungeon completion, a wipe and re-entry. The registered LFG completion event did not appear in this capture. Current damage still changed at the approximately three-second checkpoint in one fight. Fight-to-history correlation and completion detection remain unverified. Manual entry, clean reload, recovery of this capture via a fresh SavedVariables flush and tester-initiated meter reset remain NOT RUN. The testing protocol and capability matrix record the observed limits.
