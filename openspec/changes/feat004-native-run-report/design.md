## Context

The diagnostic passed nine native widget probes and nine API probes on Forever `1.60.1.71139`. The queued capture recorded boss boundaries and unequal group and player coverage. The solo capture showed separate combat intervals and variable native duration for a given pull. These are inputs to the report design. The finished window still needs in-game visual and interaction acceptance. [Native component catalogue](https://github.com/sebasgrios/dungeons-analytics/blob/961a6377146c6928884cd3f2d3c1dba2d074709e/docs/NATIVE_UI.md) · [Captured results](https://github.com/sebasgrios/dungeons-analytics/blob/42c60baa032e804fac9439c1916ff4fa7ca6c116/docs/TESTING.md)

## Decisions

### Window and report state

Use an addon-owned native panel with verified generic templates, native fonts, tabs, dropdowns, list controls and tooltips. Give Dungeons Analytics its own layout, with the timeline as the primary analytical view. Gate optional widgets and artwork on compatible client APIs. When context or portrait artwork cannot be associated safely, retain the readable text and use a generic native treatment. Avoid protected Blizzard frames and internal panel mixins.

Open the report via `/da report` or a selected history record. Reopening displays the requested run. Keep capture and the previous diagnostic commands independent of visibility. Remember a bounded window position and size only when supported. Support keyboard focus, Escape, the native close button, pointer and wheel input, and keep the panel usable at default and compact scales. Register options with native Settings where available and retain a localized way to configure automatic opening. An opt-in auto-open waits for an eligible out-of-combat window and a usable run. Preserve existing saved history when extending its preferences.

Drive the summary, history and chart from the same selected run, metric and interval state. The summary shows elapsed time, observed combat and downtime, boss outcomes, group and player results, counts of eligible segments, and per-encounter or per-pull breakdowns. Rankings and contributions use compatible covered values. The history supplies search, difficulty and date filters, and duration or performance sorting where a comparable value exists. Empty, partial and unavailable views have explicit localized status.

### Timeline representation and input

Use elapsed observed run time on the horizontal axis and the selected metric on the vertical axis. Draw whole-pull amounts or rates over their observed intervals with explicit segment boundaries. Cumulative series change at eligible segment boundaries. Leave gaps where capture or player attribution is unknown. Represent encounter spans and boundaries independently from combat intervals, and show death markers only with a safely associated time. Keep a mixed or uncertain association identifiable.

Give each safely resolved actor a class-colored series when a class is known, a distinct text label and a legend toggle. Use labels supplied by the allowed run data and fall back to stable anonymous labels. The legend, markers and tooltips describe the observed amount, units, duration source and coverage without depending on color alone. Expose every eligible metric and label unsupported coverage. Provide whole-run, boss, trash, encounter, pull and custom range views, plus segment totals, cumulative totals, rates and group shares when eligible.

Use fixed frame, line, texture and font-string pools bounded by the accepted record size and viewport. Reuse regions and update visible geometry after zooming, panning, resizing, selecting a range or toggling a series. A pure viewport calculation maps pointer time to the underlying normalized intervals. A custom selection that cuts through a segment shows the resolution limit and uses the history layer's eligible whole-segment results. Keep presentation transformations independent of the stored amounts. Verify that default and compact scales maintain legibility, focus and interaction.
