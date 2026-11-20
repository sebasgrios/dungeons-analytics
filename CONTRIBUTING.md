# Contributing

Use English in specs, code, tests, docs and GitHub discussion. Keep player-facing strings in enUS and esES. Begin with [OpenSpec](openspec/README.md) and the [development guide](docs/DEVELOPMENT.md).

Open an issue for bugs or proposals, or fork the repository and submit a PR. By submitting an original contribution for incorporation, you offer it under the [project license](LICENSE) and represent that you have the necessary rights. Preserve [NOTICE](NOTICE) when sharing the project. Follow the [code of conduct](CODE_OF_CONDUCT.md).

1. Read the current requirements, active changes, existing issues and relevant code. Allocate the next free type-local ID.
2. Open a spec-only proposal PR with requirements, scenarios, design, tasks and `sdd-scope.json`. Use Conventional Commits, for example `docs(openspec): propose Forever diagnostics`.
3. Wait for the proposal to be reviewed and merged. Create a fresh implementation branch from current `main`. Preserve the approval artifacts and implement only the accepted scope.
4. Run automated checks and applicable in-game scenarios. Audit doc and archive readiness using [documentation-sync](skills/documentation-sync/SKILL.md). Include check results, evidence, limits and rollback in the PR.
5. Obtain the owner's review for a contributor-authored PR. The project owner decides when it can be merged after the required checks pass.

Tiny docs-only changes can use the documented exemption. [SDD compliance](docs/SDD_COMPLIANCE.md) defines the exact metadata and acceptance process.
