## Context

The diagnostic showed that clean reloads preserve local observations and native sessions on the tested Forever build. A separate reset emptied the native catalogue. Session IDs were later reused, and several detailed samples had readable group totals without matched party rows. Build on the capture model's identities, epochs, provenance and coverage. [Data model](https://github.com/sebasgrios/dungeons-analytics/blob/961a6377146c6928884cd3f2d3c1dba2d074709e/docs/DATA_MODEL.md) · [Forever capability matrix](https://github.com/sebasgrios/dungeons-analytics/blob/42c60baa032e804fac9439c1916ff4fa7ca6c116/docs/WOW_FOREVER_API.md)

## Decisions

### Saved state and recovery

Use `DungeonsAnalyticsDB` for versioned run records, a persistent run ID sequence, retention settings and at most one active checkpoint. Keep the diagnostic store independent. Commit owned, allowlisted data at meaningful lifecycle and post-combat checkpoints. Ignore elapsed time between sessions unless it was observed. On clean reload or restart, reopen the history and surface an unfinished checkpoint as interrupted. Start a new capture if instance continuity cannot be established. Same-map context or a repeated meter ID supplies no proof of continuity.

Store run, segment and encounter boundaries, actor IDs, roster revisions and the eligible observation with its provenance, timestamp, source and coverage. Retain only the details required to interpret a report. Store neither raw player identifiers nor client-owned objects. Validate input and migrate known older versions idempotently. An unsupported newer store is read-only and its saved bytes remain intact. The client controls when SavedVariables are flushed.

Default to 20 retained runs with a configurable count from one to 30. Apply a fixed serialized-size budget and individual record bounds in addition to that count. Measure the serialized projection conservatively and evict the oldest records deterministically after finalization or a preference change. Report storage truncation or rejected records explicitly. Finalization is idempotent for a run ID. Retention uses the addon run ID and observed chronology independently of native session IDs.

### Query and aggregation

Keep query and aggregation functions pure. Produce a filtered index using available name, difficulty and date metadata, with stable chronological or duration ordering. Allow the player to inspect the list using `/da history` and open an individual run with its displayed reference. Use the existing addon-owned native preview shell for this increment. Require explicit confirmation for deleting a record or clearing history. Localize commands and status messages in enUS and esES.

Use at most one eligible observation per segment, metric, source scope and actor. Prefer a corroborated historical observation when it is eligible. Use a Current sample only when its post-combat boundary and provenance make it eligible. Repeated observations replace an earlier sample for that segment. Prevent the same corroborated historical session from being counted twice within a run and meter epoch. An unresolved or conflicting association remains visible as a coverage gap.

Return observed group totals and per-actor totals independently. An aggregate returned by the game is independent of the sum of visible party rows. Keep known zero, unavailable, provisional and partial results distinct. Include evidence counts for eligible and expected segments. Calculate rates as a compatible sum divided by its positive, observed duration, and shares only with a compatible positive denominator covering the same selected segments. Retain the denominator semantics with every rate. Leave a percentage unavailable if its required values or coverage are missing.

Support whole-run, combat, encounter and time-range queries for later native reports. For a range intersecting only part of an aggregate segment, return the precision limitation and exclude the partial segment from the requested totals. Never infer boss-only damage from an overlapping or mixed pull. Count finished and failed attempts from observed outcomes. Derive observed combat time from the union of compatible intervals and leave downtime unresolved across gaps in run coverage.
