## ADDED Requirements

### Requirement: Bounded and recoverable dungeon history

The addon SHALL save eligible local dungeon records in a bounded, versioned store and let the player reopen them in Forever.

#### Scenario: Reopen prior dungeon runs

- **WHEN** the player finishes actual observed runs and the client flushes SavedVariables
- **THEN** the history displays the saved runs after reload or a clean restart
- **AND** the player can open a selected record with its observed times, outcomes and metric coverage
- **AND** reusing a native meter ID in a later run cannot replace, merge with or duplicate an earlier run

#### Scenario: Interrupted capture or incompatible store

- **WHEN** the addon reopens a persisted checkpoint for an unfinished run
- **THEN** the interrupted record remains reviewable with incomplete coverage and no inferred continuity from matching map or native meter IDs
- **AND** known older schemas migrate idempotently and unsupported newer data remains intact

#### Scenario: Enforce retention or remove test records

- **WHEN** the configured retention count or storage budget is reached
- **THEN** the addon applies bounded, deterministic retention and surfaces coverage lost to record limits
- **AND** it removes requested records only after player confirmation

### Requirement: Coverage-aware totals and interval queries

The addon SHALL compute observed totals, rates, shares, times and encounter counts only from eligible compatible evidence.

#### Scenario: Repeated observations or incomplete actors

- **WHEN** selected segments contain repeated samples, restricted rows or incomplete actor coverage
- **THEN** the result counts each eligible segment observation at most once per metric and scope
- **AND** group and actor coverage are reported independently, with observed zero distinct from unknown
- **AND** a rate or share is unavailable unless its denominator is readable, compatible and positive

#### Scenario: Query only part of an aggregate segment

- **WHEN** a selected time range intersects part of an aggregate segment or includes ambiguous boss overlap
- **THEN** the result identifies the resolution or association limit and excludes unsupported allocations
- **AND** overlap never doubles observed combat time or counts the same amount as both boss and trash
