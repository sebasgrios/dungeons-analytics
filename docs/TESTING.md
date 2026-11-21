# Testing and evidence

Report static source analysis, offline tests, GitHub check runs and Forever client execution independently. The installed executable identified build `1.60.1.70959` on 2026-11-20. Native report export passed in Forever. The remaining scenarios need their own in-game acceptance evidence.

## Offline

Run the isolated Lua 5.1 suites in `tests/test_*.lua` from the repository root. They exercise secret and restricted mock values, valid zero, restricted in-combat data, ambiguous healing targets, bounded retention, event ordering, cancellation after a reset, reload and TOC loading. The mocked native probe covers command wiring and missing templates. Client construction and rendering need the acceptance below.

## In-game

1. Install and enable the addon. Use `/da diag` for help and `/da diag start` before entering a dungeon.
2. Use `/da diag ui` outside combat. Record the exact UI outcome and inspect at normal and compact scale. Use `/da diag snapshot` before and after the run when useful. Let the delayed samples run for at least three seconds after the final fight.
3. To test persistence, leave capture active and use `/reload` outside combat. Check the `RELOAD` line and persisted counts in the export. A clean new login requires opting in again.
4. Use `/da diag stop` and `/da diag export`. Save the diagnostic text locally and review it before sharing. After a clean client flush, the addon's account SavedVariables file is `DungeonsAnalyticsDiagnosticsDB.lua`.

| Scenario | Procedure | Evidence |
| --- | --- | --- |
| Build and native UI | Record `GetBuildInfo()` and realm type. Outside combat, run the allowlisted widget probes and inspect a native test frame at normal and compact scale. | Build, Interface, component outcomes, rendered screenshot, Lua errors. |
| Native report export | Outside combat, run `/da diag export` and copy the header and the last record. Close by Escape and the native close button, then reopen after a new sample at compact UI scale. | Complete copy, released editor focus, current report contents and any Lua errors. |
| Manual dungeon | Enable capture outside the entrance. Enter manually, fight at least two trash packs, attempt a boss and clear the dungeon. Leave and compare event ordering. | Map and difficulty availability, session IDs, encounter pairing, final-boss and zone transitions. |
| Queued dungeon | Repeat via the dungeon finder if available. Record whether the completion event follows the last fight and whether a later meter notification changes totals. | LFG and meter event order with elapsed timestamps. |
| Combat access and identity | Compare an aggregate snapshot when safe at pull, combat end, session update and a later bounded sample. Include two players of the same class and mixed combat roles. | Availability counts for source GUID, display name, class, death and amount fields. Record join counts and ambiguity. |
| Healing and segments | Use a healer with self-heals and at least two distinct group targets. Collect source detail shapes and readable coverage. Include boss combat with adds. | Whether recipient amounts reconstruct full healing, whether recipient identity is unambiguous, session granularity and attribution limits. |
| Reload, retention and reset | Preserve a local checkpoint, `/reload` outside combat, compare recorder state and the native session list. Observe reset only when the tester chooses to use Blizzard's UI outside a needed run. | SavedVariables after flush, historical session count, reused IDs, reset order, cap measured or lower bound. |
| Interrupted run | Observe late entry, party replacement, leaving before the final boss and clean logout where feasible. | Coverage gaps and roster event evidence. Keep inaccessible fields distinct from empty lists. |

On 2026-11-21 the owner opened the native probe and report, copied the complete stored report, closed it with Escape and the native close button, and reopened it at compact UI scale with a fresh manual sample. See the [archived acceptance checklist](../openspec/changes/archive/2026-11-21-fix001-native-diagnostic-export/tasks.md).

Supply build, locale, installed commit, scenario, timestamps, commands, diagnostics and any Lua errors with each report. Redact personal identifiers and account paths. A missing in-game test stays `NOT RUN`; an observed mismatch is a failure or a restricted capability.
