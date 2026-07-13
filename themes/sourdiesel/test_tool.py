from __future__ import annotations

import copy
import sys
import tempfile
import unittest
from pathlib import Path


sys.path.insert(0, str(Path(__file__).resolve().parent))

import tool  # noqa: E402


class SourDieselToolTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.manifest = tool.load_manifest()
        cls.colors = tool.palette_colors(cls.manifest)
        cls.by_name, cls.by_hex, cls.by_index = tool.palette_maps(cls.colors)

    def test_hex_is_case_insensitive_and_accepts_alpha_suffix(self) -> None:
        self.assertEqual(tool.normalize_hex("#EcCeF0"), "#eccef0")
        self.assertEqual(tool.resolve_hex("#EcCeF031", self.by_hex), "magenta")

    def test_ansi_aliases_and_numeric_slots(self) -> None:
        self.assertEqual(
            tool.normalize_ansi_token("bright-red", self.by_index), "brightred"
        )
        self.assertEqual(tool.normalize_ansi_token("08", self.by_index), "brightblack")
        self.assertEqual(tool.normalize_ansi_token("15", self.by_index), "brightwhite")

    def test_lua_theme_references_are_extracted(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "theme.lua"
            path.write_text(
                "Thing = { fg = thm.brightred, bg = thm.grey }\n", encoding="utf-8"
            )
            usages = tool.scan_lua([path], set(self.by_name))
        self.assertEqual([usage.color for usage in usages], ["brightred", "grey"])
        self.assertEqual(usages[0].role, "Thing")

    def test_environment_palette_references_are_extracted(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "config"
            path.write_text(
                'color="$BRIGHTMAGENTA_HEX"\nbackground="$WEZTERM_BG_HEX"\n',
                encoding="utf-8",
            )
            usages = tool.scan_env([path], set(self.by_name))
        self.assertEqual(
            [usage.color for usage in usages], ["brightmagenta", "terminal_surface"]
        )

    def test_eva_numeric_slots_and_qualified_mappings(self) -> None:
        content = """\
extensions:
  cache:
    filename:
      foreground: 08
  py:
    filename:
      foreground: 15
"""
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "theme.yml"
            path.write_text(content, encoding="utf-8")
            usages, mappings, errors = tool.scan_eva(path, self.by_index)
        self.assertEqual(errors, [])
        self.assertEqual(
            [usage.color for usage in usages], ["brightblack", "brightwhite"]
        )
        self.assertEqual(
            mappings,
            {"extensions:cache": "brightblack", "extensions:py": "brightwhite"},
        )

    def test_legacy_exception_baseline_rejects_new_and_stale_values(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            path = root / "consumer.conf"
            path.write_text('color = "#123456"\n', encoding="utf-8")
            manifest = copy.deepcopy(self.manifest)
            manifest["consumers"] = [
                {
                    "id": "fixture",
                    "label": "Fixture",
                    "group": "Tests",
                    "paths": ["consumer.conf"],
                    "parser": "hex",
                    "allowed_hex": ["#123456"],
                    "legacy_reason": "test fixture",
                }
            ]
            self.assertEqual(tool.build_inventory(manifest, root).errors, [])
            manifest["consumers"][0]["allowed_hex"] = []
            self.assertIn(
                "fixture: unapproved colors: #123456",
                tool.build_inventory(manifest, root).errors,
            )
            manifest["consumers"][0]["allowed_hex"] = ["#654321"]
            errors = tool.build_inventory(manifest, root).errors
            self.assertIn("fixture: unapproved colors: #123456", errors)
            self.assertIn("fixture: stale legacy colors: #654321", errors)

    def test_eva_webdevicons_parity_uses_extension_precedence(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "eva.yml").write_text(
                """\
filenames:
  log:
    filename:
      foreground: blue
extensions:
  log:
    filename:
      foreground: red
""",
                encoding="utf-8",
            )
            (root / "icons.lua").write_text(
                "['log'] = { name = 'FixtureLog', color = thm.red }\n",
                encoding="utf-8",
            )
            manifest = copy.deepcopy(self.manifest)
            manifest["consumers"] = [
                {
                    "id": "eva",
                    "label": "eva",
                    "group": "Tests",
                    "paths": ["eva.yml"],
                    "parser": "eva",
                },
                {
                    "id": "webdevicons",
                    "label": "web-devicons",
                    "group": "Tests",
                    "paths": ["icons.lua"],
                    "parser": "webdevicons",
                },
            ]
            self.assertEqual(tool.build_inventory(manifest, root).errors, [])
            (root / "icons.lua").write_text(
                "['log'] = { name = 'FixtureLog', color = thm.green }\n",
                encoding="utf-8",
            )
            self.assertIn(
                "eva/web-devicons: log is red in eva and green in web-devicons",
                tool.build_inventory(manifest, root).errors,
            )

    def test_webdevicons_rejects_reserved_highlight_names_case_insensitively(
        self,
    ) -> None:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "icons.lua"
            path.write_text(
                "['lua'] = { name = 'lua', color = thm.brightwhite }\n",
                encoding="utf-8",
            )
            _, _, errors = tool.scan_webdevicons(path, ["Lua"])
        self.assertEqual(
            errors,
            [
                "webdevicons: lua uses reserved highlight name lua; "
                "use a unique SourDiesel name"
            ],
        )

    def test_report_drift_is_detected(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            report = Path(directory) / "README.md"
            report.write_text("old\n", encoding="utf-8")
            self.assertTrue(tool.check_report("new\n", report))
            report.write_text("new\n", encoding="utf-8")
            self.assertEqual(tool.check_report("new\n", report), [])


if __name__ == "__main__":
    unittest.main()
