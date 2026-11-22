# Diagnostic evidence retention

## Purpose

Preserve lifecycle evidence and diagnostic checkpoints during native meter activity while keeping local storage bounded and corroborating historical session selection.

## Requirements

### Requirement: Bounded lifecycle and checkpoint retention

The opted-in diagnostic SHALL preserve retained lifecycle records and explicit samples when background meter notifications fill their share of storage. It SHALL remain within the existing record and byte limits, preserve ordering within each epoch, and continue to read compatible SavedVariables records.

#### Scenario: Interleaved meter activity during a capture

- **WHEN** repeated meter notifications and background samples fill their retention windows during an active diagnostic
- **THEN** the retained evidence still contains the observed capture start, zone and combat transitions, encounters, explicit checkpoints and completion or exit signals that fit within their protected bounds
- **AND** all retained records stay within the existing storage limits and ordering rules

#### Scenario: Existing saved capture

- **WHEN** a compatible SavedVariables table with older retained records is reopened
- **THEN** readable retained records remain available in the local export under the bounded retention rules

### Requirement: Corroborated historical session selection

The opted-in diagnostic SHALL coalesce repeated meter activity and preserve bounded delayed samples. Historical detail SHALL distinguish catalogue-confirmed IDs from notifications without confirmed historical identity.

#### Scenario: Notifications alternate between a listed and unlisted ID

- **WHEN** multiple safe native meter notifications alternate between an ID listed in the readable catalogue and an unlisted ID
- **THEN** the unlisted ID cannot replace the corroborated historical candidate
- **AND** the diagnostic records bounded update timing and preserves its update count

#### Scenario: Catalogue cannot corroborate a session

- **WHEN** the catalogue is inaccessible or missing
- **THEN** historical detail reports its unavailable or restricted state without treating the unknown identity as a verified session or a numeric zero
