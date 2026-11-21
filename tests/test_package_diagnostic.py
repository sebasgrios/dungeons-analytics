from io import BytesIO
from pathlib import Path
import subprocess
import sys
from tempfile import TemporaryDirectory
import unittest
from zipfile import ZipFile


sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
from package_diagnostic import pack_commit, read_manifest, write_archive


HEADER = "## Interface: 16001\n## Version: 0.1.0-dev\n"
MANIFEST = "addon/DungeonsAnalytics/DungeonsAnalytics.toc"


class DiagnosticPackageTest(unittest.TestCase):
    def setUp(self):
        temporary = TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        self.repo = Path(temporary.name)
        self.git("init", "--quiet")
        self.git("config", "user.email", "fixture@example.invalid")
        self.git("config", "user.name", "Packaging fixture")
        self.write(MANIFEST, HEADER + "UI\\Report.xml\nCore/Recorder.lua\n")
        self.write("addon/DungeonsAnalytics/Core/Recorder.lua", "return {}\n")
        self.write("addon/DungeonsAnalytics/UI/Report.xml", "<Ui/>\n")
        self.write("addon/DungeonsAnalytics/notes.md", "Exclude undeclared files.\n")
        self.write("LICENSE", "License fixture.\n")
        self.write("NOTICE", "Creator fixture.\n")
        self.commit()

    def git(self, *args):
        return subprocess.run(
            ["git", *args], cwd=self.repo, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE
        ).stdout.decode("ascii").strip()

    def write(self, path, text):
        target = self.repo / path
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(text.encode("utf-8"))

    def commit(self):
        self.git("add", "--all")
        self.git("commit", "--quiet", "--message", "Fixture contents")

    def test_package_reproducibility_and_exact_content(self):
        commit = self.git("rev-parse", "HEAD")
        first = pack_commit(self.repo, commit)
        self.write("addon/DungeonsAnalytics/Core/Recorder.lua", "return 'uncommitted'\n")
        second = pack_commit(self.repo, "HEAD")
        self.assertEqual(first.data, second.data)
        self.assertEqual(first.digest, second.digest)
        self.assertEqual(first.commit, commit)
        self.assertEqual(first.interface, "16001")
        self.assertEqual(first.version, "0.1.0-dev")
        self.assertEqual(first.name, f"DungeonsAnalytics-diagnostic-{commit[:12]}.zip")
        with ZipFile(BytesIO(first.data)) as archive:
            self.assertEqual(
                archive.namelist(),
                [
                    "DungeonsAnalytics/Core/Recorder.lua",
                    "DungeonsAnalytics/DungeonsAnalytics.toc",
                    "DungeonsAnalytics/LICENSE",
                    "DungeonsAnalytics/NOTICE",
                    "DungeonsAnalytics/UI/Report.xml",
                ],
            )
            self.assertEqual(archive.read("DungeonsAnalytics/Core/Recorder.lua"), b"return {}\n")
            self.assertEqual(archive.read("DungeonsAnalytics/LICENSE"), b"License fixture.\n")
            self.assertEqual(archive.read("DungeonsAnalytics/NOTICE"), b"Creator fixture.\n")
            self.assertIsNone(archive.testzip())
        output = write_archive(first, self.repo / "output")
        self.assertEqual(output.read_bytes(), first.data)

    def test_missing_file_and_attribution_fail(self):
        self.write(MANIFEST, HEADER + "Missing.lua\n")
        self.commit()
        with self.assertRaisesRegex(ValueError, "Missing committed regular file.*Missing.lua"):
            pack_commit(self.repo, "HEAD")
        self.write(MANIFEST, HEADER + "Core/Recorder.lua\n")
        (self.repo / "NOTICE").unlink()
        self.commit()
        with self.assertRaisesRegex(ValueError, "Missing committed regular file.*NOTICE"):
            pack_commit(self.repo, "HEAD")

    def test_invalid_and_colliding_entries_fail(self):
        for entry in ("../Else.lua", "/Root.lua", "C:\\Root.lua", "Core//Recorder.lua", "Core/AUX.lua"):
            with self.subTest(entry=entry):
                with self.assertRaises(ValueError):
                    read_manifest((HEADER + entry).encode("utf-8"))
        with self.assertRaisesRegex(ValueError, "Duplicate or case-colliding"):
            read_manifest((HEADER + "Core/Recorder.lua\ncore/recorder.LUA").encode("utf-8"))
        with self.assertRaisesRegex(ValueError, "valid Version metadata"):
            read_manifest(b"## Interface: 16001\nCore/Recorder.lua\n")
