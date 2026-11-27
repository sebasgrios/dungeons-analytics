## Context

The existing event frame, safe-value boundary and native meter adapter provide the client wiring. Production capture needs its own run state and must avoid treating the diagnostic's catalogue fallback as a verified fight association. The first increment feeds later history and UI changes through a bounded run record. [Architecture](https://github.com/sebasgrios/dungeons-analytics/blob/961a6377146c6928884cd3f2d3c1dba2d074709e/docs/ARCHITECTURE.md) · [Capability matrix](https://github.com/sebasgrios/dungeons-analytics/blob/d7cb38bef02f63b523334ef820868d3221f4b136/docs/WOW_FOREVER_API.md)

## Decisions

### Lifecycle and actors

Register events once through the existing frame and give capture and diagnostics independent consumers. Keep the domain independent of WoW APIs. Use a readable party-instance observation to open a run. Coalesce redundant zone events for an observed entry, and allocate a new run ID after a confirmed exit and subsequent entry, even for the same map. Initialize a partial record if the client starts observing from inside a dungeon. Record readable map and difficulty as separate fields so a transient difficulty value can be revised without opening another run.

Keep a monotonic event clock within each run. Record combat start and end, encounter starts and outcomes, and the intervals between observed fights. Attach an encounter reference only where the observed intervals support it. Record overlap without assigning an entire mixed pull's amounts to the boss. Keep an interrupted boss attempt or run partial when a closing boundary is missing. Support explicit finish from `/da finish`. Record a readable completion event as evidence and classify completion only when it can be associated to the active run. An exit or any individual boss victory alone gives an unknown completion status.

Use run-local actor IDs and bounded roster revisions. Resolve source rows through a safely readable GUID against the roster observed for that segment. An unambiguous local-player flag may resolve the local actor. Keep names and GUIDs at the adapter boundary as transient data. Do not use class, name, or a reused party slot as an identity key. Emit class, role or anonymous slot information only when supported by the associated revision.

### Meter observations

Reuse the safe adapter boundary. Project available native DamageDone, HealingDone, DamageTaken, Interrupts, Dispels and Deaths observations as their original categories. Read outside combat after relevant lifecycle events and record eligibility, provenance, amount, optional duration, roster revision and coverage. Do not derive healing received, a combined healing and absorb total, or a time series within a pull. A native rate and a calculated rate need a separate denominator decision in the aggregation increment.

Use a bounded set of delayed checkpoints after combat ends. Associate a historical ID only with corroborating same-epoch evidence, such as one newly observed, unclaimed ID in comparable catalogue reads surrounding the pull. A limited catalogue view, conflicting observations, a reused ID across a reset, or an ambiguous overlap leaves association uncertain unless independent readable evidence resolves it. Keep a clearly labelled Current observation tied to its post-combat window when corroboration fails. Keep historical and Current observations separate so later aggregation cannot count the same combat twice. Mark the observation provisional when values still change or a checkpoint was interrupted. No fixed delay guarantees final data.

Each deferred checkpoint carries a run ID, segment ID and invalidation generation. A newer combat, zone boundary, reset, finish or logout stops stale work. Coalesce repeated meter updates and allow at most four scheduled post-combat checkpoints per segment. Retain at most one active run and one latest finished run, with at most 200 combat segments, 40 encounter attempts and 40 roster revisions per run. Mark coverage as limited if a bound prevents capture. Unavailable data keeps a reason, and observed zero remains numeric.

### Preview and later increments

Use the existing addon-owned native report shell for a read-only, copyable `/da capture` view outside combat. Show active or latest finished capture, instance, completion evidence, combat and encounter timing, actor aliases and observed metric coverage. Keep the preview bounded and include an explicit partial state. Preserve the current diagnostic commands and opt-in behavior. The later history increment persists eligible run records and performs verified aggregation. The native summary and timeline increments consume that history without requiring an external parser or service.
