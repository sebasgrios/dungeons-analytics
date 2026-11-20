# GitHub settings

Keep `sebasgrios/dungeons-analytics` public with `main` as the default branch. Enable issues and fork-based contributions. Use merge commits to preserve reviewed history and keep automatic merging disabled. Keep the owner as code owner. Retain GitHub's `bug` and `enhancement` labels for the issue forms.

Target `main` with two active rulesets:

1. Require a PR, independent code-owner approval, dismissal of stale approvals and resolved conversations. The repository administrator has a PR-only review bypass for owner-authored work because GitHub rejects self-approval.
2. Disallow deletion and force updates and require the four CI contexts listed in [SDD compliance](SDD_COMPLIANCE.md). Use strict updates and an empty bypass list. Select contexts only after their names are emitted on a real PR. Require updates through PRs.

Keep the Actions default token read-only and grant individual jobs only necessary read scopes. Keep private vulnerability reporting enabled where supported. The owner controls access, settings and publishing. An enforcement claim requires verification in GitHub Settings. The documented policy and local validation still apply when hosting plan features are unavailable.

Verify policy using an owner-authored PR, an independently approved contributor PR and a failed-check scenario before claiming two-account end-to-end enforcement.
