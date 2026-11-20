import { execFileSync } from "node:child_process";
import { existsSync, readFileSync } from "node:fs";
import { dirname, resolve } from "node:path";

const files = execFileSync("git", ["ls-files", "-z"], { encoding: "utf8" }).split("\0").filter(Boolean);
const required = [
  "README.md", "AGENTS.md", "CONTRIBUTING.md", "SECURITY.md", "CHANGELOG.md", "LICENSE", "NOTICE",
  "openspec/config.yaml", "docs/TESTING.md", "docs/WOW_FOREVER_API.md", "docs/NATIVE_UI.md",
  ".github/workflows/ci.yml", ".github/workflows/spec-compliance.yml",
];

for (const path of required) {
  if (!files.includes(path) || !readFileSync(path, "utf8").trim()) {
    throw new Error("Missing required repository file: " + path);
  }
}

for (const path of files.filter((name) => name.endsWith(".md"))) {
  const source = readFileSync(path, "utf8");
  for (const match of source.matchAll(/\[[^\]\n]+\]\(([^)\s]+)\)/g)) {
    const [target] = match[1].split("#");
    if (target && !/^[a-z][a-z0-9+.-]*:/i.test(target) && !existsSync(resolve(dirname(path), target))) {
      throw new Error("Broken local Markdown link in " + path + ": " + target);
    }
  }
}

const manifest = "addon/DungeonsAnalytics/DungeonsAnalytics.toc";
if (files.some((path) => path.startsWith("addon/"))) {
  if (!files.includes(manifest)) throw new Error("Missing installable TOC manifest");
  const entries = readFileSync(manifest, "utf8").split(/\r?\n/).map((line) => line.trim())
    .filter((line) => line && !line.startsWith("#")).map((line) => line.replaceAll("\\", "/"));
  for (const entry of entries) {
    if (!files.includes(dirname(manifest) + "/" + entry)) throw new Error("Unknown TOC entry: " + entry);
  }
  if (!entries.length || new Set(entries).size !== entries.length) {
    throw new Error("TOC must load unique runtime files");
  }
}

console.log("Repository structure, local links and applicable TOC wiring verified.");
