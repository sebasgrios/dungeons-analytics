# Dungeons Analytics agent instructions

Read [README.md](README.md), [CONTRIBUTING.md](CONTRIBUTING.md), [OpenSpec](openspec/README.md), [SDD compliance](docs/SDD_COMPLIANCE.md), [architecture](docs/ARCHITECTURE.md), [API evidence](docs/WOW_FOREVER_API.md) and [testing](docs/TESTING.md). Inspect the current base, open changes and in-scope code before editing. Keep code, project docs, specs, tests and PRs in English. Localize addon-facing text to enUS and esES.

Follow the two-PR OpenSpec workflow for functionality, schema, compatibility and substantial refactors. Check ID collisions and use the documented typed branches. Wait for the reviewed, merged proposal before implementing. Preserve its approved artifacts and restrict implementation to its path allowlist. Run [documentation-sync](skills/documentation-sync/SKILL.md), verify acceptance and audit the latest PR head checks before handoff. Track incomplete in-game evidence in tasks and testing documentation.

Use the Forever-specific evidence for Lua, events, API and native UI. Keep the native API behind adapters and domain calculations testable offline. Treat inaccessible, missing and ambiguous observations as distinct from zero. Discard secret values before processing, formatting or storage. Capture only on relevant events and use bounded work and storage. Keep Blizzard's meter and unrelated game state untouched.

Use PRs for changes to main. The owner controls approval, merge decisions, rulesets, access and releases. Leave unexecuted client scenarios marked `NOT RUN`. Use the development guide for quality commands and the security policy for private reports.
