## 1. Repair report panel initialization

- [x] 1.1 Define and load the sized native scroll template before the report code.
- [x] 1.2 Wire the native report and release the editor focus when it closes.
- [x] 1.3 Verify template dimensions, TOC load order, report copy wiring and repeat open/close in offline tests.

## 2. Verify and document

- [x] 2.1 Run repository validation, strict OpenSpec, Lua syntax, lint, formatting and isolated Lua tests.
- [ ] 2.2 In Forever, open, copy and close a report. Verify the copied header and last record, Escape, the close button and reopening at a compact UI scale.
- [x] 2.3 Update the native UI and testing docs, run documentation-sync and record archive readiness.

GitHub Actions passed repository validation, OpenSpec traceability, Lua compatibility and the Lua regressions on PR #5. Forever client acceptance in task 2.2 is still pending.
