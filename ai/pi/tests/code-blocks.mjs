// Run with: node ai/pi/tests/code-blocks.mjs (uses the globally installed Pi).
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
const { getMarkdownTheme, UserMessageComponent, AssistantMessageComponent } = await jiti.import(join(packageRoot, "dist/index.js"));
const { Markdown, visibleWidth, stripTerminalSequences } = await jiti.import(require.resolve("@earendil-works/pi-tui"));
const themes = await jiti.import(join(packageRoot, "dist/modes/interactive/theme/theme.js"));
const theme = themes.loadThemeFromPath(fileURLToPath(new URL("../themes/sourdiesel.json", import.meta.url)), "truecolor");
themes.setThemeInstance(theme);
const markdown = (text) => new Markdown(text, 0, 0, getMarkdownTheme());
const fixtures = [
  ...["python", "bash", "zsh", "not-a-language", ""].map((lang) => `before prose\n\n\`\`\`${lang}\nimport os\n\nprint("hello 界面 👋", 42)\n\`\`\`\n\nafter prose`),
  "```python\nprint('a long string that should wrap without losing any text or adding blank lines')\n```",
  "```\n```",
  "```python\nimport os\n```\n```python\nimport sys\n```",
  "> ```python\n> import os\n> ```\n\nafter prose",
  "- A list\n\n  ```python\n  import os\n  ```\n\nafter prose",
  "````python\nprint('``` inside code')\n````",
  "```python\nimport os\nprint('streaming')", // An unfinished streamed fence.
];
const widths = [1, 2, 4, 8, 20, 40, 80, 140];
const plain = (lines) => lines.map(stripTerminalSequences).map((line) => line.trimEnd());
const baseline = fixtures.map((text) => widths.map((width) => plain(markdown(text).render(width))));
const { default: extension } = await jiti.import(fileURLToPath(new URL("../extensions/statusline.ts", import.meta.url)));
const pi = { on() {}, registerCommand() {}, registerToolRenderer() {} };
extension(pi);
const patched = Markdown.prototype.renderToken;
extension(pi);
assert.equal(Markdown.prototype.renderToken, patched, "Do not wrap twice after reload");
const bg = `\x1b[48;2;${(process.env.NVIM_STATUSLINE_HEX ?? "#27283a").slice(1).match(/../g).map((part) => parseInt(part, 16)).join(";")}m`;
for (const [fixtureIndex, text] of fixtures.entries()) {
  for (const [widthIndex, width] of widths.entries()) {
    const component = markdown(text);
    const lines = component.render(width);
    assert.ok(lines.every((line) => visibleWidth(line) <= width), `Overflow at width ${width}: ${text}`);
    const previous = baseline[fixtureIndex][widthIndex];
    // At tiny widths native nested blocks/glyphs already overflow; only require safe output.
    if (width >= 8 && previous.every((line) => visibleWidth(line) <= width)) {
      assert.deepEqual(plain(lines), previous, `Do not change Markdown text/layout: ${width}, ${text}`);
    }
    assert.ok(lines.some((line) => line.includes(bg)), "Every code block gets the requested background");
    for (const line of lines) {
      if (line.includes("before prose") || line.includes("after prose")) assert.ok(!line.includes(bg), "Keep prose transparent");
      if (width >= 8 && line.includes(bg)) {
        assert.ok(line.lastIndexOf("\x1b[49m") > line.lastIndexOf(bg), "Close the background on each line");
      }
    }
    assert.deepEqual(component.render(width), lines, "Cached renders stay stable");
    component.invalidate();
    assert.deepEqual(component.render(width), lines, "Invalidation preserves the background");
  }
}

const source = "```python\nimport os\n\nprint('hello', 42)\n```";
const block = markdown(source);
const lines = block.render(40);
assert.ok(lines.every((line) => visibleWidth(line) === 40 && line.includes(bg)), "Fill borders, blank code lines, and right padding");
assert.ok(lines.join("\n").includes(theme.fg("syntaxKeyword", "import")), "Preserve syntax foreground colors");
assert.ok(!markdown("Prose with `inline code`.").render(40).join("").includes(bg), "Do not shade inline code");
const resetTheme = { ...getMarkdownTheme(), highlightCode: () => ["a\x1b[0mb\x1b[49mc"] };
const resetLines = new Markdown("```\nabc\n```", 0, 0, resetTheme).render(40);
assert.ok(resetLines.join("").includes(`\x1b[0m${bg}b\x1b[49m${bg}c`), "Restore background after embedded ANSI resets");
for (const width of [8, 20, 80]) {
  const user = new UserMessageComponent(source).render(width);
  assert.ok(user.every((line) => visibleWidth(line) <= width));
  assert.ok(user.filter((line) => line.includes(bg)).every((line) => visibleWidth(line) === width), "Keep user-code background padding after the prompt");
  const assistant = new AssistantMessageComponent({ content: [{ type: "text", text: `${source}\n\nafter prose` }] }).render(width);
  assert.ok(assistant.every((line) => visibleWidth(line) <= width));
  assert.ok(assistant.some((line) => line.includes(bg)));
}
const otherTheme = themes.getThemeByName("dark");
themes.setThemeInstance(otherTheme);
block.invalidate();
const otherLines = block.render(40).join("\n");
assert.ok(otherLines.includes(bg));
assert.ok(otherLines.includes(otherTheme.fg("syntaxKeyword", "import")));
themes.setThemeInstance(theme);
console.log("Code-block backgrounds passed: languages, wrapping, nesting, blank lines, transparency, syntax, ANSI resets, reloads, and theme changes.");
