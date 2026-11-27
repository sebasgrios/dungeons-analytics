## ADDED Requirements

### Requirement: Native report and navigation

The addon SHALL provide a localized, addon-owned native report for current and historical Forever runs.

#### Scenario: Open a real saved dungeon

- **WHEN** the player opens the latest run or selects a saved dungeon in history
- **THEN** the report presents the observed dungeon, times, player and group statistics, coverage and encounter outcomes
- **AND** the player can inspect the summary, encounters, players and timeline for that run
- **AND** history filters and sorting respect unknown values and incompatible coverage

#### Scenario: Show the window in a supported client

- **WHEN** the player opens or closes the report in a supported locale and UI scale
- **THEN** available native controls, fonts and patterns remain usable with pointer and keyboard
- **AND** empty, incomplete or unavailable runs remain understandable
- **AND** automatic opening follows the player's preference and combat-safe timing

### Requirement: Interactive timeline at observed resolution

The addon SHALL visualize selected metrics and scopes using observed run time and the recorded segment precision.

#### Scenario: Explore player and encounter data

- **WHEN** the player changes a metric, scope, viewport, actor toggle or selected encounter
- **THEN** the timeline and related details update from the selected run and eligible results
- **AND** actor labels, encounter markers, tooltips and supported death markers explain the displayed evidence
- **AND** repeated interaction reuses bounded graph primitives

#### Scenario: Examine a partial range or missing player data

- **WHEN** a selected range cuts through a pull or an observation cannot be attributed
- **THEN** the chart identifies the resolution or coverage limitation and retains the original time bounds
- **AND** the summary and chart exclude unsupported allocations and leave gaps for unknown data
- **AND** an observed zero remains distinct from a missing observation
