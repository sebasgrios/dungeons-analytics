# Releases

Dungeons Analytics develops in public under the [PolyForm Noncommercial License 1.0.0](../LICENSE). The owner's requirements are noncommercial sharing and modification with creator attribution. Include [NOTICE](../NOTICE) and the license in source and addon distributions, and keep access free. External package publication remains an explicit owner decision.

The future release workflow will validate the exact main commit, require an explicit owner action, use SemVer and produce a deterministic ZIP with `DungeonsAnalytics/` as its single top-level directory. Validate TOC version and Interface, module load order and archive contents before publishing. Keep development manifest versions distinct from packaged releases. Initial releases below 1.0 can be marked prerelease, subject to the release spec.

GitHub is the first planned distribution channel. CurseForge and Wago both expose Forever package targets for existing projects. Choose packaging metadata after product validation and owner approval. For public distribution confirm free access to unobfuscated source under the [Blizzard addon policy](https://eu.forums.blizzard.com/en/wow/t/wow-user-interface-add-on-development-policy/1642/1). See an existing [Forever package on Wago](https://addons.wago.io/addons/forever-details-meter-threat-damage-healing-and-more).

## Temporary diagnostic builds

Run **Package diagnostic** from the Actions tab on main. The run compares two ZIP builds from the same commit, verifies the manifest and notices, and exposes the exact installable file for seven days. Its summary associates the SHA-256, TOC metadata and full source commit with the test artifact. Use the [installation guide](INSTALLATION.md) when sharing it with a tester. Production releases require a separate owner decision.
