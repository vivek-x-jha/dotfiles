// Run with: node ai/pi/tests/markdown-presentation.mjs (offline, synthetic messages only).
import assert from "node:assert/strict";
import { execFileSync } from "node:child_process";
import { createRequire } from "node:module";
import { join } from "node:path";
import { fileURLToPath } from "node:url";

process.env.FORCE_COLOR = "3"; // Exercise terminal attributes even when the test runner captures stdout.
const packageRoot = join(execFileSync("npm", ["root", "-g"], { encoding: "utf8" }).trim(), "@earendil-works/pi-coding-agent");
const require = createRequire(join(packageRoot, "package.json"));
const { createJiti } = require("jiti");
const jiti = createJiti(import.meta.url, { alias: {
  "@earendil-works/pi-coding-agent": join(packageRoot, "dist/index.js"),
  "@earendil-works/pi-tui": require.resolve("@earendil-works/pi-tui"),
} });
const { Box, Markdown, visibleWidth, stripTerminalSequences } = await jiti.import(require.resolve("@earendil-works/pi-tui"));
const { AssistantMessageComponent, UserMessageComponent, getMarkdownTheme } = await jiti.import(join(packageRoot, "dist/index.js"));
const themes = await jiti.import(join(packageRoot, "dist/modes/interactive/theme/theme.js"));
const theme = themes.loadThemeFromPath(fileURLToPath(new URL("../themes/sourdiesel.json", import.meta.url)), "truecolor");
themes.setThemeInstance(theme);
const markdown = (text, options) => new Markdown(text, 0, 0, getMarkdownTheme(), undefined, options);
const plain = (lines) => lines.map((line) => stripTerminalSequences(line).trimEnd());
const text = (source, width = 80) => plain(markdown(source).render(width)).join("\n");
const table = "| Name | Value | Note |\n| :--- | ---: | :---: |\n| **Alpha** | 42 | café 👋 |\n| Beta | 99 | 界面 |";
const unchanged = [
  "A **bold**, *italic*, ~~deleted~~ and `inline` sentence.",
  "[A link](https://example.com/path?q=1) and <https://example.com>.",
  "> A **quoted** sentence.\n>\n> Another paragraph.",
  "An escaped \\*asterisk\\* and \\# literal hash.",
  "Literal `### hash` and ` ``` ` examples.",
  "Inline math $x^2$ and display math:\n\n$$\\frac{1}{2}$$",
  "before\n\n---\n\nafter",
  table,
];
const baseline = unchanged.map((source) => markdown(source).render(80));
const { default: extension } = await jiti.import(fileURLToPath(new URL("../extensions/statusline.ts", import.meta.url)));
const nativeUpdateContent = AssistantMessageComponent.prototype.updateContent;
const registrations = [];
const pi = { on(name) { registrations.push(name); }, registerCommand() {}, registerToolRenderer() {} };
extension(pi);
const patched = [Markdown.prototype.renderToken, Markdown.prototype.renderList, AssistantMessageComponent.prototype.updateContent];
extension(pi);
assert.deepEqual([Markdown.prototype.renderToken, Markdown.prototype.renderList, AssistantMessageComponent.prototype.updateContent], patched, "Reload does not stack wrappers");
assert.ok(!registrations.includes("message_end") && !registrations.includes("context"), "Presentation never rewrites model messages");
for (const [index, source] of unchanged.entries()) {
  assert.deepEqual(markdown(source).render(80), baseline[index], `Keep native formatting: ${source}`);
}

for (let depth = 1; depth <= 6; depth++) {
  const source = `${"#".repeat(depth)} Heading **bold** and \`inline\``;
  const block = markdown(source);
  const lines = block.render(80);
  assert.equal(plain(lines).join("\n"), "Heading bold and inline");
  assert.ok(lines.join("").includes("\x1b[1m"), "Headings remain bold");
  if (depth === 1) assert.ok(lines.join("").includes("\x1b[4m"), "H1 keeps its hierarchy");
  assert.equal(block.text, source);
  assert.equal(block.cachedTokens.deref().tokens[0].depth, depth, "Keep original heading depth in cached tokens");
}
assert.equal(text("Setext heading\n=============="), "Setext heading");
assert.equal(text("Setext heading\n--------------"), "Setext heading");
assert.equal(text("> ### Nested heading"), "│ Nested heading");
assert.equal(text("- ### List heading"), "• List heading");
assert.equal(text("\\### literal hash"), "### literal hash");

const literalCode = '### literal heading\n```\n- [x] literal checkbox\n**literal bold**\n[link](https://example.com)';
const code = `~~~~text\n${literalCode}\n~~~~`;
const codeLines = plain(markdown(code).render(100));
assert.equal(codeLines[0], "text", "Language caption replaces the opening fence");
assert.equal(codeLines.at(-1), "", "Blank panel footer replaces the closing fence");
assert.equal(codeLines.slice(1, -1).map((line) => line.slice(2)).join("\n"), literalCode, "Do not strip Markdown characters from code");
assert.ok(!text("```python\nprint(42)\n```").includes("```"));
assert.ok(!text("    indented code").includes("```"));

const listSource = "- first\n  - nested\n- [x] complete\n- [ ] pending\n\n3. third\n4. fourth";
assert.equal(text(listSource), "• first\n    • nested\n☑ complete\n☐ pending\n\n3. third\n4. fourth");
assert.equal(text("3. [x] third\n4. [ ] fourth"), "3. ☑ third\n4. ☐ fourth");
assert.equal(text("- first\n\n- second"), "• first\n\n• second");
const wrappedTask = plain(markdown("- [x] one two three four five six").render(12));
assert.equal(wrappedTask[0], "☑ one two");
assert.ok(wrappedTask.slice(1).every((line) => line.startsWith("  ")), "Task continuation aligns with its text");
assert.equal(wrappedTask.map((line) => line.slice(2).trim()).join(" "), "one two three four five six");
const userOptions = { preserveOrderedListMarkers: true };
assert.equal(plain(markdown("7) original\n9) numbering", userOptions).render(80)).join("\n"), "7) original\n9) numbering");
assert.equal(plain(markdown("- [x] original", userOptions).render(80)).join("\n"), "- [x] original");

const stacked = text(table, 12);
assert.ok(stacked.includes("Name: Alpha") && stacked.includes("Value: 42"));
assert.ok(stacked.includes("Name: Beta") && stacked.includes("Value: 99"));
assert.ok(!stacked.includes("|") && !stacked.includes("---"), "Narrow tables render fields, not source pipes");
assert.ok(text(table, 80).includes("┌"), "Wider tables retain native grids");
assert.ok(text("| Left | Right |\n| --- | --- |", 8).includes("Left"), "Header-only narrow tables retain their headers");

const fixtures = [...unchanged, listSource, code, "### A heading with 界面 and café 👋", "> - [x] nested task\n>\n> ### nested heading", "- item\n\n  ```python\n  print('nested')\n  ```"];
for (const source of fixtures) {
  const block = markdown(source);
  for (const width of [8, 12, 20, 40, 80, 140]) {
    const lines = block.render(width);
    assert.ok(lines.every((line) => visibleWidth(line) <= width), `Width overflow (${width}): ${source}`);
    assert.deepEqual(block.render(width), lines, "Stable cache");
    block.invalidate();
    assert.deepEqual(block.render(width), lines, "Stable invalidation");
    assert.equal(block.text, source, "Keep source intact across resize");
  }
}

// Exercise every streamed prefix through the real assistant component, not a final-only hook.
const response = "### Streamed heading\n\n**Bold** and `inline`.\n\n- [x] task\n\n```python\nprint(42)\n```\n\n" + table;
const component = new AssistantMessageComponent();
for (let end = 1; end <= response.length; end++) {
  const message = Object.freeze({ content: Object.freeze([Object.freeze({ type: "text", text: response.slice(0, end) })]) });
  component.updateContent(message, true);
  for (const width of [20, 80]) {
    const lines = component.render(width);
    assert.ok(lines.every((line) => visibleWidth(line) <= width), `Streaming overflow at ${end}, width ${width}`);
  }
}
const completed = Object.freeze({ content: Object.freeze([Object.freeze({ type: "text", text: response })]), stopReason: "stop" });
component.updateContent(completed, false);
const final = component.render(80).join("\n");
assert.ok(!final.includes("###") && !final.includes("```"));
assert.ok(final.includes("☑") && final.includes("┌"));
assert.equal(component.lastMessage, completed, "No replacement or mutation of the saved message");
for (const zone of ["A", "B", "C"]) assert.equal(final.split(`\x1b]133;${zone}\x07`).length - 1, 1, "Keep assistant shell-integration zones");
const resumed = new AssistantMessageComponent(completed).render(80);
assert.deepEqual(resumed, component.render(80), "Resumed messages render identically to completed streams");
const user = new UserMessageComponent("### User heading\n\n```text\nuser code\n```");
assert.ok(!user.render(80).join("").includes("```"), "Existing user code panels also lose their fences");

// Final answers use a lighter surface; nested code keeps its original background.
const bg = "\x1b[48;2;46;48;69m"; // #2e3045
const codeBg = `\x1b[48;2;${(process.env.NVIM_STATUSLINE_HEX ?? "#27283a").slice(1).match(/../g).map((part) => parseInt(part, 16)).join(";")}m`;
const proseLine = component.render(80).find((line) => line.includes("Streamed heading"));
assert.ok(proseLine.includes(bg) && !proseLine.includes(codeBg), "Final prose has its own lighter surface");
const nestedCodeLine = component.render(80).find((line) => line.includes("print"));
assert.equal([...nestedCodeLine.slice(0, nestedCodeLine.indexOf("print")).matchAll(/\x1b\[48;2;\d+;\d+;\d+m/g)].at(-1)[0], codeBg, "Nested code retains the code background");
const standaloneCode = markdown("```python\nprint(42)\n```").render(80).join("");
assert.ok(standaloneCode.includes(codeBg) && !standaloneCode.includes(bg), "Standalone code is unchanged");
for (const width of [8, 20, 80, 140]) {
  const lines = component.render(width);
  const separator = plain(lines).indexOf("─".repeat(width));
  assert.equal(separator, 1, "Place the rule immediately before the answer, after its leading spacer");
  assert.equal(lines[separator], new UserMessageComponent("fixture").render(width)[0], "Reuse the existing section separator style");
  assert.ok(!lines[separator].includes(bg), "Do not fill the separator");
  assert.ok(lines.slice(separator + 1).every((line) => line.includes(bg) && visibleWidth(line) === width), "Fill answer text, blank lines, code, tables, and margins");
  assert.ok(lines.slice(separator + 1).every((line) => line.lastIndexOf("\x1b[49m") > line.lastIndexOf(bg)), "Close the background on every line");
  assert.deepEqual(component.render(width), lines, "Panel caching is stable");
  component.invalidate();
  assert.deepEqual(component.render(width), lines, "Invalidation does not duplicate separators");
}
const thoughtAndAnswer = Object.freeze({ stopReason: "stop", content: Object.freeze([
  Object.freeze({ type: "thinking", thinking: "Private reasoning" }),
  Object.freeze({ type: "text", text: "Final conclusion\n\nSecond paragraph" }),
  Object.freeze({ type: "text", text: "Additional answer block" }),
]) });
const thoughtComponent = new AssistantMessageComponent(thoughtAndAnswer);
for (const hidden of [false, true, false]) {
  thoughtComponent.setHideThinkingBlock(hidden);
  const lines = thoughtComponent.render(80);
  const separator = plain(lines).indexOf("─".repeat(80));
  assert.equal(plain(lines).filter((line) => line === "─".repeat(80)).length, 1, "One separator across multiple text blocks");
  assert.ok(!lines.slice(0, separator).join("").includes(bg), "Thinking and its hidden label stay unfilled");
  assert.ok(lines.slice(separator + 1).every((line) => line.includes(bg)), "Every answer block is filled");
  assert.equal(thoughtComponent.lastMessage, thoughtAndAnswer, "Panel styling leaves the message unchanged");
}
const beforeClick = thoughtComponent.render(80);
assert.equal(thoughtComponent.handleMouse({ type: "click", button: "left", x: 2, y: 1, width: 80, height: beforeClick.length })?.handled, true);
assert.ok(thoughtComponent.render(80).join("").includes("Thinking..."), "Thinking click targets survive the added panel");
for (const stopReason of [undefined, "stop", "toolUse", "aborted", "error", "length"]) {
  for (const streaming of [false, true]) {
    const partial = new AssistantMessageComponent();
    partial.updateContent({ stopReason, content: [{ type: "text", text: "Plain reply" }] }, streaming);
    const lines = partial.render(80).join("\n");
    assert.equal(lines.includes(bg), stopReason === "stop" && !streaming, "Shade only successful completed replies");
    assert.equal(lines.includes("─".repeat(80)), stopReason === "stop" && !streaming);
  }
}
for (const stopReason of ["toolUse", "stop"]) {
  const toolTurn = new AssistantMessageComponent({ stopReason, content: [
    { type: "text", text: "Checking files" }, { type: "toolCall", id: "fixture", name: "read", arguments: {} },
  ] });
  assert.ok(!toolTurn.render(80).join("").includes(bg), "Tool-call commentary stays unfilled");
}
for (const content of [[], [{ type: "text", text: "   " }], [{ type: "thinking", thinking: "No answer text" }]]) {
  const empty = new AssistantMessageComponent({ stopReason: "stop", content }).render(80).join("");
  assert.ok(!empty.includes(bg) && !empty.includes("─".repeat(80)), "No empty final-answer panel");
}
component.updateContent({ stopReason: "stop", content: [{ type: "text", text: "New streamed response" }] }, true);
assert.ok(!component.render(80).join("").includes(bg), "Reusing a component for streaming removes its old panel");
component.updateContent(completed, false);

const sharedTheme = getMarkdownTheme();
const originalBorder = sharedTheme.codeBlockBorder;
new Markdown("```js\nconst value = 42;\n```", 0, 0, sharedTheme).render(80);
assert.equal(sharedTheme.codeBlockBorder, originalBorder, "Never mutate shared theme functions");
const originalPalette = component.render(80);
themes.setThemeInstance(themes.getThemeByName("light"));
component.invalidate();
const lightPalette = component.render(80);
assert.deepEqual(plain(lightPalette), plain(originalPalette), "Theme switches preserve layout");
assert.notDeepEqual(lightPalette, originalPalette, "Theme switches refresh colors");
themes.setThemeInstance(theme);
component.invalidate();
assert.deepEqual(component.render(80), originalPalette);

// Simulate the already-running v1 extension, whose original method was not saved.
const assistantPrototype = AssistantMessageComponent.prototype;
delete assistantPrototype.__sourdieselFinalAnswerSurface;
assistantPrototype.__sourdieselFinalAnswerSurfacePatched = true;
assistantPrototype.updateContent = function (message, streaming) {
  nativeUpdateContent.call(this, message, streaming);
  if (this.isStreaming || this.hasToolCalls || message.stopReason !== "stop") return;
  let first = true;
  this.contentContainer.children = this.contentContainer.children.flatMap((child) => {
    if (!(child instanceof Markdown)) return [child];
    const panel = new Box(0, 0, (line) => `${codeBg}${line}\x1b[49m`);
    panel.addChild(child);
    const children = first ? [{ render: (width) => [new UserMessageComponent("fixture").render(width)[0]], invalidate() {} }, panel] : [panel];
    first = false;
    return children;
  });
};
const legacy = new AssistantMessageComponent(completed);
assert.ok(!legacy.render(80).join("").includes(bg), "Fixture starts on the old surface");
extension(pi);
legacy.invalidate();
assert.deepEqual(legacy.render(80), originalPalette, "Reload upgrades existing panels without duplicate separators");
const migratedUpdate = assistantPrototype.updateContent;
extension(pi);
assert.equal(assistantPrototype.updateContent, migratedUpdate, "Reload after migration remains idempotent");

console.log("Markdown presentation passed: inline styling, six heading levels, literal code, bullets/tasks, nested blocks, narrow tables, streaming, resize, reload, themes, final-answer panels/separators, thinking clicks, and unchanged message source.");
