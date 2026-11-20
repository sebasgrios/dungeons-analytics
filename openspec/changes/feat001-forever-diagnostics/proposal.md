## Why

The Forever 1.60.1.70959 interface snapshot documents restricted aggregate combat data. Its actual availability, event ordering and persistence determine whether a dungeon timeline can support named players, healing received and reliable encounter boundaries. A small diagnostic on the actual client is the first runtime milestone.

## What Changes

- Add an opt-in, bilingual diagnostic for Forever, recorded with the exact build and TOC.
- Measure safe field readability across combat phases, retained sessions, party joins, encounters, completion, healing detail and reload.
- Probe a shortlist of generic native UI components outside combat and document observed results with reproduction steps.
- Store and export bounded local diagnostic observations with no raw player identifiers. Leave the native meter, CVars and other addons untouched.
- Keep tracker, reports, history, production UI, package publication and external log parsing outside this change.

## Capabilities

### New Capabilities

- `forever-client-diagnostics` validates meter access, dungeon signals, native UI and persisted evidence.

### Modified Capabilities

No existing runtime capability changes.

## Impact

The approved change can introduce the first installable TOC and small Lua adapters. It requires Lua 5.1 mocks and a real manual and queued dungeon when available. The most important open risks are unreadable identities, incomplete recipient coverage, ambiguous fight boundaries and asynchronous final values. Keep the delta active when a mandatory scenario has no real-client evidence. Roll back by disabling capture or removing only the Dungeons Analytics addon directory. No third-party code or asset distribution is needed.
