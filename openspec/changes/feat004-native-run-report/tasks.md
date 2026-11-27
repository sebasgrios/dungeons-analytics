## 1. Native report and history navigation

- [ ] 1.1 Review the merged capture and history contracts and their live evidence before implementation.
- [ ] 1.2 Build the native localized report window, tabs and option controls, with reusable rows and responsive bounds.
- [ ] 1.3 Connect summary, player, encounter and history views to the same selected run and coverage-aware results.
- [ ] 1.4 Implement explicit and optional automatic opening, and preserve position, size and existing saved runs.

## 2. Timeline and filters

- [ ] 2.1 Implement bounded pooled geometry for actor series, encounter spans, labels and supported death markers.
- [ ] 2.2 Implement metric and interval selection, legend toggles, zoom, pan, range selection and native tooltips.
- [ ] 2.3 Verify missing evidence, whole-segment range rules, distinct actor labels, pool reuse and localized states in Lua fixtures.
- [ ] 2.4 Update the native UI documentation and the user and test guides.

## 3. Real-data acceptance

- [ ] 3.1 Run the repository, OpenSpec, Lua 5.1 and installable package checks.
- [ ] 3.2 Install the exact MVP build in Forever. Capture and reopen a real group run from history, including trash and a boss attempt. Compare timings, eligible totals, actor rows and coverage with the captured evidence.
- [ ] 3.3 Verify both locales at default and compact scale, close and reopen, pointer and keyboard navigation, zoom, pan, legend toggles and a range crossing a pull boundary. Record native visual behavior, pooling and any Lua and blocked-action issues.
- [ ] 3.4 Run documentation-sync, review the four PR check contexts and record archive readiness.

Report implementation and the MVP scenarios are `NOT RUN`. Existing diagnostic results inform component selection and expected data limits.
