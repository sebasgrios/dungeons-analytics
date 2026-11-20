# SDD compliance

## Proposals

Use branch `SPEC/TYPEnnn-slug` and a lowercase `typennn-slug` ID. The base must be `main`. The PR changes only its new `openspec/changes/<id>/` artifacts and declares:

```text
OpenSpec-Change: feat001-example
OpenSpec-Phase: proposal
```

A contributor-authored proposal requires the owner's actual GitHub APPROVED review before merge. The owner cannot review their own PR and must make the merge decision using the review-only admin route where configured. Required CI applies in either case.

## Implementation

Start from current main after the proposal is merged. Use `TYPE/nnn-slug`. The proposal artifacts and scope on base are immutable, except for evidenced task progress. Declare:

```text
OpenSpec-Change: feat001-example
OpenSpec-Phase: implementation
OpenSpec-Approval-PR: 1
OpenSpec-Archive: blocked
OpenSpec-Archive-Evidence: The manual dungeon run identified in docs/TESTING.md is pending.
Documentation-Review: updated
Documentation-Evidence: README.md documents the commands and docs/TESTING.md records offline coverage and outstanding client evidence.
```

Use the actual merged proposal number. The traceability check verifies proposal provenance, branch metadata and changed paths. Use `Documentation-Review: not-applicable` only with precise no-impact evidence.

Once mandatory scenarios pass, use `OpenSpec-Archive: prepared` and explain the tests, in-game evidence and exact sync. In the implementation PR synchronize approved deltas into canonical specs, preserve proposal, design, scope and delta files byte-for-byte in the dated archive, and remove their active copies. If any required check is unresolved, use `blocked`, keep the change active and identify exact gaps.

Pure documentation upkeep may use `OpenSpec-Exemption: docs-only` if it changes ordinary documentation only and introduces no requirements or behavior. Governance, workflow changes, licenses and product requirements require an approved proposal. The original bootstrap commit establishes the base of this policy.

## Checks

Inspect the latest PR head for `repository-validation`, `traceability`, `lua-compatibility` and `lua-regressions`. A GitHub conclusion of skipped is valid for the Lua checks on proposals; an absent status requires investigation. If a required context is absent, make one metadata-preserving PR body edit, then query the current head again. Report the actual results and keep owner review separate.
