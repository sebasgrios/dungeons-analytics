## Why

The Forever diagnostic uses Blizzard's InputScrollFrameTemplate for its report. The pinned client source sizes the editor inside the inherited OnLoad handler. The diagnostic currently anchors the scroll frame after CreateFrame returns, so template initialization cannot depend on those anchors. Keep report export usable before collecting dungeon evidence.

## What Changes

- Give the addon-owned export scroll frame an explicit size before Blizzard's inherited OnLoad runs.
- Verify the text remains selectable and that closing the panel releases editor focus.
- Exercise the template wiring and copy path in tests. Keep pending Forever-client scenarios explicit.

## Capabilities

### New Capabilities

- `diagnostic-report-export` specifies the native report panel's initialization and copy behavior.

### Modified Capabilities

None.

## Impact

The native diagnostic panel, its TOC load order, and related tests and documentation are affected. The source establishes initialization order. Its effect on Forever still needs a live check. The repair adds no network or addon dependency. Roll back by reverting the implementation PR and leaving the original diagnostics available in SavedVariables.
