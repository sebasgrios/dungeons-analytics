## ADDED Requirements

### Requirement: Opt-in Forever diagnostics

The addon SHALL record its build and diagnostic state, use English and Spanish messages, and capture bounded local evidence only after explicit opt-in.

#### Scenario: Probe is enabled on Forever

- **WHEN** a player enables the probe from a supported client
- **THEN** the report includes version, build, interface and locale
- **AND** the probe records whether candidate APIs, metric types and events are available
- **AND** capture can be stopped without changing any Blizzard settings

#### Scenario: Clean reload and saved evidence

- **WHEN** a player reloads the UI after an opted-in checkpoint outside combat
- **THEN** the addon reports which bounded records persisted and compares current native session observations
- **AND** it identifies reload separately from a native meter reset

### Requirement: Safe, bounded meter observations

The addon SHALL probe aggregate and per-source readiness using readable values and a bounded sampling policy.

#### Scenario: Accessible and restricted rows

- **WHEN** the probe observes a pull, combat end and the available meter updates
- **THEN** it records readiness and readable-field counts for aggregate and source rows by phase
- **AND** it distinguishes secret, absent, empty, zero and failed observations
- **AND** retained and exported records contain no raw identity or secret values

#### Scenario: Multiple sessions and late or repeated updates

- **WHEN** multiple pulls or repeated updates are observed
- **THEN** the evidence reports candidate session IDs, durations and distinct/repeated observations in an epoch
- **AND** it records changes between checkpoints and indicates whether counts are capped
- **AND** a changed epoch or combat state prevents stale deferred reads

#### Scenario: Native meter reset

- **WHEN** the tester resets the native meter through Blizzard's UI
- **THEN** the probe records delivery of the reset signal and subsequent session catalogue changes, if observed
- **AND** the probe makes no calls that alter Blizzard's meter

### Requirement: Evidence for dungeon and party association

The addon SHALL record entry, exit, roster and encounter signals with their availability and timing.

#### Scenario: Manually entered dungeon

- **WHEN** a party enters manually and fights trash and a boss
- **THEN** the diagnostic records readable instance context, roster joins, encounter boundaries and observed outcome
- **AND** it reports pending or unavailable evidence when completion or player identity cannot be inferred

#### Scenario: Queued completion and healing detail

- **WHEN** a queued dungeon finishes and healing has multiple recipients
- **THEN** the evidence records the order of the LFG signal and meter updates
- **AND** it records recipient-detail shape, coverage and match ambiguity without deriving unsupported healing totals

### Requirement: Verified native UI candidates

The addon SHALL allow an out-of-combat probe of the generic UI component shortlist and record each outcome as available, restricted, missing or failed.

#### Scenario: Native component test

- **WHEN** the tester runs the UI probe outside combat
- **THEN** the output records results for the frame, button, search, tab, dropdown and scroll templates
- **AND** it reports whether the Settings, tooltip, line and pool APIs are present
- **AND** the test uses addon-owned frames and records observed visuals separately from API presence
