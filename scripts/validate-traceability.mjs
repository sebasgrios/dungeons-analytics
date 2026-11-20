import { execFileSync } from "node:child_process";
import { readFileSync } from "node:fs";
import { pathToFileURL } from "node:url";

const metadataPattern = /^(OpenSpec-(?:Change|Phase|Approval-PR|Exemption|Archive|Archive-Evidence)|Documentation-(?:Review|Evidence)):[ \t]*(.+?)\s*$/gm;
const proposalArtifact = /^(proposal\.md|design\.md|tasks\.md|sdd-scope\.json|specs\/[a-z0-9-]+\/spec\.md)$/;
const changeIdPattern = /^(feat|fix|chore|upd|del)(\d{3})-([a-z0-9]+(?:-[a-z0-9]+)*)$/;

function requireThat(condition, message) {
  if (!condition) throw new Error(message);
}

export function readMetadata(body) {
  const fields = new Map();
  const lines = (body ?? "").replace(/^ {0,3}(\x60{3,}|~{3,})[^\n]*\n[\s\S]*?^ {0,3}\1[ \t]*$/gm, "");
  for (const match of lines.matchAll(metadataPattern)) {
    requireThat(!fields.has(match[1]), "Repeated PR metadata: " + match[1]);
    fields.set(match[1], match[2]);
  }
  return fields;
}

export function validatePullRequest(pr, paths) {
  requireThat(pr.base.ref === "main" && paths.length > 0, "Target main with a nonempty change");
  const fields = readMetadata(pr.body);
  const phase = fields.get("OpenSpec-Phase");
  if (fields.has("OpenSpec-Exemption")) {
    const protectedDocs = /^(docs\/(?:SDD_COMPLIANCE|GITHUB_SETTINGS|ROADMAP|METHODOLOGY|ARCHITECTURE|DATA_MODEL|PRODUCT|RELEASES)\.md|docs\/adr\/)/;
    requireThat(fields.size === 1 && fields.get("OpenSpec-Exemption") === "docs-only"
      && paths.every((path) => /^(README\.md|CHANGELOG\.md|docs\/.+\.md)$/.test(path) && !protectedDocs.test(path)),
    "The docs-only exemption requires ordinary documentation paths only");
    return { phase: "docs" };
  }

  const id = fields.get("OpenSpec-Change");
  const type = id?.match(changeIdPattern);
  requireThat(type && type[2] !== "000", "Use an unused lowercase typed OpenSpec change ID");
  const branch = type[1].toUpperCase();
  const active = "openspec/changes/" + id + "/";
  if (phase === "proposal") {
    requireThat(fields.size === 2, "Use only the proposal metadata");
    requireThat(pr.head.ref === "SPEC/" + branch + type[2] + "-" + type[3], "Incorrect proposal branch");
    requireThat(paths.every((path) => path.startsWith(active) && proposalArtifact.test(path.slice(active.length))),
      "Proposal includes paths outside its own OpenSpec artifacts");
    for (const artifact of ["proposal.md", "design.md", "tasks.md", "sdd-scope.json"]) {
      requireThat(paths.includes(active + artifact), "Missing proposal artifact: " + artifact);
    }
    requireThat(paths.some((path) => path.startsWith(active + "specs/")), "Missing capability delta");
    return { id, active, phase, sequence: type[1] + type[2] };
  }

  requireThat(phase === "implementation", "Declare proposal or implementation phase");
  requireThat(pr.head.ref === branch + "/" + type[2] + "-" + type[3], "Incorrect implementation branch");
  const approval = fields.get("OpenSpec-Approval-PR");
  requireThat(/^[1-9]\d*$/.test(approval ?? ""), "Supply the merged proposal PR number");
  const archive = fields.get("OpenSpec-Archive");
  requireThat(archive === "blocked" || archive === "prepared", "Declare archive readiness");
  const review = fields.get("Documentation-Review");
  requireThat(review === "updated" || review === "not-applicable", "Declare documentation review");
  for (const key of ["OpenSpec-Archive-Evidence", "Documentation-Evidence"]) {
    requireThat(fields.get(key)?.trim().length >= 20, "Supply specific evidence in " + key);
  }
  if (review === "updated") {
    requireThat(paths.some((path) => /^(README\.md|CHANGELOG\.md|docs\/.*\.md)$/.test(path)),
      "Documentation marked updated without a documentation change");
  }
  return { id, active, phase, approval, archive };
}

export function validateScope(text) {
  const scope = JSON.parse(text).allowed_paths;
  requireThat(Array.isArray(scope) && scope.length > 0 && new Set(scope).size === scope.length
    && scope.every((path) => typeof path === "string" && /^(?:[a-z0-9_.-]+\/)*[a-z0-9_.-]+$/i.test(path)
      && !path.split("/").some((part) => part === "." || part === "..")
      && !path.startsWith("openspec/")), "Scope must list unique, explicit repository paths");
  return new Set(scope);
}

export function ownerApproved(proposal, reviews, owner) {
  if (!proposal.merged_at) return false;
  if (proposal.user.login === owner) return proposal.merged_by?.login === owner;

  const decisions = reviews.filter((review) => review.user?.login === owner
    && review.submitted_at && review.submitted_at <= proposal.merged_at
    && ["APPROVED", "CHANGES_REQUESTED", "DISMISSED"].includes(review.state));
  decisions.sort((a, b) => a.submitted_at.localeCompare(b.submitted_at) || a.id - b.id);
  const decision = decisions.at(-1);
  return decision?.state === "APPROVED" && decision.commit_id === proposal.head.sha;
}

function git(...args) {
  return execFileSync("git", args, { encoding: "utf8" });
}

function tree(ref, prefix) {
  return git("ls-tree", "-r", "--name-only", "-z", ref, "--", prefix).split("\0").filter(Boolean);
}

function validateBaseScope(change, paths, base) {
  const allowed = validateScope(git("show", base + ":" + change.active + "sdd-scope.json"));
  const artifacts = tree(base, change.active);
  const withinScope = (path) => allowed.has(path) || path === change.active + "tasks.md";
  if (change.archive === "blocked") {
    requireThat(paths.every(withinScope) && tree("HEAD", change.active).length === artifacts.length,
      "Implementation changed an unapproved path or removed an active artifact");
    return;
  }

  const datedPrefix = /^openspec\/changes\/archive\/\d{4}-\d{2}-\d{2}-[^/]+\//;
  const prefixes = new Set(paths.map((path) => path.match(datedPrefix)?.[0])
    .filter((prefix) => prefix?.endsWith("-" + change.id + "/")));
  requireThat(prefixes.size === 1 && tree("HEAD", change.active).length === 0,
    "Archive one complete change and remove its active copy");
  const [archive] = prefixes;
  const canonical = new Set(artifacts.filter((path) => path.startsWith(change.active + "specs/"))
    .map((path) => "openspec/" + path.slice(change.active.length)));
  const archived = new Set(artifacts.map((path) => archive + path.slice(change.active.length)));
  requireThat(paths.every((path) => allowed.has(path) || artifacts.includes(path) || archived.has(path)
    || canonical.has(path) || path === "docs/OPENSPEC_STATUS.md"), "Archive touched an unapproved path");
  for (const path of canonical) requireThat(paths.includes(path), "Missing canonical sync: " + path);

  for (const path of artifacts) {
    const suffix = path.slice(change.active.length);
    const archivedText = git("show", "HEAD:" + archive + suffix);
    if (suffix === "tasks.md") {
      requireThat(!/^\s*-\s+\[ \]/m.test(archivedText), "Archive has outstanding tasks");
    } else {
      requireThat(archivedText === git("show", base + ":" + path), "Archived approved artifact changed: " + path);
    }
  }
}

async function github(path, page) {
  const url = new URL(process.env.GITHUB_API_URL + "/repos/" + process.env.GITHUB_REPOSITORY + path);
  if (page) url.search = new URLSearchParams({ per_page: "100", page: String(page) });
  const response = await fetch(url, { headers: {
    Accept: "application/vnd.github+json",
    Authorization: "Bearer " + process.env.GH_TOKEN,
  } });
  requireThat(response.ok, "GitHub proposal lookup failed: " + response.status);
  return response.json();
}

async function collect(path) {
  const results = [];
  for (let page = 1; ; page++) {
    const batch = await github(path, page);
    results.push(...batch);
    if (batch.length < 100) return results;
  }
}

async function main() {
  const event = JSON.parse(readFileSync(process.env.GITHUB_EVENT_PATH, "utf8"));
  const pr = event.pull_request;
  const base = pr.base.sha;
  const paths = git("diff", "--name-only", "--no-renames", "-z", base + "...HEAD").split("\0").filter(Boolean);
  const change = validatePullRequest(pr, paths);

  if (change.phase === "proposal") {
    validateScope(git("show", "HEAD:" + change.active + "sdd-scope.json"));
    const current = tree(base, "openspec/changes/");
    requireThat(!current.some((path) => {
      const parts = path.split("/");
      const prior = parts[2] === "archive" ? parts[3]?.slice(11) : parts[2];
      return prior?.startsWith(change.sequence + "-");
    }), "Change sequence already used on main");
  }

  if (change.phase === "implementation") {
    const endpoint = "/pulls/" + change.approval;
    const [proposal, files, reviews] = await Promise.all([
      github(endpoint), collect(endpoint + "/files"), collect(endpoint + "/reviews"),
    ]);
    const accepted = validatePullRequest(proposal, files.map((file) => file.filename));
    requireThat(accepted.phase === "proposal" && accepted.id === change.id
      && ownerApproved(proposal, reviews, event.repository.owner.login),
    "Referenced PR is not the owner-approved, merged proposal for this change");

    git("merge-base", "--is-ancestor", proposal.merge_commit_sha, base);
    for (const path of tree(base, change.active).filter((file) => !file.endsWith("/tasks.md"))) {
      requireThat(git("show", base + ":" + path) === git("show", proposal.merge_commit_sha + ":" + path),
        "Base changed an approved artifact: " + path);
    }
    validateBaseScope(change, paths, base);
  }

  console.log("Verified OpenSpec traceability for " + change.phase + ".");
}

if (process.argv[1] && pathToFileURL(process.argv[1]).href === import.meta.url) {
  await main();
}
