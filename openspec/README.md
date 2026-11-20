# OpenSpec

Accepted requirements live in `openspec/specs/<capability>/spec.md`. Proposed deltas live in `openspec/changes/<id>/` and accepted, fully evidenced deltas are archived under `openspec/changes/archive/YYYY-MM-DD-<id>/`. Current implementation status lives in [README](../README.md).

A change ID uses a lowercase type prefix and three-digit type-local sequence. For example, `feat001-forever-diagnostics` uses proposal branch `SPEC/FEAT001-forever-diagnostics` and implementation branch `FEAT/001-forever-diagnostics`. Types are feat, fix, chore, upd and del. Check active, archived and open proposals before allocating a sequence.

A proposal supplies `proposal.md`, `design.md`, `tasks.md`, `sdd-scope.json` and one or more `specs/<capability>/spec.md` deltas. Read [SDD compliance](../docs/SDD_COMPLIANCE.md) for the two-PR flow, immutable scope and archive evidence. Validate using `npx --yes @fission-ai/openspec@1.16.0 validate --all --strict --no-interactive`.
