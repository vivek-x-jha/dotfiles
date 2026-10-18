// Run with: node ai/pi/tests/user-message.mjs (uses the globally installed Pi).
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
const { UserMessageComponent, AssistantMessageComponent } = await jiti.import(join(packageRoot, "dist/index.js"));
const { visibleWidth } = await jiti.import(require.resolve("@earendil-works/pi-tui"));
const { loadThemeFromPath, setThemeInstance } = await jiti.import(join(packageRoot, "dist/modes/interactive/theme/theme.js"));
setThemeInstance(loadThemeFromPath(fileURLToPath(new URL("../themes/sourdiesel.json", import.meta.url)), "truecolor"));
const { default: extension } = await jiti.import(fileURLToPath(new URL("../extensions/statusline.ts", import.meta.url)));
const pi = { on() {}, registerCommand() {}, registerToolRenderer() {} };

// Simulate /reload from the old renderer: it must not get wrapped again.
UserMessageComponent.prototype.__sourdieselSectionSeparatorPatchVersion = 17;
UserMessageComponent.prototype.render = () => { throw new Error("Old user renderer called"); };
extension(pi);
const patchedRender = UserMessageComponent.prototype.render;
extension(pi);
assert.equal(UserMessageComponent.prototype.render, patchedRender);

const plain = (line) => line.replace(/\x1b\][^\x07\x1b]*(?:\x07|\x1b\\)/g, "").replace(/\x1b\[[0-?]*[ -/]*[@-~]/g, "");
const fixtures = [
  "A short message.",
  "A longer message with enough words to wrap across multiple lines without losing any words or duplicating the prompt.",
  "First paragraph.\n\nSecond paragraph.",
  "A Unicode message: 界面 café 👋 and more words to wrap.",
  "```js\nconst value = 42;\n```",
  "[A link](https://example.com) and **bold text**.",
  "[A standalone link](https://example.com)",
  ">>> literal user text must not be stripped",
];
for (const width of [1, 2, 3, 4, 5, 8, 20, 40, 80, 140]) {
  for (const text of fixtures) {
    const component = new UserMessageComponent(text);
    const lines = component.render(width);
    assert.deepEqual(component.render(width), lines, "Repeated renders must stay stable");
    assert.ok(lines.every((line) => visibleWidth(line) <= width), `Width overflow at ${width}`);
    const rendered = lines.join("\n");
    for (const zone of ["A", "B", "C"]) {
      assert.equal(rendered.split(`\x1b]133;${zone}\x07`).length - 1, 1, "Preserve shell zones exactly once");
    }
    if (width >= 8) {
      const body = lines.slice(1).map(plain);
      assert.ok(body[0].startsWith(">>> "), JSON.stringify({ width, text, body }));
      assert.ok(body.slice(1).every((line) => line.startsWith("    ")));
      assert.ok(!rendered.includes("▌") && !rendered.includes(""));
    }
  }
}

const text = "Every word should survive wrapping at a normal terminal width.";
const lines = new UserMessageComponent(text).render(20);
assert.equal(lines.slice(1).map((line) => plain(line).slice(4).trim()).join(" "), text);
const color = (hex) => `\x1b[38;2;${hex.match(/../g).map((part) => parseInt(part, 16)).join(";")}m`;
assert.ok(lines[1].includes(color((process.env.BRIGHTBLUE_HEX ?? "#80d7fe").slice(1))));
assert.ok(lines[1].includes(color("cccccc")));
assert.ok(!lines.join("").includes("\x1b[48;"), "User messages must have no background fill");
const linked = new UserMessageComponent("[A standalone link](https://example.com)").render(80)[1];
assert.ok(plain(linked).includes("A standalone link"));
assert.ok(linked.indexOf(">>> ") < linked.indexOf("\x1b]8;"), "Prompt must stay outside hyperlinks");
assert.deepEqual(new UserMessageComponent("   ").render(80), []);
const assistant = new AssistantMessageComponent({ content: [{ type: "text", text: "Response" }] });
assert.equal(plain(assistant.render(80)[0]).trim(), "", "Keep the existing blank line before assistant responses");
console.log("User-message rendering passed: widths, wrapping, colors, shell zones, and reload safety.");
