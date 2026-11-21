import argparse
from dataclasses import dataclass
import hashlib
from io import BytesIO
from pathlib import Path, PurePosixPath
import re
import stat
import subprocess
from tempfile import TemporaryDirectory
from zipfile import ZIP_STORED, ZipFile, ZipInfo


ADDON = "DungeonsAnalytics"
ADDON_SOURCE = f"addon/{ADDON}"
TOC = f"{ADDON}.toc"
REQUIRED_FILES = ("LICENSE", "NOTICE")
MEMBER_PATH = re.compile(r"[A-Za-z0-9_][A-Za-z0-9_.-]*(?:/[A-Za-z0-9_][A-Za-z0-9_.-]*)*")
WINDOWS_DEVICE = re.compile(r"CON|PRN|AUX|NUL|COM[1-9]|LPT[1-9]", re.IGNORECASE)


@dataclass(frozen=True)
class DiagnosticArchive:
    commit: str
    interface: str
    version: str
    data: bytes

    @property
    def name(self):
        return f"{ADDON}-diagnostic-{self.commit[:12]}.zip"

    @property
    def digest(self):
        return hashlib.sha256(self.data).hexdigest()


def read_git(repository, *args):
    return subprocess.run(
        ["git", *args], cwd=repository, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE
    ).stdout


def committed_files(repository, commit):
    tree = read_git(repository, "ls-tree", "-rz", "--full-tree", commit, "--", ADDON_SOURCE, *REQUIRED_FILES)
    blobs = {}
    for entry in tree.split(b"\0"):
        if not entry:
            continue
        metadata, path = entry.split(b"\t", 1)
        mode, kind, object_id = metadata.split()
        if mode in (b"100644", b"100755") and kind == b"blob":
            blobs[path.decode("utf-8", "surrogateescape")] = object_id.decode("ascii")
    return blobs


def read_committed_file(repository, files, path):
    object_id = files.get(path)
    if object_id is None:
        raise ValueError(f"Missing committed regular file: {path}")
    return read_git(repository, "cat-file", "blob", object_id)


def package_path(line):
    path = line.replace("\\", "/")
    if not MEMBER_PATH.fullmatch(path):
        raise ValueError(f"Invalid TOC path: {line}")
    for part in PurePosixPath(path).parts:
        if part.endswith(".") or WINDOWS_DEVICE.fullmatch(part.split(".", 1)[0]):
            raise ValueError(f"Invalid Windows archive path: {line}")
    if PurePosixPath(path).suffix.lower() not in (".lua", ".xml"):
        raise ValueError(f"Expected a declared Lua or XML file: {line}")
    return path


def read_manifest(contents):
    metadata = {}
    paths = []
    seen = set()
    for entry in contents.decode("utf-8-sig").splitlines():
        line = entry.strip()
        if not line:
            continue
        if line.startswith("##"):
            key, colon, value = line[2:].partition(":")
            key = key.strip().casefold()
            if colon and key in ("interface", "version"):
                if key in metadata:
                    raise ValueError(f"Repeated TOC metadata: {key}")
                metadata[key] = value.strip()
        elif not line.startswith("#"):
            path = package_path(line)
            if path.casefold() in seen:
                raise ValueError(f"Duplicate or case-colliding TOC path: {line}")
            seen.add(path.casefold())
            paths.append(path)

    interface = metadata.get("interface", "")
    version = metadata.get("version", "")
    if not re.fullmatch(r"[1-9][0-9]*(?:\s*,\s*[1-9][0-9]*)*", interface):
        raise ValueError("TOC requires valid Interface metadata")
    if not re.fullmatch(r"[A-Za-z0-9][A-Za-z0-9.+-]*", version):
        raise ValueError("TOC requires valid Version metadata")
    if not paths:
        raise ValueError("TOC must declare at least one Lua or XML file")
    return interface, version, paths


def make_zip(payload):
    output = BytesIO()
    names = sorted(payload)
    with ZipFile(output, "w", compression=ZIP_STORED) as archive:
        for name in names:
            member = ZipInfo(name, date_time=(1980, 1, 1, 0, 0, 0))
            member.create_system = 3
            member.external_attr = (stat.S_IFREG | 0o644) << 16
            archive.writestr(member, payload[name])
    data = output.getvalue()
    with ZipFile(BytesIO(data)) as archive:
        if archive.namelist() != names or archive.testzip() is not None:
            raise ValueError("ZIP member verification failed")
        for name in names:
            if archive.read(name) != payload[name]:
                raise ValueError(f"ZIP member differs from its committed contents: {name}")
    return data


def pack_commit(repository, revision):
    commit = read_git(repository, "rev-parse", "--verify", "--end-of-options", f"{revision}^{{commit}}")
    commit = commit.decode("ascii").strip()
    files = committed_files(repository, commit)
    manifest = read_committed_file(repository, files, f"{ADDON_SOURCE}/{TOC}")
    interface, version, paths = read_manifest(manifest)
    payload = {f"{ADDON}/{TOC}": manifest}
    for path in paths:
        payload[f"{ADDON}/{path}"] = read_committed_file(repository, files, f"{ADDON_SOURCE}/{path}")
    for path in REQUIRED_FILES:
        payload[f"{ADDON}/{path}"] = read_committed_file(repository, files, path)
    return DiagnosticArchive(commit, interface, version, make_zip(payload))


def write_archive(archive, output_dir):
    output_dir.mkdir(parents=True, exist_ok=True)
    destination = output_dir / archive.name
    with TemporaryDirectory(dir=output_dir) as temporary:
        staged = Path(temporary) / archive.name
        staged.write_bytes(archive.data)
        staged.replace(destination)
    return destination


def main():
    parser = argparse.ArgumentParser(description="Build an installable ZIP from committed Forever addon files.")
    parser.add_argument("--commit", default="HEAD", help="Git revision to package")
    parser.add_argument("--output-dir", type=Path, required=True, help="directory for the checked archive")
    args = parser.parse_args()
    try:
        archive = pack_commit(Path.cwd(), args.commit)
        destination = write_archive(archive, args.output_dir)
    except (OSError, ValueError, subprocess.CalledProcessError) as error:
        parser.exit(1, f"Cannot package the requested diagnostic: {error}\n")
    print("### Dungeons Analytics diagnostic build\n")
    print(f"- File: {destination.name}")
    print(f"- Source commit: {archive.commit}")
    print(f"- TOC interface: {archive.interface}")
    print(f"- TOC version: {archive.version}")
    print(f"- SHA-256: {archive.digest}")


if __name__ == "__main__":
    main()
