# Installation

Use the checkout that contains the diagnostic implementation and `addon/DungeonsAnalytics/DungeonsAnalytics.toc`. This is a development addon for the Forever client.

1. Confirm that the installed client is WoW: Forever, whose product directory is `_forever_`.
2. Close the client and copy the directory `addon/DungeonsAnalytics` into `World of Warcraft/_forever_/Interface/AddOns/`.
3. Verify that `Interface/AddOns/DungeonsAnalytics/DungeonsAnalytics.toc` exists and that the addon appears in the client's AddOns list. Reopen the game before checking a newly created addon directory.
4. Run `/da diag` in chat, then `/da diag start` to opt in. Follow the [dungeon test protocol](TESTING.md).
5. After combat, use `/da diag export` and copy the selected text. Use `/da diag stop` when finished. SavedVariables persist on a clean reload or logout. Keep captures local until reviewed.

Remove only the Dungeons Analytics addon directory to uninstall the game code. SavedVariables are stored by the client and can be retained for local evidence. Installable release ZIPs will contain one top-level `DungeonsAnalytics` directory. A GitHub source ZIP has a different layout.
