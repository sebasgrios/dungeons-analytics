# Repository governance

## Purpose

Establish a spec-first lifecycle and traceable acceptance for Dungeons Analytics.

## Requirements

### Requirement: Reviewed scope before implementation

A functional change SHALL have a separate merged proposal that fixes its requirements, design and implementation scope.

#### Scenario: A new functional capability is proposed

- **WHEN** a contributor proposes a game-facing capability
- **THEN** the proposal uses a typed change ID and a spec-only PR
- **AND** the implementation starts from main after owner approval and merge of that proposal

### Requirement: Evidence-based acceptance

An implementation PR SHALL identify its proposal and report automated checks and relevant Forever client scenarios.

#### Scenario: Client evidence is outstanding

- **WHEN** a required scenario has no real-client result
- **THEN** the change remains active and the scenario remains unchecked
- **AND** the implementation PR explains the specific archive blocker

### Requirement: Controlled integration and distribution

The repository SHALL use PRs for integration after initialization and require owner authorization for merges by agents and external distribution.

#### Scenario: Automated validation succeeds

- **WHEN** the required checks pass on a PR
- **THEN** the PR remains open for the owner to decide whether to merge
