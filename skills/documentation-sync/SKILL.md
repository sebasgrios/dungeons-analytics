---
name: documentation-sync
description: Reconcile implementation, OpenSpec acceptance, addon documentation and actual Forever evidence before pull requests.
---

# Documentation sync

Read the base-to-head diff, approved OpenSpec artifacts and relevant source and tests. Review the following in order.

1. Compare current user journeys and limitations against README. Update visible behavior and localized commands only when supported.
2. Check affected architecture, data model, installation and development instructions. Verify identifiers, file paths, build and data provenance.
3. Record automated tests executed and actual in-game scenarios. Leave missing manual scenarios as `NOT RUN`.
4. Review roadmap, changelog and tasks. If every mandatory scenario is evidenced, prepare a scoped canonical sync and lossless dated archive. Otherwise keep the active change and list its exact archive blockers.
5. Write specific `Documentation-Review` and `Documentation-Evidence` lines in the implementation PR. Recheck the four required check contexts on the current head.

For a spec-only PR, verify branch and ID, spec scope, source links, acceptance criteria and claimed evidence. Repeat the applicable audit after revisions.
