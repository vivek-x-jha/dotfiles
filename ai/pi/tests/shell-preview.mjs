// Run with: node ai/pi/tests/shell-preview.mjs (parses fixtures; never executes them).
import assert from "node:assert/strict";
import { execFileSync, spawnSync } from "node:child_process";
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
const { default: extension, formatShellPreview } = await jiti.import(fileURLToPath(new URL("../extensions/statusline.ts", import.meta.url)));
const source = "printf one && printf two | cat || printf failed |& cat";
const vertical = "printf one &&\n  printf two |\n  cat ||\n  printf failed |&\n  cat";
assert.equal(formatShellPreview(source), vertical);
assert.equal(formatShellPreview("printf a|cat&&printf b"), "printf a|\n  cat&&\n  printf b");
assert.equal(formatShellPreview("    printf a && printf b | cat"), "    printf a &&\n      printf b |\n      cat");
assert.equal(formatShellPreview("printf café 👋 && printf 界面 | cat"), "printf café 👋 &&\n  printf 界面 |\n  cat");
assert.equal(formatShellPreview("printf a &&\n  printf b"), "printf a &&\n  printf b");
assert.equal(formatShellPreview("printf a &&\\\n  printf b |\\\n  cat"), "printf a &&\\\n  printf b |\\\n  cat");
const heredoc = "cat <<'EOF' | cat\nbody && literal | pipes\nEOF\nprintf after && printf done";
assert.equal(formatShellPreview(heredoc), "cat <<'EOF' | cat\nbody && literal | pipes\nEOF\nprintf after &&\n  printf done");

const fixtures = [
  source,
  "printf a|cat&&printf b",
  "    printf a && printf b | cat",
  "printf café 👋 && printf 界面 | cat",
  "printf '%s' 'a&&b||c|d' && printf '%s' \"$(printf a | cat)\"",
  "printf '%s' $(printf a | cat) && printf '%s' <(printf b | cat)",
  "printf '%s' `printf a | cat` && printf done",
  "printf '%s' $'a\\n|b' && printf '%s' ${value:-$(printf a | cat)}",
  "printf '%s' $((1 | 2)) && (( x = 1 | 2 )) || printf fail",
  "printf a\\|b && printf c\\&\\&d",
  "[[ $x =~ a|b ]] && printf yes || printf no",
  "printf '%s' @(foo|bar) && printf done",
  "printf a >| out && printf b",
  "printf a && # keep comment | literally\n  printf b | cat # ending && intact",
  "printf 'quoted\n a | b' && printf done",
  "f() { printf a && printf b | cat; }; f || printf failed",
  "if true; then printf a && printf b; fi | cat",
  "printf a &&\n  printf b",
  "printf a &&\\\n  printf b |\\\n  cat",
  heredoc,
  "cat <<-EOF | cat\n\t$(printf a | cat)\n\tEOF\nprintf after | cat",
  "cat <<EOF \\\n | cat\nbody | &&\nEOF\nprintf after | cat",
];
function syntax(text) {
  const result = spawnSync("shfmt", ["-ln", "bash", "--to-json"], { input: text, encoding: "utf8" });
  assert.equal(result.status, 0, result.stderr);
  return JSON.stringify(JSON.parse(result.stdout), (_key, value) => value && typeof value === "object" && "Offset" in value && "Line" in value && "Col" in value ? undefined : value);
}
for (const fixture of fixtures) {
  const formatted = formatShellPreview(fixture);
  assert.equal(syntax(formatted), syntax(fixture), `Shell syntax changed: ${fixture}`);
  const checked = spawnSync("bash", ["-O", "extglob", "-n"], { input: formatted, encoding: "utf8" });
  assert.equal(checked.status, 0, `${fixture}: ${checked.stderr}`);
  assert.equal(formatShellPreview(formatted), formatted, "Formatting must be idempotent");
}
for (const fixture of [
  "printf '%s' 'only | quoted && operators'",
  "printf '%s' \"$(printf a | cat)\"",
  "printf '%s' <(printf a | cat)",
  "[[ $x =~ a|b ]]",
  "# a comment | && ||",
  "printf a; printf b",
  "printf a &&",
  "printf a && printf 'unfinished",
  "cat <<EOF\nunfinished | && heredoc",
  `printf '${"x".repeat(17000)}' | cat`,
]) assert.equal(formatShellPreview(fixture), fixture, "Preserve protected, partial, and oversized input");
const cachedSource = "printf cached_source && printf hit";
const cached = formatShellPreview(cachedSource);
assert.notEqual(cached, cachedSource);
const savedPath = process.env.PATH;
try {
  process.env.PATH = "/nonexistent-pi-shell-preview-fixture";
  assert.equal(formatShellPreview(cachedSource), cached, "Reuse cached formatting without another parser process");
  const uncached = "printf missing_parser && printf untouched";
  assert.equal(formatShellPreview(uncached), uncached, "Missing shfmt must not break rendering");
} finally { process.env.PATH = savedPath; }

const { Markdown, visibleWidth, stripTerminalSequences } = await jiti.import(require.resolve("@earendil-works/pi-tui"));
const { ToolExecutionComponent, getMarkdownTheme } = await jiti.import(join(packageRoot, "dist/index.js"));
const themes = await jiti.import(join(packageRoot, "dist/modes/interactive/theme/theme.js"));
themes.setThemeInstance(themes.loadThemeFromPath(fileURLToPath(new URL("../themes/sourdiesel.json", import.meta.url)), "truecolor"));
const { createShellRenderers } = await jiti.import(join(packageRoot, "dist/core/tools/renderers/bash.js"));
let resolver;
const pi = { on() {}, registerCommand() {}, registerToolRenderer(value) { resolver = value; } };
extension(pi);
const renderToken = Markdown.prototype.renderToken;
extension(pi);
assert.equal(Markdown.prototype.renderToken, renderToken, "Reload must not stack formatter wrappers");
const plain = (line) => stripTerminalSequences(line).trimEnd();
for (const language of ["bash", "sh", "shell", "bash title=example"]) {
  const text = `\`\`\`${language}\n${source}\n\`\`\``;
  const block = new Markdown(text, 0, 0, getMarkdownTheme());
  const lines = block.render(140);
  assert.equal(lines.slice(1, -1).map((line) => plain(line).slice(2)).join("\n"), vertical);
  assert.equal(block.text, text, "Do not mutate Markdown source");
  assert.equal(block.cachedTokens.deref().tokens.find((token) => token.type === "code").text, source, "Do not mutate cached Markdown tokens");
  for (const width of [1, 2, 8, 20, 80]) assert.ok(block.render(width).every((line) => visibleWidth(line) <= width));
}
const untouched = new Markdown(`\`\`\`python\n${source}\n\`\`\``, 0, 0, getMarkdownTheme()).render(140);
assert.equal(untouched.slice(1, -1).map((line) => plain(line).slice(2)).join("\n"), source);
const native = createShellRenderers("$");
const tool = new ToolExecutionComponent("bash", "fixture", { command: source }, { outputPad: 1 }, resolver("bash", () => native), { requestRender() {} }, "/fixture");
const displayed = tool.render(140).map(plain);
assert.ok(displayed.some((line) => line.trim() === "printf two |"));
assert.ok(displayed.some((line) => line.trim() === "cat ||"));
assert.equal(tool.args.command, source, "Do not change execution arguments");
for (const width of [1, 2, 8, 20, 80]) assert.ok(tool.render(width).every((line) => visibleWidth(line) <= width));
const { writeRenderers } = await jiti.import(join(packageRoot, "dist/core/tools/renderers/write.js"));
const write = new ToolExecutionComponent("write", "fixture-write", { path: "/fixture/script.sh", content: source }, { outputPad: 1 }, resolver("write", () => writeRenderers), { requestRender() {} }, "/fixture");
assert.ok(write.render(140).map(plain).some((line) => line.includes(source)), "File contents must remain literal previews");
assert.equal(write.args.content, source);
console.log("Shell previews passed: parsed operator breaks, UTF-8, unchanged ASTs, protected syntax, heredocs, fallback, caching, Bash calls, fenced aliases, and widths.");
