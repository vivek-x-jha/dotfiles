// Run with: node ai/pi/tests/tool-code-surfaces.mjs (renders synthetic tools; no file/tool execution).
import assert from "node:assert/strict";
import { execFileSync } from "node:child_process";
import { createRequire } from "node:module";
import { join } from "node:path";
import { fileURLToPath } from "node:url";

const packageRoot = join(execFileSync("npm", ["root", "-g"], { encoding: "utf8" }).trim(), "@earendil-works/pi-coding-agent");
const require = createRequire(join(packageRoot, "package.json"));
const { createJiti } = require("jiti");
const jiti = createJiti(import.meta.url, { alias: {
  "@earendil-works/pi-coding-agent": join(packageRoot, "dist/index.js"),
  "@earendil-works/pi-tui": require.resolve("@earendil-works/pi-tui"),
} });
const { ToolExecutionComponent } = await jiti.import(join(packageRoot, "dist/index.js"));
const { visibleWidth, stripTerminalSequences } = await jiti.import(require.resolve("@earendil-works/pi-tui"));
const themes = await jiti.import(join(packageRoot, "dist/modes/interactive/theme/theme.js"));
const theme = themes.loadThemeFromPath(fileURLToPath(new URL("../themes/sourdiesel.json", import.meta.url)), "truecolor");
themes.setThemeInstance(theme);
const { writeRenderers } = await jiti.import(join(packageRoot, "dist/core/tools/renderers/write.js"));
const { readRenderers } = await jiti.import(join(packageRoot, "dist/core/tools/renderers/read.js"));
const { editRenderers } = await jiti.import(join(packageRoot, "dist/core/tools/renderers/edit.js"));
const { createShellRenderers } = await jiti.import(join(packageRoot, "dist/core/tools/renderers/bash.js"));
const native = { write: writeRenderers, read: readRenderers, edit: editRenderers, bash: createShellRenderers("$") };
const { default: extension } = await jiti.import(fileURLToPath(new URL("../extensions/statusline.ts", import.meta.url)));
let resolver;
extension({ on() {}, registerCommand() {}, registerToolRenderer(value) { resolver = value; } });
const renderers = Object.fromEntries(Object.entries(native).map(([name, original]) => [name, resolver(name, () => original)]));
const makeTool = (name, args) => new ToolExecutionComponent(name, "fixture", args, { showImages: false, outputPad: 1 }, renderers[name], { requestRender() {} }, "/fixture");
const bg = `\x1b[48;2;${(process.env.NVIM_STATUSLINE_HEX ?? "#27283a").slice(1).match(/../g).map((part) => parseInt(part, 16)).join(";")}m`;
const plain = stripTerminalSequences;
const result = (text, details, isError = false) => ({ content: [{ type: "text", text }], details, isError });
const source = '# CODE_START\nimport os\n\nprint("hello 界面 👋", 42)\n' + Array.from({ length: 10 }, (_, i) => `# CODE_${i} a long line that wraps at narrow terminal widths`).join("\n");

function check(tool, sentinel) {
  for (const width of [1, 2, 3, 8, 20, 40, 80, 140]) {
    const lines = tool.render(width);
    assert.ok(lines.every((line) => visibleWidth(line) <= width), `Overflow: ${tool.toolName}, ${width}`);
    assert.deepEqual(tool.render(width), lines, "Repeated renders must not accumulate decoration");
  }
  const lines = tool.render(140);
  const code = lines.find((line) => plain(line).includes(sentinel));
  assert.ok(code?.includes(bg), `Missing code surface for ${tool.toolName}: ${sentinel}`);
  assert.ok(visibleWidth(code) > 100, "Keep the code surface's right padding");
  assert.ok(!lines[1].includes(bg), "Keep the tool header transparent");
  return lines;
}

const write = makeTool("write", { path: "/fixture/demo.py", content: source });
const collapsed = check(write, "CODE_START");
assert.ok(collapsed.some((line) => line.includes(bg) && plain(line).trim() === ""), "Shade blank code lines");
assert.ok(collapsed.filter((line) => plain(line).includes("more lines")).every((line) => !line.includes(bg)), "Keep truncation hints transparent");
assert.equal(collapsed.map(plain).join("\n").match(/CODE_START/g).length, 1);
write.setExpanded(true);
check(write, "CODE_9");
write.updateArgs({ path: "/fixture/demo.py", content: '# CHANGED\nprint("new")' });
check(write, "CHANGED");
write.updateResult(result("WRITE_ERROR", undefined, true), false);
assert.ok(write.render(140).filter((line) => plain(line).includes("WRITE_ERROR")).every((line) => !line.includes(bg)));
const longPath = makeTool("write", { path: `/fixture/${"nested/".repeat(30)}demo.py`, content: "# LONG_PATH\n\tprint(42)" });
check(longPath, "LONG_PATH");
const hintLikeCode = makeTool("write", { path: "/fixture/demo.txt", content: [...Array(9).fill("ordinary content"), "... (2 more lines, 12 total, ctrl+o to expand)"].join("\n") });
assert.ok(hintLikeCode.render(140).find((line) => plain(line).includes("more lines")).includes(bg), "Do not mistake file content for a truncation hint");
const invalidWrite = makeTool("write", { path: "/fixture/demo.py", content: 7 });
assert.ok(!invalidWrite.render(140).join("").includes(bg), "Do not shade invalid-argument errors");

const read = makeTool("read", { path: "/fixture/demo.py" });
read.updateResult(result(source), false);
assert.ok(!read.render(140).join("").includes(bg), "Collapsed reads have no file preview");
read.setExpanded(true);
check(read, "CODE_START");
read.updateResult(result(source, { truncation: { truncated: true, truncatedBy: "lines", outputLines: 14, totalLines: 200, maxLines: 14 } }), false);
check(read, "CODE_START");
assert.ok(read.render(140).filter((line) => plain(line).includes("[Truncated:")).every((line) => !line.includes(bg)));
read.setExpanded(false);
assert.ok(!read.render(140).join("").includes(bg));
read.setExpanded(true);
read.updateResult(result("READ_ERROR", undefined, true), false);
assert.ok(!read.render(140).join("").includes(bg), "Do not shade read errors");
const imageContext = { args: { path: "/fixture/image.png" }, expanded: true, showImages: false, isError: false, state: {}, cwd: "/fixture", outputPad: 0 };
const image = renderers.read.renderResult({ content: [{ type: "text", text: "image caption" }, { type: "image", mimeType: "image/png", data: "" }] }, { expanded: true, isPartial: false }, theme, imageContext);
assert.ok(!image.render(140).join("").includes(bg), "Do not shade image captions/placeholders");

const edit = makeTool("edit", { path: "/fixture/demo.py", edits: [{ oldText: "value = 1", newText: "value = 2" }] });
const diff = " 1 import os\n-2 value = 1\n+2 value = 2\n 3 print(value)";
// argsComplete stays false: seed the settled diff instead of starting a filesystem preview.
assert.equal(edit.argsComplete, false);
edit.updateResult(result("edited", { diff, firstChangedLine: 2 }), false);
const edited = check(edit, "-2 value");
assert.ok(edited.find((line) => plain(line).includes("-2 value")).includes(theme.getFgAnsi("toolDiffRemoved")));
assert.ok(edited.find((line) => plain(line).includes("+2 value")).includes(theme.getFgAnsi("toolDiffAdded")));
edit.setExpanded(true);
check(edit, "+2 value");
const failedEdit = makeTool("edit", { path: "/fixture/missing.py", edits: [] });
failedEdit.updateResult(result("EDIT_ERROR", undefined, true), false);
assert.ok(!failedEdit.render(140).join("").includes(bg));

const bash = makeTool("bash", { command: 'python3 - <<\'PY\'\n# PY_CODE\nimport os\n\nprint("hello", 42)\nPY\nprintf shell_tail' });
const python = check(bash, "PY_CODE");
for (const marker of ["python3", "shell_tail"]) {
  assert.ok(python.filter((line) => plain(line).includes(marker)).every((line) => line.includes(bg)), "Shade shell rows as well as Python");
}
bash.updateResult(result("BASH_STDOUT import os"), false);
assert.ok(bash.render(140).filter((line) => plain(line).includes("BASH_STDOUT")).every((line) => !line.includes(bg)));
const inline = makeTool("bash", { command: 'python3 -c \'print("INLINE_CODE")\'' });
check(inline, "INLINE_CODE");
for (const command of [
  "printf BASH_CODE",
  'for item in one two; do\n\n  printf "BASH_CODE %s\\n" "$item"\ndone',
  'node -e \'console.log("BASH_CODE")\'',
  'ruby <<\'RUBY\'\nputs "BASH_CODE"\nRUBY',
  `printf '%s' '${"BASH_CODE ".repeat(40)}'`,
]) {
  const ordinary = makeTool("bash", { command });
  const preview = check(ordinary, "BASH_CODE");
  assert.ok(preview.slice(2).every((line) => line.includes(bg)), "Shade the entire command, including wrapped and blank rows");
  ordinary.updateResult(result("ordinary stdout"), false);
  assert.ok(ordinary.render(140).filter((line) => plain(line).includes("ordinary stdout")).every((line) => !line.includes(bg)));
  ordinary.updateResult(result("BASH_ERROR", undefined, true), false);
  assert.ok(ordinary.render(140).filter((line) => plain(line).includes("BASH_ERROR")).every((line) => !line.includes(bg)));
}
console.log("Tool code surfaces passed: write/read/edit/Bash, embedded languages, wrapping, expansion, updates, colors, errors, image captions, hints, and stdout.");
