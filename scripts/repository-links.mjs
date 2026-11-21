import { existsSync, realpathSync } from "node:fs";
import { dirname, isAbsolute, relative, resolve, sep } from "node:path";

const archivePath = /^openspec\/changes\/archive\/\d{4}-\d{2}-\d{2}-([a-z][a-z0-9-]+)\/(.+)$/;

function isWithin(directory, target) {
  const name = relative(directory, target);
  return name !== ".." && !name.startsWith(".." + sep) && !isAbsolute(name);
}

function existsInRepository(repository, target) {
  if (!isWithin(repository, target) || !existsSync(target)) return false;
  return isWithin(realpathSync(repository), realpathSync(target));
}

export function repositoryLinkExists(path, target, repository = process.cwd()) {
  const currentPath = resolve(repository, dirname(path), target);
  const archived = path.match(archivePath);
  if (!archived) return existsSync(currentPath);
  if (existsInRepository(repository, currentPath)) return true;

  const [, changeId, artifact] = archived;
  const active = resolve(repository, "openspec", "changes", changeId);
  const originalTarget = resolve(dirname(resolve(active, artifact)), target);
  if (isWithin(active, originalTarget)) return false;
  return existsInRepository(repository, originalTarget);
}
