// Run with: node ai/pi/tests/bash-python.mjs (renders only; never executes fixtures).
import assert from "node:assert/strict";
import { execFileSync } from "node:child_process";
import { createRequire } from "node:module";
import { join } from "node:path";
import { fileURLToPath } from "node:url";

const packageRoot = join(execFileSync("npm", ["root", "-g"], { encoding: "utf8" }).trim(), "@earendil-works/pi-coding-agent");
const require = createRequire(join(packageRoot, "package.json"));
const { createJiti } = require("jiti");
const jiti = createJiti(import.meta.url, {
  alias: {
    "@earendil-works/pi-coding-agent": join(packageRoot, "dist/index.js"),
    "@earendil-works/pi-tui": require.resolve("@earendil-works/pi-tui"),
  },
});
const { ToolExecutionComponent } = await jiti.import(join(packageRoot, "dist/index.js"));
const { visibleWidth } = await jiti.import(require.resolve("@earendil-works/pi-tui"));
const themes = await jiti.import(join(packageRoot, "dist/modes/interactive/theme/theme.js"));
const themePath = fileURLToPath(new URL("../themes/sourdiesel.json", import.meta.url));
const theme = themes.loadThemeFromPath(themePath, "truecolor");
themes.setThemeInstance(theme);
const { createShellRenderers } = await jiti.import(join(packageRoot, "dist/core/tools/renderers/bash.js"));
const { default: extension } = await jiti.import(fileURLToPath(new URL("../extensions/statusline.ts", import.meta.url)));
let resolver;
extension({ on() {}, registerCommand() {}, registerToolRenderer(value) { resolver = value; } });
const native = createShellRenderers("$");
const renderers = resolver("bash", () => native);
assert.equal(renderers.renderResult, native.renderResult, "Keep native stdout/stderr rendering");
assert.equal(resolver("read", () => native), native, "Leave other tool renderers alone");

const plain = (line) => line.replace(/\x1b\][^\x07\x1b]*(?:\x07|\x1b\\)/g, "").replace(/\x1b\[[0-?]*[ -/]*[@-~]/g, "");
const color = (hex) => `\x1b[38;2;${hex.match(/../g).map((part) => parseInt(part, 16)).join(";")}m`;
const keyword = color("eccef0");
const string = color("ceffc9");
const number = color("fdf7cd");
const comment = color("5c617d");
const code = 'import os\n# a comment\nprint("hello", 42)';
const fixtures = [
  `python3 - <<'PY'\n${code}\nPY`,
  `python <<"CODE"\n${code}\nCODE`,
  `python3 <<EOF\n${code}\nEOF`,
  `cd /tmp && /usr/bin/python3.12 -u - <<'PY'\n${code}\nPY\nprintf done`,
  `env PYTHONUTF8=1 python3 - <<'PY'\n${code}\nPY`,
  `uv run python3 - <<'PY'\n${code}\nPY`,
  `python3 <<-'PY'\n\t${code.replaceAll("\n", "\n\t")}\n\tPY`,
  `python3 -c '${code}'`,
  'python -c "import os; print(\\"hello\\", 42) # a comment"',
  `python3 - <<'PY'\n${code}`, // A partially streamed command has no closing delimiter yet.
  `python3 - <<'PY'\n${code}\nprint("界面 👋")\nPY`,
];
const makeTool = (command) => new ToolExecutionComponent("bash", "test", { command, timeout: 30 }, { outputPad: 1 }, renderers, { requestRender() {} }, process.cwd());
for (const command of fixtures) {
  const tool = makeTool(command);
  for (const width of [1, 2, 3, 8, 20, 40, 80, 140]) {
    const lines = tool.render(width);
    assert.ok(lines.every((line) => visibleWidth(line) <= width), `Overflow at width ${width}`);
  }
  const rendered = tool.render(140).join("\n");
  assert.equal(tool.args.command, command, "Highlighting must not change execution arguments");
  assert.ok(rendered.includes(`${keyword}import`), `No Python keywords: ${command}`);
  assert.ok(rendered.includes(`${string}"hello"`), `No Python string color: ${command}`);
  assert.ok(rendered.includes(`${number}42`), `No Python number color: ${command}`);
  assert.ok(rendered.includes(`${comment}# a comment`), `No Python comment color: ${command}`);
  assert.equal(plain(rendered).match(/import os/g)?.length, 1, "Do not leave duplicate blue command lines");
  assert.ok(plain(rendered).includes("timeout 30s"));
  tool.updateResult({ content: [{ type: "text", text: "OUTPUT_SENTINEL import stdout" }], details: undefined, durationMs: 1000 }, false);
  for (const expanded of [false, true]) {
    tool.setExpanded(expanded);
    const output = tool.render(80).join("\n");
    assert.ok(plain(output).includes("OUTPUT_SENTINEL import stdout"));
    assert.ok(!output.includes(`${keyword}import stdout`), "Do not syntax-highlight ordinary output");
  }
}

for (const command of [
  "echo hello",
  "echo 'python3 -c import os'",
  "python3 script.py -c 'import os'",
  "python3 -m module -c 'import os'",
  "python3 -c \"print('$HOME')\"", // Shell expansions are not evaluated for the preview.
  "cat <<'EOF'\npython3 -c 'import os'\nEOF",
  "python3 <<'A' <<'B'\nimport os\nA\nother input\nB",
  "python3 -c 'import", // Partial quoted inline code falls back without throwing.
  `python3 -c 'import os'"'"'other code'`, // Concatenated shell literals are left intact.
]) {
  const rendered = makeTool(command).render(140).join("\n");
  assert.ok(!rendered.includes(`${keyword}import`), `Unexpected Python parsing: ${command}`);
}

const repeated = makeTool(`python3 <<'PY'\n${code}\n# Don't lex Python comments as shell quotes.\nPY\npython3 -c 'import sys; print(7)'`);
assert.ok(repeated.render(140).join("\n").includes(`${keyword}import\x1b[39m sys`));
const timed = makeTool("echo hello");
timed.markExecutionStarted();
assert.equal(typeof timed.rendererState.startedAt, "number", "Keep the native execution timer");
timed.updateResult({ content: [{ type: "text", text: "hello" }], details: undefined, durationMs: 1000 }, false);
assert.ok(plain(timed.render(80).join("\n")).includes("Took 1.0s"));
const updated = makeTool("python3 -c 'import os'");
updated.updateArgs({ command: "python3 -c 'from pathlib import Path'" });
assert.ok(plain(updated.render(140).join("\n")).includes("from pathlib import Path"));
assert.ok(!plain(updated.render(140).join("\n")).includes("import os"));
const otherTheme = themes.getThemeByName("dark");
themes.setThemeInstance(otherTheme);
updated.invalidate();
const themed = updated.render(140).join("\n");
assert.ok(themed.includes(otherTheme.fg("syntaxKeyword", "from")), "Re-highlight after theme changes");
themes.setThemeInstance(theme);
console.log("Bash/Python rendering passed: heredocs, -c, fallback, widths, outputs, argument updates, and theme changes.");
