# Preliminary architecture

The following boundaries adapt CraftAtlas for event-driven combat analytics. The [Forever diagnostic](ROADMAP.md) will decide the source contract before the product tracker or renderer is implemented.

| Area | Responsibility |
| --- | --- |
| `addon/DungeonsAnalytics/Core/` | Addon namespace, lifecycle, centralized event routing and dependency wiring. |
| `Infrastructure/` | Guarded game API, instance and party observations, bounded deferred meter reads, SavedVariables, settings and localization selection. |
| `Domain/` | Pure tracking transitions, correlation, deduplication, schema migration and aggregation. |
| `Features/` | Native presentation and feature entry points. Build an original timeline layout with native controls; pool chart primitives and rows. |
| `Localization/` | enUS and esES interface strings, falling back to enUS. |

The diagnostic routes events through one frame. The recorder schedules bounded checkpoints and ignores queued callbacks from older generations after combat starts, a zone change, a stop or a reset. In combat it takes one lightweight Current damage sample at pull start and counts meter notifications. Detailed samples run outside combat and keep the associated instance and roster snapshots. Runtime ordering and finality stay evidence questions for the client test.

The meter adapter projects normalized data into owned tables. Readable names and GUIDs are transient keys used only for joins. The recorder exports anonymized party slots, counts and available numbers. Capture stays independent of open windows. Future trackers and report renderers will build on measured coverage and provenance. See [data model](DATA_MODEL.md) and [native UI candidates](NATIVE_UI.md).
