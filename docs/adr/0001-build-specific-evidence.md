# ADR 0001 — Require Forever build evidence

**Status:** Accepted for repository initialization. Runtime implementation remains subject to its proposal.

Base API decisions on a pinned Forever client snapshot and real-client acceptance on the target build. Use generated API definitions to identify callable interfaces and candidate data, and explicit diagnostics to measure what becomes readable and durable. A source signature alone cannot establish runtime delivery, visibility or finality.

Use native client components to build an original addon layout. Keep the addon independent of Blizzard panels' internal mixins with protected or load-on-demand dependencies. Record unsupported inputs as unavailable and represent historical data at its observed resolution.

The requirement affects the telemetry schema, history guarantees and graph design. The immediate cost is a diagnostic milestone before the functional tracker. The benefit is a product measurement contract grounded in reproducible evidence.
