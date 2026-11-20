## Context

See the [pinned API research](../../../docs/WOW_FOREVER_API.md), [native component catalog](../../../docs/NATIVE_UI.md) and [real-client test matrix](../../../docs/TESTING.md). The local executable reports 1.60.1.70959. Record the actual runtime build, flavor, locale and interface version with every run of the probe.

## Goals and Non-Goals

Diagnose readability, stability and coverage locally. Allow the accepted diagnostic to evolve independently of future features. Product tracking, renderers, live game aids, raw combat payloads and external file parsing are outside scope.

## Decisions

### Capture and commands

Expose help and state through `/da diag`. Use `start`, `stop`, `snapshot`, `ui` and `export` subcommands. Resume only a previously opted-in capture after a successful reload and report that boundary. Keep the probe independent of window visibility. Record whether candidate events registered as well as the sanitized observations delivered.

Capture `GetAvailableCombatSessions`, per-type and per-ID readings and the public durations with separate result statuses. Use a lightweight bounded observation at combat start to establish accessible shapes and counts. Project source details only outside combat. Sample combat-end, relevant meter update and a small bounded list of delayed checkpoints when out of combat. Cancel, coalesce or skip stale work on reset, zone transition or renewed combat. Record session IDs and changes in an observation epoch with explicit evidence of repeated observations, resets and reloads.

### Privacy and restrictions

The adapter tests value and table accessibility before type-based handling and nested indexing. Project allowlisted primitives eagerly and drop inaccessible wrappers. Record counts of readable, nil, wrong-shaped and restricted values. Distinguish an empty result and observed zero from unavailable data. Join readable player identities transiently for counters and snapshot-local aliases. Raw names, GUIDs, raw errors and original client payloads never enter persisted or exported records. Keep the diagnostic read-only with respect to Blizzard's meter and the combat log.

For healing details compare readable recipient keys and sums to their source amounts. Record whether the returned shape is one detail or a list where observable, as well as missing and ambiguous data. Avoid implying complete healing-received totals because a recipient label or spell amount was readable.

### Bounds and persistence

Use a versioned SavedVariables table with at most 200 recent event records and 24 aggregate probe samples. Cap historical sessions, row projections and spell detail work per sample. Report truncation and a lower bound whenever work reaches a cap. Use event sequence and local monotonic time per observation epoch. For a clean reload, compare persisted probe records with the new native session catalogue. Treat data lost before a client flush as unavailable.

### Native components

Probe generic frame, inset, button, search, tab, dropdown and scroll templates with the proper frame types outside combat. Observe public Settings, tooltip, line and pool APIs. A small addon-owned frame may demonstrate a native label or line. Avoid internal Blizzard panel mixins and protected interactions.

## Risks and Trade-offs

Secret restrictions can vary with context and final data can arrive later than combat-end. An empirical lower bound is sufficient when the exact retention cap cannot be observed. The plan records this precision and avoids polling. A verified event and a confirmed instance association are separate observations. Availability of the dungeon finder or a practical wipe test depends on the active realm.

## Rollout

First run local tests and structural checks. Install only this addon, then follow the manual plan. Capture baseline, at least two trash pulls, a boss attempt, healing, completion, exit and clean reload. Repeat using the dungeon finder when feasible. Record restrictions, failures and unavailable tests in the capability matrix and the relevant task. Release packaging and real UI design are later reviewed changes.
