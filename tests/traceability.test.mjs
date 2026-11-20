import assert from "node:assert/strict";
import test from "node:test";
import { ownerApproved, readMetadata, validatePullRequest, validateScope } from "../scripts/validate-traceability.mjs";

const change = "feat001-forever-diagnostics";
const active = "openspec/changes/" + change + "/";
const proposal = {
  base: { ref: "main" },
  head: { ref: "SPEC/FEAT001-forever-diagnostics", sha: "head" },
  body: "OpenSpec-Change: " + change + "\nOpenSpec-Phase: proposal",
};
const files = ["proposal.md", "design.md", "tasks.md", "sdd-scope.json", "specs/probe/spec.md"]
  .map((path) => active + path);

test("accepts the typed, scope-only proposal", () => {
  assert.equal(validatePullRequest(proposal, files).id, change);
});

test("rejects implementation code in a proposal or a mistyped branch", () => {
  assert.throws(() => validatePullRequest(proposal, [...files, "addon/Init.lua"]), /outside/);
  assert.throws(() => validatePullRequest({ ...proposal, head: { ref: "feat/probe" } }, files), /branch/);
});

test("rejects metadata hidden in a template code fence and repeated keys", () => {
  assert.equal(readMetadata("~~~text\nOpenSpec-Phase: proposal\n~~~").size, 0);
  assert.throws(() => readMetadata("OpenSpec-Phase: proposal\nOpenSpec-Phase: proposal"), /Repeated/);
});

test("protects governance from docs-only changes", () => {
  const docs = { ...proposal, body: "OpenSpec-Exemption: docs-only" };
  assert.equal(validatePullRequest(docs, ["docs/TESTING.md"]).phase, "docs");
  assert.throws(() => validatePullRequest(docs, ["docs/SDD_COMPLIANCE.md"]), /ordinary documentation/);
});

test("checks merged contributor approval against the final head", () => {
  const merged = { ...proposal, merged_at: "2026-11-20T17:30:00Z", user: { login: "contributor" } };
  const approved = { state: "APPROVED", commit_id: "head", user: { login: "owner" },
    submitted_at: "2026-11-20T17:29:00Z" };
  assert.equal(ownerApproved(merged, [approved], "owner"), true);
  assert.equal(ownerApproved(merged, [{ ...approved, commit_id: "stale" }], "owner"), false);
  assert.equal(ownerApproved(merged, [{ ...approved, submitted_at: "2026-11-20T17:31:00Z" }], "owner"), false);
});

test("requires explicit implementation paths", () => {
  assert.deepEqual([...validateScope('{"allowed_paths":["addon/Init.lua"]}')], ["addon/Init.lua"]);
  assert.throws(() => validateScope('{"allowed_paths":["../../foo"]}'), /explicit/);
  assert.throws(() => validateScope('{"allowed_paths":["addon/*"]}'), /explicit/);
});
