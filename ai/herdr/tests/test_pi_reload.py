"""Reload routing/clear-order tests; never send input to live panes."""

import contextlib
import copy
import io
import json
import os
from pathlib import Path
import runpy
import unittest
from unittest.mock import patch

HELPER = Path(__file__).resolve().parents[1] / "scripts" / "herdr-pi-reload"
main = runpy.run_path(str(HELPER))["main"]
request = main.__globals__["request"]


def pane(agent="pi", status="idle"):
    return {"pane_id": "w1:p1", "agent": agent, "agent_status": status,
            "terminal_id": "term1", "agent_session": {"value": "chat1"}}


class ReloadTests(unittest.TestCase):
    def setUp(self):
        # Same public handle in different sessions must not collide.
        self.panes = {s: [pane()] for s in ("default", "arbitrary-name", "float")}
        self.drafts = {s: "first line\nsecond line" for s in self.panes}
        self.calls = []
        self.foreground = "pi"
        self.fail_clear = False
        self.change_after_clear = False

    def reply(self, *args):
        self.calls.append(args)
        if args == ("session", "list", "--json"):
            return {"sessions": [{"name": s, "running": True} for s in self.panes]
                    + [{"name": "stopped", "running": False}]}
        self.assertEqual(args[0], "--session")
        session, operation = args[1], args[2:]
        if operation[:2] == ("notification", "show"):
            return {}
        if operation == ("pane", "list"):
            return {"panes": copy.deepcopy(self.panes[session])}
        if operation[:2] == ("pane", "process-info"):
            return {"process_info": {"foreground_processes": [{"argv0": self.foreground}]}}
        if operation[:2] == ("pane", "send-keys"):
            self.assertEqual(operation[3:], ("ctrl+c",))
            if self.fail_clear:
                raise RuntimeError("clear failed")
            self.drafts[session] = ""
            if self.change_after_clear:
                self.panes[session][0]["agent_session"] = {"value": "different-chat"}
            return {}
        if operation[:2] == ("pane", "run"):
            self.assertEqual(operation[3:], ("/reload",))
            self.assertEqual(self.drafts[session], "", "must clear entire draft before submission")
            self.drafts[session] = "/reload"
            return {}
        self.fail(f"unexpected request: {args}")

    def run_helper(self, *args):
        output = io.StringIO()
        with patch.dict(main.__globals__, request=self.reply), patch("time.sleep") as sleep, \
                contextlib.redirect_stdout(output), contextlib.redirect_stderr(output):
            result = main(list(args))
        return result, output.getvalue(), sleep

    def mutations(self):
        return [c for c in self.calls if len(c) > 3 and c[3] in ("run", "send-keys")]

    def test_all_running_sessions_and_multiline_drafts(self):
        result, output, sleep = self.run_helper()
        self.assertEqual(result, 0)
        self.assertIn("sent=3 skipped=0 failed=0", output)
        self.assertEqual([c[1] for c in self.mutations()],
                         ["default", "default", "arbitrary-name", "arbitrary-name", "float", "float"])
        self.assertEqual([c.args[0] for c in sleep.call_args_list], [0.6, 0.15] * 3)

    def test_empty_draft_still_gets_only_one_clear(self):
        self.drafts["default"] = ""
        self.run_helper("--session", "default")
        self.assertEqual(len(self.mutations()), 2)

    def test_dry_run_sends_no_input(self):
        _, output, sleep = self.run_helper("--dry-run")
        self.assertIn("eligible=3", output)
        self.assertEqual(self.mutations(), [])
        sleep.assert_not_called()

    def test_explicit_sessions_are_repeatable_and_deduplicated(self):
        self.run_helper("--session", "float", "--session", "float", "--session", "default")
        self.assertEqual([c[1] for c in self.mutations()], ["default", "default", "float", "float"])

    def test_non_pi_and_busy_or_unknown_are_not_touched(self):
        for agent, state in (("claude", "idle"), (None, "idle"), ("pi", "working"),
                             ("pi", "blocked"), ("pi", "unknown"), ("pi", None)):
            with self.subTest(agent=agent, state=state):
                self.panes = {"only": [pane(agent, state)]}
                self.run_helper()
                self.assertEqual(self.mutations(), [])

    def test_done_is_eligible_but_suspended_pi_is_not(self):
        self.panes["default"][0]["agent_status"] = "done"
        self.run_helper("--session", "default", "--dry-run")
        self.foreground = "zsh"
        _, output, _ = self.run_helper("--session", "default")
        self.assertIn("skipped=1", output)
        self.assertEqual(self.mutations(), [])

    def test_clear_failure_never_submits_and_reports_failure(self):
        self.fail_clear = True
        result, output, _ = self.run_helper("--session", "default")
        self.assertEqual(result, 1)
        self.assertIn("clear failed", output)
        self.assertEqual([c[3] for c in self.mutations()], ["send-keys"])

    def test_identity_change_after_clear_never_submits(self):
        self.change_after_clear = True
        result, _, _ = self.run_helper("--session", "default")
        self.assertEqual(result, 1)
        self.assertEqual([c[3] for c in self.mutations()], ["send-keys"])

    def test_state_change_during_quiet_interval_is_skipped(self):
        def become_busy(_):
            self.panes["default"][0]["agent_status"] = "working"
        with patch.dict(main.__globals__, request=self.reply), patch("time.sleep", side_effect=become_busy), \
                contextlib.redirect_stdout(io.StringIO()):
            self.assertEqual(main(["--session", "default"]), 0)
        self.assertEqual(self.mutations(), [])

    def test_stopped_or_unknown_session_rejected_before_mutations(self):
        for name in ("stopped", "missing"):
            with self.subTest(name=name), self.assertRaises(SystemExit):
                self.run_helper("--session", name)
        self.assertEqual(self.mutations(), [])

    def test_confirmation_defaults_to_cancel_without_input(self):
        for answer in ("", "n", "no", "anything else"):
            with self.subTest(answer=answer), patch("sys.stdin.isatty", return_value=True), \
                    patch("builtins.input", return_value=answer):
                result, output, _ = self.run_helper("--confirm")
                self.assertEqual(result, 0)
                self.assertIn("Cancelled", output)
                self.assertEqual(self.mutations(), [])

    def test_confirmation_eof_and_interrupt_cancel(self):
        for error in (EOFError, KeyboardInterrupt):
            with self.subTest(error=error), patch("sys.stdin.isatty", return_value=True), \
                    patch("builtins.input", side_effect=error):
                result, _, _ = self.run_helper("--confirm")
                self.assertEqual(result, 0)
                self.assertEqual(self.mutations(), [])

    def test_confirmation_requires_a_terminal(self):
        with patch("sys.stdin.isatty", return_value=False), self.assertRaises(SystemExit):
            self.run_helper("--confirm")
        self.assertEqual(self.calls, [])

    def test_confirmation_runs_and_notifies_invoking_session(self):
        with patch("sys.stdin.isatty", return_value=True), \
                patch("builtins.input", side_effect=["yes", ""]) as prompt, \
                patch.dict(os.environ, {"HERDR_SESSION": "arbitrary-name"}):
            result, output, _ = self.run_helper("--confirm")
        self.assertEqual(result, 0)
        self.assertIn("drafts", output)
        self.assertEqual(len(self.mutations()), 6)
        self.assertEqual(prompt.call_count, 2)
        self.assertEqual(self.calls[-1], (
            "--session", "arbitrary-name", "notification", "show", "Pi reload: input sent",
            "--body", "sent=3 skipped=0 failed=0",
        ))

    def test_popup_dry_run_only_waits_to_close(self):
        with patch("sys.stdin.isatty", return_value=True), patch("builtins.input", return_value="") as prompt:
            self.run_helper("--confirm", "--dry-run")
        self.assertEqual(self.mutations(), [])
        prompt.assert_called_once_with("\nPress Enter to close.")

    def test_silent_success_from_real_cli_input_commands(self):
        # Herdr send-keys/run succeed with exit 0 and no stdout, not JSON.
        for operation, value in (("send-keys", "ctrl+c"), ("run", "/reload")):
            with self.subTest(operation=operation), patch("subprocess.check_output", return_value=""):
                self.assertEqual(request("--session", "test", "pane", operation, "w1:p1", value), {})

    def test_nonzero_exit_is_not_silent_success(self):
        import subprocess
        with patch("subprocess.check_output", side_effect=subprocess.CalledProcessError(1, "herdr")):
            with self.assertRaises(subprocess.CalledProcessError):
                request("--session", "test", "pane", "send-keys", "w1:p1", "ctrl+c")

    def test_request_clears_inherited_routing_and_checks_api_errors(self):
        env = {"HERDR_BIN": "/custom/herdr", "HERDR_SESSION": "wrong",
               "HERDR_SOCKET_PATH": "/wrong.sock", "HERDR_PANE_ID": "wrong", "HOME": "/home/test"}
        with patch.dict(os.environ, env, clear=True), patch("subprocess.check_output") as cli:
            cli.return_value = json.dumps({"result": {"panes": []}})
            self.assertEqual(request("--session", "chosen", "pane", "list"), {"panes": []})
            self.assertEqual(cli.call_args.args[0], ["/custom/herdr", "--session", "chosen", "pane", "list"])
            self.assertEqual(cli.call_args.kwargs["env"], {"HOME": "/home/test"})
            cli.return_value = json.dumps({"error": {"code": "unavailable"}})
            with self.assertRaisesRegex(RuntimeError, "unavailable"):
                request("pane", "list")


if __name__ == "__main__":
    unittest.main()
