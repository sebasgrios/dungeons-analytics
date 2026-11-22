## 1. Diagnostic foundation

- [x] 1.1 Add the Forever TOC, localized slash commands and opt-in lifecycle.
- [x] 1.2 Implement a bounded, versioned diagnostic record and a redacted export.
- [x] 1.3 Guard the value and table boundary and test readable zero, nil, secret and missing predicates.

## 2. Probes and offline verification

- [x] 2.1 Probe the available meter types and session/field shapes with bounded scheduling.
- [x] 2.2 Add instance, roster, encounter, queued completion, reload and passive reset observations.
- [x] 2.3 Add healing-recipient and native component observations.
- [x] 2.4 Run syntax, lint, format, regression and packaging-layout checks for the diagnostic's TOC.
- [x] 2.5 Update README, installation, technical documentation, testing and changelog for actual behavior.

## 3. Real Forever acceptance

- [ ] 3.1 Record the runtime build, TOC, native component results and Lua/taint observations.
- [ ] 3.2 Record a manual dungeon with trash, bosses, completion signals, healing and party identity coverage.
- [ ] 3.3 Record the queued completion variant and any observed late statistics or wipe.
- [ ] 3.4 Verify clean reload, retained sessions and a tester-initiated native reset outside a needed run.
- [ ] 3.5 Update the capability matrix with measured bounds, failures and outstanding evidence.
- [x] 3.6 Run documentation-sync and record archive readiness.

## Verification evidence

Offline verification covers syntax, formatting, lint and all four Lua 5.1 suites.

- **3.1** The native probe and export panel passed on 2026-11-21. The later queued capture confirmed Forever `1.60.1.71037`, Interface `16001` and locale `enUS`. Lua error and blocked-action observations still need to be recorded. [Native panel acceptance](../archive/2026-11-21-fix001-native-diagnostic-export/tasks.md)
- **3.2** Manual entry, same-class identity disambiguation and controlled healing coverage remain `NOT RUN`. The queued samples recorded readable recipient amounts without party-slot matches.
- **3.3** The 2026-11-22 queued run retained 22 combat pairs and two successful encounter pairs. The tester confirmed eventual completion and reported a wipe. Current damage changed at the approximately three-second checkpoint in one fight. `LFG_COMPLETION_REWARD` registered successfully, and no delivery appeared in the export. Its ordering relative to meter updates remains unverified. [Queued capture evidence](../archive/2026-11-22-fix002-retain-diagnostic-evidence/tasks.md)
- **3.4** The export confirmed bounded retention under meter activity. Clean reload, recovery of the queued run from a fresh SavedVariables flush and tester-initiated meter reset remain `NOT RUN`.
- **3.5** The capability matrix records the queued observations, including a catalogue lower bound of 13. It needs the results of the remaining acceptance checks before archival. [Capability matrix](../../../docs/WOW_FOREVER_API.md)

The change remains active. Follow the [Forever test plan](../../../docs/TESTING.md) for manual entry, reload, reset and the remaining coverage checks.
