# Installation

The current checkout contains project setup and research. A source installation becomes possible on a branch with the reviewed diagnostic implementation and its TOC manifest.

1. Confirm that the installed client is WoW: Forever, whose product directory is `_forever_`.
2. When the implementation is available, close the game and copy the directory `addon/DungeonsAnalytics` into `World of Warcraft/_forever_/Interface/AddOns/`.
3. Verify that `Interface/AddOns/DungeonsAnalytics/DungeonsAnalytics.toc` exists and that the addon appears in the client's AddOns list. Reopen the game before checking a newly created addon directory.
4. Run the diagnostic using the commands documented by its implementation and follow the dungeon test protocol. Keep captures local until reviewed and redacted.

Remove only the Dungeons Analytics addon directory to uninstall the game code. SavedVariables are stored by the client and can be retained for local evidence. Installable release ZIPs will contain one top-level `DungeonsAnalytics` directory. A GitHub source ZIP has a different layout.
