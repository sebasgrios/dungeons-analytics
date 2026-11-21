# Archival reference validation

## Purpose

Validate the intended repository links in immutable dated OpenSpec archives.

## Requirements

### Requirement: Validate legacy archive references from their original location

The repository validator SHALL accept a valid legacy link from a dated OpenSpec archive to a file outside the original change when the target can be verified in the repository using the original active artifact location.

#### Scenario: An archived design points to existing repository documentation

- **WHEN** the design contains an approved relative reference valid at its original active location
- **THEN** the validator accepts the intended repository target
- **AND** the archived design bytes are preserved

### Requirement: Keep strict checks for missing or misplaced targets

The repository validator SHALL verify ordinary and archive-internal links at their actual location and SHALL reject an unresolved legacy reference.

#### Scenario: An archive points to a missing sibling

- **WHEN** a relative link refers to a missing artifact inside the archived change
- **THEN** validation fails even if an equivalent active path exists

#### Scenario: The legacy reference cannot be resolved in the repository

- **WHEN** a legacy target is missing or would resolve outside the repository
- **THEN** validation reports a broken link
