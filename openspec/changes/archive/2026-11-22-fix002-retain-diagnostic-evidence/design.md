## Context

The recorder counts meter updates but can also emit a separate record when consecutive notification IDs differ. A bounded FIFO does not distinguish those records from capture start, combat, encounter or completion evidence. Samples created by meter notifications compete with diagnostic checkpoints in a separate FIFO. Both buffers can fill while the capture is active.

## Goals and Non-Goals

Keep distinct bounds for recent meter observations and the evidence required to interpret a run. Continue existing deferred samples and safe value projection. Preserve readable prior records and the SavedVariables schema if the current representation can support the distinction. This change does not establish full dungeon coverage or repair native report presentation.

## Decisions

- Set a retention priority by the existing event kind and sample reason. Keep the total event and sample counts and bytes within the existing caps. Displace background meter records before lifecycle or explicit checkpoints. Keep a bounded, chronological export and preserve the existing within-epoch sequence ordering.
- Coalesce repeated meter notifications within the existing sampling interval and retain the update count. Distinguish updates that refer to a verified historical session from updates whose ID is absent from a readable catalogue. Preserve the safe unknown or restricted outcome when historical identity cannot be verified.
- Preserve baseline, combat transitions, encounters, zone changes, completion, reset, reload, logout and manual evidence against background notification pressure. When priority evidence alone reaches its bound, apply deterministic eviction and keep the existing storage bounded.
- Reuse the existing deferred-callback invalidation on combat start, stop, zone change and meter reset. Keep processing inside the existing opt-in event paths.

## Risks and Trade-offs

Preserving checkpoints reduces the number of raw notifications or background samples retained. Keep enough bounded delayed observations to measure late updates. Use explicit tests for malformed or unavailable catalogue reads and existing saves.

## Rollout

Validate a repeatable notification burst in the Lua fixture, package the reviewed change, and run a real Forever capture with the account SavedVariables fallback documented in the testing guide.
