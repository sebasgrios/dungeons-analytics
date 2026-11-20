## Context

The diagnostic was integrated by [PR #2](https://github.com/sebasgrios/dungeons-analytics/pull/2). Its report panel constructs InputScrollFrameTemplate from Lua and attaches anchors afterward. The [pinned Forever Lua source](https://github.com/reckhou/WoWBlzCode/blob/acb81d6eece0bd7f221456a634a54904ba0b043a/Forever/BlizzardInterfaceCode/Interface/AddOns/Blizzard_SharedXML/Shared/InputBox/InputBoxTemplates.lua) sets the editor width from the scroll frame width, less 18 pixels, during OnLoad. The [parent template definition](https://github.com/reckhou/WoWBlzCode/blob/acb81d6eece0bd7f221456a634a54904ba0b043a/Forever/BlizzardInterfaceCode/Interface/AddOns/Blizzard_SharedXML/Shared/InputBox/InputBoxTemplates.xml) does not supply the scroll frame dimensions.

## Goals and Non-Goals

Initialize the native report scroll frame with valid dimensions and preserve the user's ability to copy and close the report. Keep the existing commands, saved format and combat capture behavior.

## Decisions

- Define one addon-owned virtual XML template inheriting InputScrollFrameTemplate with an explicit initial width greater than 18 and a positive height. Load the XML in the manifest before the Lua code that uses it.
- Keep the panel's existing anchors and scaling. Reuse its single window. Clear the editor focus when the window hides. Test the real native close button and Escape on Forever.
- Extend the isolated TOC and UI fixtures to cover XML order and the export command's window wiring. Treat successful mocks as offline evidence only. Preserve the existing localized fallback when the native window cannot open.

## Risks and Trade-offs

Template creation and long multiline input still depend on the real client. Confirm the copied report has its header and its last record and that a reopen shows the current report. A data collection failure continues to be a separate diagnostic result.

## Rollout

Run syntax, format, lint and regression checks. Install the reviewed change in Forever and run the native UI and export checks before testing a real dungeon. Record client build, visible outcome and any errors. Leave the change active when client evidence is outstanding.
