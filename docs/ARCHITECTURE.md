# Preliminary architecture

The following boundaries adapt CraftAtlas for event-driven combat analytics. The [Forever diagnostic](ROADMAP.md) will decide the source contract before the product tracker or renderer is implemented.

| Area | Responsibility |
| --- | --- |
| `addon/DungeonsAnalytics/Core/` | Addon namespace, lifecycle, centralized event routing and dependency wiring. |
| `Infrastructure/` | Guarded game API, instance and party observations, bounded deferred meter reads, SavedVariables, settings and localization selection. |
| `Domain/` | Pure tracking transitions, correlation, deduplication, schema migration and aggregation. |
| `Features/` | Native presentation and feature entry points. Build an original timeline layout with native controls; pool chart primitives and rows. |
| `Localization/` | enUS and esES interface strings, falling back to enUS. |

Record run, encounter and combat observations before deriving reports. Confirm instance context after transitions and save a run's observation coverage so reload, joining mid-run, disconnect and missing final signals remain visible. In combat, handle only bounded event metadata and defer statistical collection. Determine finalization and update order empirically. Schedule bounded retries against an expected run and session generation. Duplicate updates replace snapshots, and stale callbacks after a reset or transition are ignored.

Project normalized payloads into new plain Lua tables before handing them to domain code. Keep capture independent of open windows. Feature rendering consumes the same metric metadata and accuracy as the report calculations. See [data model](DATA_MODEL.md) and [native UI candidates](NATIVE_UI.md).
