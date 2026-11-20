# Preliminary data model

| Record | Proposed facts |
| --- | --- |
| Dungeon run | Addon-generated run ID, map or instance type ID, difficulty, wall clock anchor, elapsed bounds, completion evidence, observation coverage and roster revisions. |
| Encounter attempt | Encounter ID, observed start/end, relative timestamps, outcome and correlation confidence. |
| Combat segment | Observed bounds, meter generation and candidate session ID, provenance, metric snapshots, class and link to an encounter when supported. |
| Metric observation | Stable metric identifier, source, unit, precision, observation state, value and time denominator when supported. |
| History | Schema version, migration step, retention preferences and completed or recoverable incomplete runs. |

Session IDs require a namespace derived from observed client behavior before reuse across resets or reloads. A map ID alone does not identify a particular run. A roster change creates a new revision. Preserve missing identity with an explicit unknown rather than merging rows by a possibly ambiguous name.

Add disjoint, compatible totals. When the same measurement and coverage definitions apply, aggregate rates as observed numerator divided by eligible seconds. Keep unavailable counts distinct from observed zero or an empty snapshot. For intervals that cut across an aggregate segment, report the resolution limit and avoid proportional allocation. A combined boss-and-trash pull can remain mixed.

Persist only readable primitives projected from explicitly supported fields. Future migrations should be idempotent and keep unsupported newer schema versions intact. Abrupt process termination can lose data since the last client SavedVariables flush.

## Diagnostic schema 1

`DungeonsAnalyticsDiagnosticsDB` retains up to 200 event lines, 24 aggregate sample lines and 12 normalized native session IDs from the previous readable catalogue. An epoch advances at opt-in, clean reload of an opted-in capture and a native meter reset. Every line reports its sequence and elapsed time within that epoch. Comparing the previous catalogue with a new one reports repeats and duplicate IDs without asserting that IDs identify the same fight across epochs.

Sample records keep at most 12 session entries and 12 unit rows per metric. The historical healing probe reads at most five source details, 24 spell rows per source and 10 target rows per list. Truncated samples or oversized records report their limit. Aliases such as `party1` describe a slot at the time of one sample. Unsupported SavedVariables versions remain intact and the capture is disabled until a compatible format is available.
