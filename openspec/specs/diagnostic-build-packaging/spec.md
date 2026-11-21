# Diagnostic build packaging

## Purpose

Deliver reproducible, installable Forever diagnostic packages with verifiable source and attribution.

## Requirements

### Requirement: Reproducible installable diagnostic package

The packaging tool SHALL build a byte-reproducible diagnostic ZIP for one Git commit containing exactly one DungeonsAnalytics addon directory with its TOC, declared Lua and XML files, LICENSE and NOTICE.

#### Scenario: A tester obtains a checked build

- **WHEN** the package tool processes a valid commit twice
- **THEN** both archives have the same SHA-256 digest
- **AND** extracting the archive exposes DungeonsAnalytics/DungeonsAnalytics.toc and all its declared files from the selected commit
- **AND** the creator attribution and license are present

#### Scenario: The input files cannot form a valid archive

- **WHEN** the declared file paths are invalid, duplicate or missing
- **THEN** the packager fails before making an artifact available for download

### Requirement: On-demand Actions artifact

The GitHub Actions workflow SHALL publish the validated diagnostic ZIP as a temporary Actions artifact from a manually dispatched main build, with its source commit and digest recorded in the run.

#### Scenario: An owner starts the main workflow

- **WHEN** the workflow is dispatched on main and verification passes
- **THEN** the job uploads the exact installable ZIP and records its source commit, manifest version and digest
- **AND** the workflow creates no Git tags or releases

#### Scenario: The package check fails

- **WHEN** package verification fails or the workflow is dispatched for another branch
- **THEN** the workflow provides no installable ZIP artifact
