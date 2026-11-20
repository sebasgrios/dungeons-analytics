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

Offline verification covers syntax, formatting, lint and all four Lua 5.1 suites. Archive remains blocked by
real-client testing of build and native visuals, a manual and queued dungeon, recipient coverage, clean
reload and reset. The procedural evidence matrix is in `docs/TESTING.md`.
