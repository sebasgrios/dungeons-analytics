# Testing and evidence

Report static source analysis, offline tests, GitHub check runs and Forever client execution independently. The installed executable identified build `1.60.1.70959` on 2026-11-20. All gameplay scenarios below are `NOT RUN`. Follow the approved diagnostic spec and implementation's commands when they become available.

| Scenario | Procedure | Evidence |
| --- | --- | --- |
| Build and native UI | Record `GetBuildInfo()` and realm type. Outside combat, run the allowlisted widget probes and inspect a native test frame at normal and compact scale. | Build, Interface, component outcomes, rendered screenshot, Lua errors. |
| Manual dungeon | Enable capture outside the entrance. Enter manually, fight at least two trash packs, attempt a boss and clear the dungeon. Leave and compare event ordering. | Map and difficulty availability, session IDs, encounter pairing, final-boss and zone transitions. |
| Queued dungeon | Repeat via the dungeon finder if available. Record whether the completion event follows the last fight and whether a later meter notification changes totals. | LFG and meter event order with elapsed timestamps. |
| Combat access and identity | Compare an aggregate snapshot when safe at pull, combat end, session update and a later bounded sample. Include two players of the same class and mixed combat roles. | Availability counts for source GUID, display name, class, death and amount fields. Record join counts and ambiguity. |
| Healing and segments | Use a healer with self-heals and at least two distinct group targets. Collect source detail shapes and readable coverage. Include boss combat with adds. | Whether recipient amounts reconstruct full healing, whether recipient identity is unambiguous, session granularity and attribution limits. |
| Reload, retention and reset | Preserve a local checkpoint, `/reload` outside combat, compare recorder state and the native session list. Observe reset only when the tester chooses to use Blizzard's UI outside a needed run. | SavedVariables after flush, historical session count, reused IDs, reset order, cap measured or lower bound. |
| Interrupted run | Observe late entry, party replacement, leaving before the final boss and clean logout where feasible. | Coverage gaps and roster event evidence. Keep inaccessible fields distinct from empty lists. |

Supply build, locale, installed commit, scenario, timestamps, commands, diagnostics and any Lua errors with each report. Redact personal identifiers and account paths. A missing in-game test stays `NOT RUN`; an observed mismatch is a failure or a restricted capability.
