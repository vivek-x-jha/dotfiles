"""Exercise smart swaps with mocked CLI replies, never live panes."""

import json
import os
from pathlib import Path
import runpy
import subprocess
import unittest
from unittest.mock import patch

HELPER = Path(__file__).resolve().parents[1] / "scripts" / "herdr-smart-swap"
main = runpy.run_path(str(HELPER))["main"]


class SmartSwapTests(unittest.TestCase):
    def run_swap(self, neighbor=None, env=None, reason="no_neighbor"):
        calls = []

        def reply(command, **kwargs):
            calls.append(command)
            if command[1:] == ["pane", "current"]:
                result = {"pane": {"pane_id": "focused"}}
            else:
                changed = command[-1] == neighbor
                result = {"swap": {"changed": changed, "reason": None if changed else reason}}
            return json.dumps({"result": result})

        with patch.dict(os.environ, env or {}, clear=True), patch(
            "subprocess.check_output", side_effect=reply
        ):
            main()
        return calls

    def test_both_orientations_from_either_side(self):
        directions = ["down", "right", "up", "left"]
        for index, neighbor in enumerate(directions):
            with self.subTest(neighbor=neighbor):
                calls = self.run_swap(neighbor, {"HERDR_PANE_ID": "source"})
                self.assertEqual([call[-1] for call in calls], directions[:index + 1])
                self.assertTrue(all(call[3:5] == ["--pane", "source"] for call in calls))

    def test_single_pane_is_noop(self):
        calls = self.run_swap(env={"HERDR_PANE_ID": "solo"})
        self.assertEqual([call[-1] for call in calls], ["down", "right", "up", "left"])

    def test_explicit_pane_and_binary_are_used(self):
        calls = self.run_swap("down", {
            "HERDR_PANE_ID": "source", "HERDR_BIN_PATH": "/custom/herdr",
        })
        self.assertEqual(calls, [["/custom/herdr", "pane", "swap", "--pane", "source", "--direction", "down"]])

    def test_missing_context_pins_focused_pane(self):
        calls = self.run_swap("right")
        self.assertEqual(calls[0], ["herdr", "pane", "current"])
        self.assertTrue(all(call[3:5] == ["--pane", "focused"] for call in calls[1:]))

    def test_non_neighbor_errors_stop_instead_of_trying_other_directions(self):
        with self.assertRaisesRegex(RuntimeError, "not_found"):
            self.run_swap(env={"HERDR_PANE_ID": "gone"}, reason="not_found")

    def test_cli_failure_is_not_treated_as_missing_neighbor(self):
        with patch.dict(os.environ, {"HERDR_PANE_ID": "source"}, clear=True), patch(
            "subprocess.check_output", side_effect=subprocess.CalledProcessError(1, "herdr")
        ) as cli:
            with self.assertRaises(subprocess.CalledProcessError):
                main()
            self.assertEqual(cli.call_count, 1)


if __name__ == "__main__":
    unittest.main()
