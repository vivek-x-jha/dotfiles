// Run with: node ai/pi/tests/keybindings.mjs (uses synthetic sessions only).
import assert from "node:assert/strict";
import { execFileSync } from "node:child_process";
import { createRequire } from "node:module";
import { join } from "node:path";
import { fileURLToPath } from "node:url";

const packageRoot = join(execFileSync("npm", ["root", "-g"], { encoding: "utf8" }).trim(), "@earendil-works/pi-coding-agent");
const require = createRequire(join(packageRoot, "package.json"));
const { KeybindingsManager } = await import(join(packageRoot, "dist/core/keybindings.js"));
const { setKeybindings, stripTerminalSequences } = await import(require.resolve("@earendil-works/pi-tui"));
const { initTheme } = await import(join(packageRoot, "dist/modes/interactive/theme/theme.js"));
const { SessionSelectorComponent } = await import(join(packageRoot, "dist/modes/interactive/components/session-selector.js"));
const { keyDisplayText } = await import(join(packageRoot, "dist/modes/interactive/components/keybinding-hints.js"));
const { createJiti } = require("jiti");
const jiti = createJiti(import.meta.url, { alias: {
  "@earendil-works/pi-coding-agent": join(packageRoot, "dist/index.js"),
  "@earendil-works/pi-tui": require.resolve("@earendil-works/pi-tui"),
} });
const { configurePlatformChatNavigation } = await jiti.import(fileURLToPath(new URL("../extensions/statusline.ts", import.meta.url)));
const configPath = fileURLToPath(new URL("../keybindings.json", import.meta.url));
const config = KeybindingsManager.loadFromFile(configPath);
const bindings = new KeybindingsManager(config, configPath);
setKeybindings(bindings);
initTheme("dark");

assert.equal(config["tui.altScreen.bottom"], undefined, "Keep platform-specific navigation out of shared JSON");
const platformDescriptor = Object.getOwnPropertyDescriptor(process, "platform");
const withoutChatBottom = () => Object.fromEntries(Object.entries(bindings.getResolvedBindings()).filter(([key]) => key !== "tui.altScreen.bottom"));
const unchangedBindings = withoutChatBottom();
try {
  for (const [platform, key, label] of [
    ["darwin", "ctrl+alt+g", "Ctrl+Option+G"],
    ["win32", "ctrl+end", "Ctrl+End"],
    ["linux", "ctrl+end", "Ctrl+End"],
  ]) {
    Object.defineProperty(process, "platform", { value: platform });
    configurePlatformChatNavigation();
    configurePlatformChatNavigation();
    for (let reload = 0; reload < 2; reload++) {
      // Pi reloads JSON after session_start; the platform default must survive.
      bindings.reload();
      assert.deepEqual(bindings.getKeys("tui.altScreen.bottom"), [key]);
      assert.equal(keyDisplayText("tui.altScreen.bottom"), label);
      assert.deepEqual(bindings.getUserBindings(), config, "Do not rewrite user bindings");
      assert.deepEqual(withoutChatBottom(), unchangedBindings, "Preserve every other action");
      for (const input of ["\x1b[103;7u", "\x1b[27;7;103~", "\x1b\x07"]) {
        assert.equal(bindings.matches(input, "tui.altScreen.bottom"), platform === "darwin");
        assert.ok(!bindings.matches(input, "app.editor.external"));
      }
      assert.equal(bindings.matches("\x1b[1;5F", "tui.altScreen.bottom"), platform !== "darwin");
      assert.ok(bindings.matches("\x07", "app.editor.external"), "Keep Ctrl+G for the external editor");
      assert.ok(!bindings.matches("\x07", "tui.altScreen.bottom"));
    }
  }
} finally {
  Object.defineProperty(process, "platform", platformDescriptor);
  configurePlatformChatNavigation();
}
assert.deepEqual(bindings.getKeys("tui.select.down"), ["down", "ctrl+n"]);
assert.deepEqual(bindings.getKeys("tui.select.up"), ["up", "ctrl+p"]);
assert.deepEqual(bindings.getKeys("app.session.togglePath"), ["ctrl+alt+p"]);
assert.deepEqual(bindings.getKeys("app.session.toggleNamedFilter"), ["ctrl+alt+n"]);
assert.deepEqual(bindings.getConflicts(), []);
assert.deepEqual(bindings.getKeys("app.model.cycleForward"), ["ctrl+p"], "Keep editor model cycling unchanged");
assert.ok(bindings.matches("\x1b[112;6u", "app.model.cycleBackward"));
for (const key of ["\x0e", "\x1b[110;5u"]) {
  assert.ok(bindings.matches(key, "tui.select.down"));
  assert.ok(!bindings.matches(key, "app.session.toggleNamedFilter"));
}
for (const key of ["\x10", "\x1b[112;5u"]) {
  assert.ok(bindings.matches(key, "tui.select.up"));
  assert.ok(!bindings.matches(key, "app.session.togglePath"));
}
const toggleNamed = "\x1b[110;7u";
const togglePath = "\x1b[112;7u";
for (const key of [toggleNamed, "\x1b[27;7;110~", "\x1b\x0e"]) {
  assert.ok(bindings.matches(key, "app.session.toggleNamedFilter"));
  assert.ok(!bindings.matches(key, "tui.select.down"));
}
for (const key of [togglePath, "\x1b[27;7;112~", "\x1b\x10"]) {
  assert.ok(bindings.matches(key, "app.session.togglePath"));
  assert.ok(!bindings.matches(key, "tui.select.up"));
}
assert.ok(!bindings.matches("\x1b[110;6u", "app.session.toggleNamedFilter"));
assert.ok(!bindings.matches("\x1b[112;6u", "app.session.togglePath"));

const sessions = ["first", "unnamed", "third"].map((id, index) => ({
  id, path: `/fixture/${id}.jsonl`, cwd: "/fixture",
  name: id === "unnamed" ? undefined : id,
  firstMessage: `${id} message`, messageCount: 1,
  created: new Date(Date.UTC(2026, 0, 3 - index)),
  modified: new Date(Date.UTC(2026, 0, 3 - index)),
}));
const loader = async () => sessions;
const selector = new SessionSelectorComponent(loader, loader, () => {}, () => {}, () => {}, () => {}, { keybindings: bindings, showRenameHint: false });
await new Promise(setImmediate);
const list = selector.getSessionList();
const rendered = () => selector.render(160).map(stripTerminalSequences).join("\n");
assert.equal(list.getSelectedSessionPath(), sessions[0].path);
selector.handleInput("\x0e");
assert.equal(list.getSelectedSessionPath(), sessions[1].path, "Ctrl+N moves down instead of filtering");
selector.handleInput("\x10");
assert.equal(list.getSelectedSessionPath(), sessions[0].path, "Ctrl+P moves up instead of toggling paths");
selector.handleInput("\x1b[B");
assert.equal(list.getSelectedSessionPath(), sessions[1].path);
selector.handleInput("\x1b[A");
assert.equal(list.getSelectedSessionPath(), sessions[0].path);
assert.ok(rendered().includes("path (off)"));
selector.handleInput(togglePath);
assert.ok(rendered().includes("path (on)"));
assert.ok(rendered().includes("/fixture/first.jsonl"));
selector.handleInput(togglePath);
assert.ok(rendered().includes("path (off)"));
assert.ok(rendered().includes("unnamed message"));
selector.handleInput(toggleNamed);
assert.ok(rendered().includes("Name: Named"));
assert.ok(!rendered().includes("unnamed message"));
selector.handleInput(toggleNamed);
assert.ok(rendered().includes("Name: All"));
assert.ok(rendered().includes("unnamed message"));
console.log("Pi keybindings passed: macOS/Windows/Linux chat keys and labels, reloads, legacy/CSI-u navigation, menu toggles, and unchanged editor shortcuts.");
