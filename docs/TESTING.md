# Testing and evidence

Report static source analysis, offline tests, GitHub check runs and Forever client execution independently. The installed executable identified build `1.60.1.70959` on 2026-11-20. Subsequent Forever tests verified native report export and retention under meter activity.

## Offline

Run the isolated Lua 5.1 suites in `tests/test_*.lua` from the repository root. They exercise secret and restricted mock values, valid zero, restricted in-combat data, ambiguous healing targets, bounded retention, event ordering, cancellation after a reset, reload and TOC loading. The recorder tests exercise interleaved meter updates, catalogue-backed history and checkpoint retention when both storage windows fill. The mocked native probe covers command wiring and missing templates. Client construction and rendering need the acceptance below.

## In-game

1. Install and enable the addon. Use `/da diag` for help and `/da diag start` before entering a dungeon.
2. Use `/da diag ui` outside combat. Record the exact UI outcome and inspect at normal and compact scale. Use `/da diag snapshot` before and after the run when useful. Let the delayed samples run for at least three seconds after the final fight.
3. To test persistence, leave capture active and use `/reload` outside combat. Check the `RELOAD` line and persisted counts in the export. A clean new login requires opting in again.
4. Use `/da diag stop` and `/da diag export`. Save the diagnostic text locally and review it before sharing. If the window is unavailable, log out normally to flush the account SavedVariables. Copy `_forever_/WTF/Account/<account>/SavedVariables/DungeonsAnalytics.lua` before another capture. The file contains the `DungeonsAnalyticsDiagnosticsDB` variable.

| Scenario | Procedure | Evidence |
| --- | --- | --- |
| Build and native UI | Record `GetBuildInfo()` and realm type. Outside combat, run the allowlisted widget probes and inspect a native test frame at normal and compact scale. | Build, Interface, component outcomes, rendered screenshot, Lua errors. |
| Native report export | Outside combat, run `/da diag export` and copy the header and the last record. Close by Escape and the native close button, then reopen after a new sample at compact UI scale. | Complete copy, released editor focus, current report contents and any Lua errors. |
| Manual dungeon | Enable capture outside the entrance. Enter manually, fight at least two trash packs, attempt a boss and clear the dungeon. Leave and compare event ordering. | Map and difficulty availability, session IDs, encounter pairing, final-boss and zone transitions. |
| Queued dungeon | Repeat via the dungeon finder if available. Record whether the completion event follows the last fight and whether a later meter notification changes totals. | LFG and meter event order with elapsed timestamps. |
| Combat access and identity | Compare an aggregate snapshot when safe at pull, combat end, session update and a later bounded sample. Include two players of the same class and mixed combat roles. | Availability counts for source GUID, display name, class, death and amount fields. Record join counts and ambiguity. |
| Healing and segments | Use a healer with self-heals and at least two distinct group targets. Collect source detail shapes and readable coverage. Include boss combat with adds. | Whether recipient amounts reconstruct full healing, whether recipient identity is unambiguous, session granularity and attribution limits. |
| Reload, retention and reset | Preserve a local checkpoint, `/reload` outside combat, compare recorder state and the native session list. Observe reset only when the tester chooses to use Blizzard's UI outside a needed run. | SavedVariables after flush, historical session count, reused IDs, reset order, cap measured or lower bound. |
| Meter notification pressure | After a run with frequent meter updates, inspect the export or SavedVariables for the start, combat and zone transitions, encounters and a manual snapshot. | Priority records survive background churn within the configured bounds. An unlisted update ID cannot replace a retained catalogue-confirmed candidate. |
| Interrupted run | Observe late entry, party replacement, leaving before the final boss and clean logout where feasible. | Coverage gaps and roster event evidence. Keep inaccessible fields distinct from empty lists. |

On 2026-11-21 the owner opened the native probe and report, copied the complete stored report, closed it with Escape and the native close button, and reopened it at compact UI scale with a fresh manual sample. See the [archived acceptance checklist](../openspec/changes/archive/2026-11-21-fix001-native-diagnostic-export/tasks.md).

### Queued dungeon and retention evidence

On 2026-11-22 the owner ran a queued dungeon on Forever `1.60.1.71037`, Interface `16001`, locale `enUS`, with the [verified diagnostic package](https://github.com/sebasgrios/dungeons-analytics/actions/runs/44902591399) from commit `06787d3fbe4eb92e6c422c76bfab2f74eaa20705`. The export reached both caps of 200 events and 24 samples while preserving capture start and stop, instance entry, exit and re-entry, 22 pairs of combat transitions, two successful encounter pairs and post-combat checkpoints. Older lifecycle records also remained available. Isolated Lua regressions verify explicit checkpoints under background pressure. The run's export contained no manual snapshot from the queued run.

The owner reported a wipe and eventual completion. `LFG_COMPLETION_REWARD` registered and no delivery appeared in the retained capture. Current damage changed at the approximately three-second checkpoint in one fight. All 21 retained out-of-combat samples selected historical IDs present in the readable portion of the catalogue. The probe read 12 entries and reported a lower bound of 13. The link from an individual fight to its historical entry remains unverified. The [retention acceptance checklist](../openspec/changes/archive/2026-11-22-fix002-retain-diagnostic-evidence/tasks.md) records the evidence for the recorder fix.

### Solo dungeon entry, combat and reset evidence

The 2026-11-27 Ragefire Chasm test reported Forever `1.60.1.71139`, Interface `16001` and locale `esES`. The diagnostic package prepared for the test came from commit `961a6377146c6928884cd3f2d3c1dba2d074709e`. The capture began outside the instance with no party members, recorded entry to map `389` and returned to outside-instance context before capture stopped. It retained two complete combat pairs lasting 8.235 and 5.988 seconds, with all four delayed checkpoints for each pull. The local player matched a readable source row in all eight post-combat Current damage samples.

`DAMAGE_METER_RESET` arrived before the recorded entry events and advanced the observation epoch. The catalogue went from 12 inspected entries with a lower bound of 13 before reset to empty at entry. Distinct entries appeared after the two pulls and reused IDs `1` and `2` from the prior epoch. Their reported durations changed across checkpoints. After exit, historical detail selected the first catalogue entry again. This run supports correlation by event timing and the appearance of a new entry within one epoch. The reset trigger and the historical selection at arbitrary checkpoints require separate evidence.

### Native UI and clean reload evidence

In a follow-up outside combat on 2026-11-27, Forever `1.60.1.71139` in `esES` reported all nine widget templates available and all nine probed APIs present. The tester copied the panel results and the export retained the matching `NATIVE_UI` record. Lua error and blocked-action observations were not supplied.

The export retained the manual checkpoint from before `/reload`. The `RELOAD` marker reported 200 persisted events and 24 samples and opened a new epoch. The recorder resumed capture and sampled the same two catalogue entries with unchanged reported durations. Earlier dungeon records remained available within the bounded buffers.

### Remaining diagnostic acceptance

A full manual-entry clear with a boss, same-class identity disambiguation and controlled recipient coverage remain `NOT RUN`. Confirm whether the observed reset was tester-initiated. Combine the manual dungeon and recipient checks when the group composition allows. Record Lua errors or blocked actions while testing the probe. Preserve the report before any further native reset test. A standalone SavedVariables recovery check for the original queued run remains `NOT RUN`.

The queued run leaves the delivery and timing of the completion signal unverified. Use the [active acceptance checklist](../openspec/changes/feat001-forever-diagnostics/tasks.md) to track these observations.

Supply build, locale, installed commit, scenario, timestamps, commands, diagnostics and any Lua errors with each report. Redact personal identifiers and account paths. A missing in-game test stays `NOT RUN`; an observed mismatch is a failure or a restricted capability.
