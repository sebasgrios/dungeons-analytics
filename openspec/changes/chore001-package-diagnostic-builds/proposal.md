## Why

The diagnostic is now on main and has client acceptance pending. The source ZIP requires the tester to locate and copy a nested directory. A versioned installable ZIP built by GitHub Actions will give testers a reproducible payload and let them report the exact source commit.

## What Changes

- Add a deterministic packager for committed Forever diagnostic files. Include the project's LICENSE and NOTICE.
- Add an on-demand GitHub Actions workflow for main that checks the package and uploads one installable ZIP as a temporary Actions artifact.
- Document the exact build identity, download and install steps, and the distinction between package validation and client acceptance.

## Capabilities

### New Capabilities

- diagnostic-build-packaging defines the verified diagnostic archive and its Actions delivery.

### Modified Capabilities

None.

## Impact

The packager, package tests, development and release documentation, and an isolated workflow are in scope. This change supplies diagnostic evidence builds. Production release publication, tags, version changes, CurseForge and Wago publication remain separate owner decisions. Remove the workflow and packager by reverting their implementation PR if needed.
