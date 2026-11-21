import assert from "node:assert/strict";
import { mkdirSync, mkdtempSync, rmSync, symlinkSync, writeFileSync } from "node:fs";
import { tmpdir } from "node:os";
import { dirname, join } from "node:path";
import test from "node:test";

import { repositoryLinkExists } from "../scripts/repository-links.mjs";

const active = "openspec/changes/chore001-package-diagnostic-builds";
const archived = "openspec/changes/archive/2026-11-21-chore001-package-diagnostic-builds";

function fixture(t) {
  const sandbox = mkdtempSync(join(tmpdir(), "dungeons-repository-links-"));
  t.after(() => rmSync(sandbox, { recursive: true, force: true }));
  const root = join(sandbox, "repository");
  mkdirSync(root);
  function add(path) {
    const file = join(root, path);
    mkdirSync(dirname(file), { recursive: true });
    writeFileSync(file, "fixture\n");
  }
  const link = (path, target) => repositoryLinkExists(path, target, root);
  return { root, add, link };
}

test("ordinary and archived-sibling links use their physical location", (t) => {
  const { add, link } = fixture(t);
  add("docs/TESTING.md");
  add(archived + "/proposal.md");
  assert.equal(link("README.md", "docs/TESTING.md"), true);
  assert.equal(link("README.md", "docs/missing.md"), false);
  assert.equal(link(archived + "/design.md", "proposal.md"), true);
});

test("dated archives can validate a historical reference to repository docs", (t) => {
  const { add, link } = fixture(t);
  add("docs/RELEASES.md");
  add("docs/INSTALLATION.md");
  assert.equal(link(archived + "/design.md", "../../../docs/RELEASES.md"), true);
  assert.equal(link(archived + "/specs/diagnostic-build-packaging/spec.md", "../../../../../docs/INSTALLATION.md"), true);
  assert.equal(link(archived + "/design.md", "../../../docs/MISSING.md"), false);
  assert.equal(link("openspec/changes/archive/undated-change/design.md", "../../../docs/RELEASES.md"), false);
});

test("an active sibling cannot substitute for a missing archived sibling", (t) => {
  const { add, link } = fixture(t);
  add(active + "/proposal.md");
  assert.equal(link(archived + "/design.md", "proposal.md"), false);
});

test("reconstructed and direct archive paths cannot escape the repository", (t) => {
  const { add, link } = fixture(t);
  add("../outside.md");
  assert.equal(link(archived + "/design.md", "../../../../outside.md"), false);
  assert.equal(link(archived + "/design.md", "../../../../../outside.md"), false);
});

test("an archive's reconstructed target cannot escape via a symlink", { skip: process.platform === "win32" }, (t) => {
  const { root, add, link } = fixture(t);
  add("../outside.md");
  mkdirSync(join(root, "docs"));
  symlinkSync(join(root, "..", "outside.md"), join(root, "docs", "outside.md"));
  assert.equal(link(archived + "/design.md", "../../../docs/outside.md"), false);
});
