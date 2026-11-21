## 1. Package the exact source commit

- [x] 1.1 Implement a deterministic ZIP builder for the declared addon payload, LICENSE and NOTICE.
- [x] 1.2 Test reproducible bytes, the exact layout and rejection of invalid or missing inputs.
- [x] 1.3 Add the main-only workflow dispatch, read-only permissions, verified artifact and job summary.

## 2. Verify and document

- [x] 2.1 Run repository, OpenSpec and package tests and verify the packaged TOC entries.
- [x] 2.2 Dispatch the workflow on main once it lands. Record the exact commit, artifact and digest and verify extraction into one addon directory.
- [x] 2.3 Document tester download and install instructions and run documentation-sync. Record the exact remaining acceptance gaps before archive.

The package-verification job in PR #6 passed its Python regressions and compared two ZIP files built from the commit it tested.

The [manual main run](https://github.com/sebasgrios/dungeons-analytics/actions/runs/44861373640) passed ZIP layout, contents and reproducibility checks and uploaded DungeonsAnalytics-diagnostic-1e57aa71094c.zip. The source commit is 1e57aa71094c5f084ca15a397b3949a4aa5e26dd, Interface is 16001, and the TOC version is 0.1.0-dev. The reported and uploaded SHA-256 both equal 754dae4305a80c9d3992df85058504d2097f7c2ef22d782840b391657b30099f. Those checks verified the single DungeonsAnalytics root, the committed manifest and resources, LICENSE and NOTICE.
