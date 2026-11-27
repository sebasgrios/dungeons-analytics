## ADDED Requirements

### Requirement: Automatic Forever dungeon capture

The addon SHALL keep a bounded, run-scoped record of observed dungeon context, combat, encounters, roster revisions and completion evidence on supported Forever clients.

#### Scenario: Entry by portal or queue

- **WHEN** the client reports readable entry into a party instance
- **THEN** the addon starts one run with observed instance context and does not duplicate it on repeated entry notifications
- **AND** a confirmed exit followed by a new entry creates a distinct run even if the map is the same
- **AND** observation started inside an instance is labelled partial when entry was missed

#### Scenario: Trash, boss and uncertain completion

- **WHEN** the addon observes separate combat boundaries, encounter events and an exit or an explicit finish
- **THEN** it records the combat intervals, encounter attempts and any readable outcomes
- **AND** it preserves partial attempts and overlap without attributing a mixed pull's whole metric amount to a boss
- **AND** it records completion evidence separately from exit or explicit finish and leaves unsupported completion unknown

### Requirement: Attributed meter observations

The addon SHALL record bounded native meter observations with their source, sample timing, association confidence and identity coverage.

#### Scenario: Separate pulls with corroborated sessions

- **WHEN** post-combat observations provide corroborating evidence for a distinct historical session in the current meter epoch
- **THEN** the addon associates its readable observations with the corresponding combat segment once
- **AND** it keeps Current and historical observations distinct and reports changing or interrupted checkpoints as provisional

#### Scenario: Missing, restricted or ambiguous data

- **WHEN** a required API result or actor identity is unavailable, restricted or ambiguous
- **THEN** the capture preserves the missing coverage and records only safely projected facts
- **AND** it distinguishes observed zero, unknown values and non-attributable rows
- **AND** no raw player GUID, secret value or client-owned table enters the run record or preview

#### Scenario: Roster slot reuse or capture invalidation

- **WHEN** a party slot changes owner, a meter ID is reused after reset, or a later combat or zone change invalidates queued work
- **THEN** earlier observations retain their original actor and epoch
- **AND** stale callbacks and unsupported joins cannot attach data to a different fight or player

### Requirement: In-game capture review

The addon SHALL expose a bounded native preview of the active or latest finished capture in English and Spanish while keeping the diagnostic available.

#### Scenario: Review an observed dungeon

- **WHEN** the player opens `/da capture` outside combat after fighting in a dungeon
- **THEN** the preview shows the observed run and segment timings, encounter outcomes and eligible per-player observations with coverage
- **AND** an empty or partial capture is identifiable, and the player can finish the capture without changing the native meter
