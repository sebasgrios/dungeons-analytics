## 1. Package the exact source commit

- [ ] 1.1 Implement a deterministic ZIP builder for the declared addon payload, LICENSE and NOTICE.
- [ ] 1.2 Test reproducible bytes, the exact layout and rejection of invalid or missing inputs.
- [ ] 1.3 Add the main-only workflow dispatch, read-only permissions, verified artifact and job summary.

## 2. Verify and document

- [ ] 2.1 Run repository, OpenSpec and package tests and verify the packaged TOC entries.
- [ ] 2.2 Dispatch the workflow on main once it lands. Record the exact commit, artifact and digest and verify extraction into one addon directory.
- [ ] 2.3 Document tester download and install instructions and run documentation-sync. Record the exact remaining acceptance gaps before archive.
