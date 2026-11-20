# CraftAtlas methodology audit

Audit date 2026-11-20. Reference `hectoresen/CraftAtlas` main at `7d95a3f`. The local checkout at `116a282` contains separate working changes. The audit used it for historical context and used the published main and PRs for current policy.

| Topic | Observed practice | Adaptation |
| --- | --- | --- |
| Code and docs | `addon/<name>/` uses Core, Domain, Infrastructure, Features and Localization. Root maintainer docs complement technical docs and test evidence. | Same ownership boundaries. No recipe catalog, generator or CraftAtlas code. |
| SDD lifecycle | `spec-driven` OpenSpec, separate proposal and implementation, owner approval, scope allowlists, canonical sync, dated archive and explicit blockers. | Same phases and types. Dungeons Analytics owner is `sebasgrios`. |
| Branches and commits | Typed uppercase branch prefixes, lowercase spec IDs, Conventional Commits. History retains older conventions. | Apply the current rules to new work. GitHub PR merges preserve reviewed history. |
| Review and checks | Separate review ruleset and mandatory CI ruleset. Independent review for contributors with evidence retained in GitHub. | Apply technical protection for the public repository and retain the owner review decision. |
| CI and quality | Lean proposal/docs checks, distinct Lua compatibility and regression jobs, documentation review evidence and separate in-game verification. | Keep the same four check contexts. Use Node's built-in test runner for repository checks and isolated Lua for game logic. |
| Releases | Owner-triggered native addon ZIP and release readiness checks. | Use the approved noncommercial license and leave add-on package publication as a separate owner decision. |

Published examples show the native explorer proposal and implementation pair ([#70](https://github.com/hectoresen/CraftAtlas/pull/70), [#71](https://github.com/hectoresen/CraftAtlas/pull/71)); the update to owner approval semantics ([#58](https://github.com/hectoresen/CraftAtlas/pull/58), [#59](https://github.com/hectoresen/CraftAtlas/pull/59)); and an open docs-only contributor PR still awaiting review ([#72](https://github.com/hectoresen/CraftAtlas/pull/72)). The earlier [typed ID correction](https://github.com/hectoresen/CraftAtlas/pull/49) explains why directory and branch IDs differ in case. Settings audit details and outstanding upstream enforcement are recorded in [CraftAtlas GitHub settings](https://github.com/hectoresen/CraftAtlas/blob/7d95a3f/docs/GITHUB_SETTINGS.md). The product-specific maintenance freeze has no bearing on the new project.
