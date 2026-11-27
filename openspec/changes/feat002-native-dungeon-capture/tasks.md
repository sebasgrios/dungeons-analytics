## 1. Capture lifecycle

- [ ] 1.1 Wire a production consumer to the existing event frame and preserve diagnostic command behavior.
- [ ] 1.2 Implement testable dungeon entry, partial start, exit, repeat entry and explicit finish transitions.
- [ ] 1.3 Track combat intervals, encounter attempts and roster revisions with coverage and bounded storage.

## 2. Native observations and review

- [ ] 2.1 Project readable native meter data and qualify Current and historical observations by provenance and identity coverage.
- [ ] 2.2 Exercise late updates, repeated IDs, limited catalogues, roster replacement, secret fields and invalidated callbacks in Lua fixtures.
- [ ] 2.3 Add the localized `/da capture` preview and `/da finish` action with combat-safe behavior.
- [ ] 2.4 Update README, architecture, data model, testing and changelog for the shipped behavior.

## 3. Verification

- [ ] 3.1 Run repository, OpenSpec, Lua 5.1 and installable package checks against the implementation commit.
- [ ] 3.2 Verify the installable capture build on Forever with a real dungeon entered at its portal. Capture two distinct pulls, a boss attempt, the roster and the exit or explicit finish. Compare the exported capture with the observed game sequence.
- [ ] 3.3 Verify a queued dungeon on Forever. Observe readable group statistics and any completion signal. Record how an absent or ambiguous signal appears in the preview and verify the explicit finish path.
- [ ] 3.4 Run documentation-sync, review the four PR check contexts and record archive readiness.

Implementation and its live client scenarios are `NOT RUN`. Existing diagnostic observations inform this proposal's requirements.
