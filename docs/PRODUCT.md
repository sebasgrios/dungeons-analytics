# Product and functional scope

Dungeons Analytics helps a party member review what happened over an entire World of Warcraft: Forever dungeon. Target players include people comparing repeated runs and groups trying to place performance changes in the context of a particular pull or boss attempt.

| Area | Planned behavior |
| --- | --- |
| Dungeon lifecycle | Detect dungeon entry, difficulty and group changes. Support queued and manual entry where evidenced. Mark an abandoned, interrupted or partially observed run. Offer explicit finish if automatic completion is uncertain. |
| Encounters | Record attempts, outcomes, combat and downtime with timestamps. Preserve ambiguity when one meter session overlaps multiple encounters or enemies. |
| Reports | Show group and per-player metrics, contributions, duration, kill and wipe counts, rankings and breakdowns. Make automatic opening configurable. |
| Timeline | Plot one class-colored series per identified player. Label boss bands and markers, show deaths where evidenced, and support tooltips, series toggles, zoom, pan and range selection. Use encounter artwork only when the client provides a compatible association. |
| Filters | Offer full run, boss, trash, encounter, pull and custom ranges. Support totals, rates, cumulative values and shares only when the available precision and coverage support the calculation. |
| History | Persist bounded local runs, support search, date and difficulty filters, duration and performance sorting, confirmed deletion, same-dungeon comparison and personal trends. |

The MVP uses client-provided data and native UI, with English and Spanish strings. No services, accounts, telemetry or required external addons are part of the runtime. A future external Combat Log parser requires a separate specification. The [capability matrix](WOW_FOREVER_API.md) determines which proposed metrics can graduate to the product.
