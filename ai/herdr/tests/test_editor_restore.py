"""Test editor startup and resurrect with a fake Herdr; never touch live panes."""

import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
COMMAND = '"${EDITOR:-nvim}" -S Session.vim'
MOCK = '''#!/usr/bin/env python3
import json, os, sys
args = sys.argv[1:]
with open(os.environ["CALLS"], "a") as log:
    log.write(json.dumps(args) + "\\n")
pid = int(os.environ.get("ROOT_SHELL_PID", "123"))
mode = os.environ.get("MODE", "idle")
if args[:2] == ["pane", "get"]:
    result = {"pane": {"label": os.environ.get("LABEL", "editor"),
                       "agent_status": "unknown"}}
elif args[:2] == ["pane", "process-info"]:
    process = {"pid": pid, "argv0": "zsh", "name": "zsh", "cwd": os.getcwd()}
    if mode == "nvim":
        process.update(pid=pid + 1, argv0="nvim", name="nvim",
                       argv=["/removed/version/bin/nvim", "old-file"])
    elif mode == "busy":
        process.update(pid=pid + 1, argv0="btop", name="btop")
    result = {"process_info": {"shell_pid": pid + (mode == "nested"),
                               "foreground_processes": [process]}}
elif args[:2] == ["pane", "list"]:
    result = {"panes": [{"pane_id": "editor-pane"}]}
else:
    result = {"agents": []}
print(json.dumps({"result": result}))
'''


class EditorRestoreTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.home = Path(self.tmp.name)
        self.herdr = self.home / "herdr"
        self.herdr.write_text(MOCK)
        self.herdr.chmod(0o755)
        self.log = self.home / "calls.jsonl"
        self.state = self.home / "resurrect.json"
        self.env = dict(os.environ, HOME=str(self.home),
                        PATH=f"{self.home}:{os.environ['PATH']}",
                        XDG_STATE_HOME=str(self.home),
                        HERDR_ENV="1", HERDR_PANE_ID="editor-pane",
                        HERDR_BIN=str(self.herdr), CALLS=str(self.log),
                        HERDR_RESURRECT_FILE=str(self.state),
                        HERDR_RESURRECT_CLEAR_IDLE="0")

    def calls(self, action):
        return [call for call in map(json.loads, self.log.read_text().splitlines())
                if call[:2] == ["pane", action]]

    def startup(self, **env):
        subprocess.run(["bash", "-c",
                        'export ROOT_SHELL_PID=$$; source "$1"; wait',
                        "test", str(ROOT / "default_pane_title.sh")],
                       env=dict(self.env, **env), cwd=self.home, check=True,
                       capture_output=True, text=True)

    def resurrect(self, action, **env):
        return subprocess.run(["bash", str(ROOT / "scripts/herdr-resurrect"), action],
                              env=dict(self.env, **env), cwd=self.home,
                              check=True, capture_output=True, text=True)

    def test_zsh_defers_worker_until_first_prompt_and_runs_it_once(self):
        subprocess.run(["zsh", "-f", "-c", '''
            precmd_functions=(existing_hook)
            existing_hook() { :; }
            source "$1"
            [[ ! -e "$CALLS" ]] || exit 1
            _herdr_default_pane_title() { printf 'dispatched\\n' >> "$CALLS"; }
            for hook in "${precmd_functions[@]}"; do "$hook"; done
            [[ "${precmd_functions[*]}" == existing_hook ]] || exit 1
            for hook in "${precmd_functions[@]}"; do "$hook"; done
        ''', "test", str(ROOT / "default_pane_title.sh")], env=self.env,
                       cwd=self.home, check=True, capture_output=True, text=True)
        self.assertEqual(self.log.read_text(), "dispatched\n")

    def test_editor_starts_without_saved_state(self):
        self.startup(EDITOR="/custom/editor with spaces")
        self.assertEqual(self.calls("run"), [["pane", "run", "editor-pane", COMMAND]])
        self.assertEqual(self.calls("rename"), [])

    def test_editor_starts_even_if_old_state_has_an_entry(self):
        self.state.write_text(json.dumps({"commands": [{"pane_id": "editor-pane"}]}))
        self.startup()
        self.assertEqual(len(self.calls("run")), 1)

    def test_busy_and_nested_shells_do_not_start_editor(self):
        for mode in ("busy", "nvim", "nested"):
            with self.subTest(mode=mode):
                self.startup(MODE=mode)
                self.assertEqual(self.calls("run"), [])

    def test_other_panes_do_not_start_editor(self):
        self.startup(LABEL="terminal")
        self.assertEqual(self.calls("run"), [])

    def test_save_uses_editor_variable_not_versioned_path(self):
        self.resurrect("save", MODE="nvim", EDITOR="do-not-expand-here")
        self.assertEqual(json.loads(self.state.read_text())["commands"][0]["command"], COMMAND)

    def test_restore_normalizes_legacy_command_and_skips_busy_panes(self):
        self.state.write_text(json.dumps({"commands": [{
            "pane_id": "editor-pane", "kind": "nvim", "cwd": str(self.home),
            "command": "'/removed/version/bin/nvim' 'old-file'",
        }]}))
        self.resurrect("restore", MODE="busy")
        self.assertEqual(self.calls("run"), [])
        self.resurrect("restore")
        self.assertEqual(self.calls("run"), [[
            "pane", "run", "editor-pane", f"cd {self.home} && {COMMAND}",
        ]])

    def test_command_falls_back_and_preserves_quoted_editor(self):
        for editor in (None, "", str(self.home / "custom editor")):
            with self.subTest(editor=editor):
                executable = self.home / ("nvim" if not editor else "custom editor")
                executable.write_text('#!/bin/sh\nprintf "%s\\n" "$@"\n')
                executable.chmod(0o755)
                env = dict(self.env)
                env.pop("EDITOR", None)
                if editor is not None:
                    env["EDITOR"] = editor
                result = subprocess.run(["sh", "-c", COMMAND], env=env,
                                        check=True, capture_output=True, text=True)
                self.assertEqual(result.stdout, "-S\nSession.vim\n")


if __name__ == "__main__":
    unittest.main()
