# Diagnostic report export

## Purpose

Provide a copyable native diagnostic report in Forever while preserving local evidence if the window is unavailable.

## Requirements

### Requirement: Sized native report editor

The diagnostic SHALL construct its native scrolling editor with explicit valid dimensions before the inherited template initializer runs.

#### Scenario: An opted-in tester opens the report

- **WHEN** the tester runs the export command outside combat
- **THEN** the diagnostic constructs the scroll frame with a width greater than the template's internal horizontal inset and a positive height
- **AND** the report text can be selected and copied

### Requirement: Predictable report focus and fallback

The diagnostic SHALL release report focus on close and retain its local records when the report panel is unavailable.

#### Scenario: The tester closes and reopens the report

- **WHEN** the tester closes the report via Escape or the native close button and opens it again
- **THEN** the hidden editor releases focus and the reopened panel shows the current local report

#### Scenario: The native scroll template cannot be opened

- **WHEN** the client cannot construct the report panel
- **THEN** the diagnostic reports that export is unavailable and preserves the captured SavedVariables
