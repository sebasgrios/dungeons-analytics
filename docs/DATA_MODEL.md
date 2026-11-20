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
