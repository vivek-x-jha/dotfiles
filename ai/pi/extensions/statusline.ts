import {
  AssistantMessageComponent,
  CompactionSummaryMessageComponent,
  ToolExecutionComponent,
  UserMessageComponent,
  type ExtensionAPI,
  type ExtensionContext,
  type ReadonlyFooterDataProvider,
  type Theme,
} from "@earendil-works/pi-coding-agent";
import { Container, truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";
import { existsSync } from "node:fs";
import { spawn, type ChildProcessWithoutNullStreams } from "node:child_process";
import { basename, isAbsolute, join as pathJoin } from "node:path";

const PI_ICON = "π";
const GROUP_SEP = " · ";
const MODEL_ICON = ""; // Nerd Font bolt glyph
const THINKING_ICON = ""; // Nerd Font lightbulb glyph
const TOKEN_ICON = "ctx"; // context token label
const TOOL_ICON = ""; // Nerd Font wrench glyph
const SHELL_ICON = ""; // same shell icon as nvim/web-devicons bash
const CONTEXT_REMAINING_ICON = "󰧑"; // Nerd Font brain glyph
const CODEX_QUOTA_ICON = ""; // Nerd Font hourglass glyph
const CONTEXT_WARNING_REMAINING_PERCENT = 40;
const CONTEXT_CRITICAL_REMAINING_PERCENT = 20;
const CODEX_QUOTA_REFRESH_MS = 5 * 60 * 1000;
const CODEX_QUOTA_TIMEOUT_MS = 15_000;
const FAILED_TOOL_HIGHLIGHT_MS = 8000;
const TOOL_ORDER = ["read", "edit", "write", "bash", "other"] as const;
type ToolKey = (typeof TOOL_ORDER)[number];

const TOOL_SPECS: Record<
  ToolKey,
  { icon: string; color: string; fallback: string }
> = {
  read: { icon: "", color: "BRIGHTMAGENTA_HEX", fallback: "#c9ccfb" },
  bash: { icon: SHELL_ICON, color: "BRIGHTGREEN_HEX", fallback: "#d2fd9d" },
  edit: { icon: "", color: "BRIGHTYELLOW_HEX", fallback: "#f3b175" },
  write: { icon: "", color: "BRIGHTRED_HEX", fallback: "#f096b7" },
  other: { icon: "󰘦", color: "MAGENTA_HEX", fallback: "#eccef0" },
};

const HARNESS_FALLBACK_COLORS = {
  pi: "#eccef0",
  claude: "#f3b175",
  codex: "#80d7fe",
  cursor: "#cccccc",
  opencode: "#f4f3f2",
} as const;

const HARNESSES = {
  pi: { icon: "π", env: "MAGENTA_HEX", fallback: HARNESS_FALLBACK_COLORS.pi },
  claude: {
    icon: "",
    env: "BRIGHTYELLOW_HEX",
    fallback: HARNESS_FALLBACK_COLORS.claude,
  },
  codex: {
    icon: "󱙺",
    env: "BRIGHTBLUE_HEX",
    fallback: HARNESS_FALLBACK_COLORS.codex,
  },
  cursor: { icon: "󰋙", env: "BLACK_HEX", fallback: HARNESS_FALLBACK_COLORS.cursor },
  opencode: {
    icon: "",
    env: "WHITE_HEX",
    fallback: HARNESS_FALLBACK_COLORS.opencode,
  },
} as const;

const THINKING_STYLES = {
  off: {
    iconColor: "BRIGHTBLACK_HEX",
    iconFallback: "#5c617d",
    textColor: "BRIGHTBLACK_HEX",
    textFallback: "#5c617d",
    label: "off",
  },
  minimal: {
    iconColor: "BRIGHTGREEN_HEX",
    iconFallback: "#d2fd9d",
    textColor: "GREEN_HEX",
    textFallback: "#ceffc9",
    label: "min",
  },
  low: {
    iconColor: "BRIGHTMAGENTA_HEX",
    iconFallback: "#c9ccfb",
    textColor: "MAGENTA_HEX",
    textFallback: "#eccef0",
    label: "low",
  },
  medium: {
    iconColor: "WHITE_HEX",
    iconFallback: "#f4f3f2",
    textColor: "BLACK_HEX",
    textFallback: "#cccccc",
    label: "med",
  },
  high: {
    iconColor: "BRIGHTYELLOW_HEX",
    iconFallback: "#f3b175",
    textColor: "YELLOW_HEX",
    textFallback: "#fdf7cd",
    label: "hih",
  },
  xhigh: {
    iconColor: "BRIGHTRED_HEX",
    iconFallback: "#f096b7",
    textColor: "RED_HEX",
    textFallback: "#ffc7c7",
    label: "xhi",
  },
  max: {
    iconColor: "BRIGHTWHITE_HEX",
    iconFallback: "#ffffff",
    textColor: "BRIGHTRED_HEX",
    textFallback: "#f096b7",
    label: "max",
  },
} as const;

type HarnessName = keyof typeof HARNESSES;

type ThinkingLevel = keyof typeof THINKING_STYLES;

type Phase = "idle" | "thinking" | "streaming" | "tool" | "waiting" | "error";
type ToolStatus = "running" | "success" | "error";

interface ToolSnapshot {
  name: string;
  status: ToolStatus;
}

interface CodexQuotaWindow {
  usedPercent: number;
  windowDurationMins: number | null;
  resetsAt: number | null;
}

interface CodexQuotaSnapshot {
  primary?: CodexQuotaWindow;
  secondary?: CodexQuotaWindow;
  fetchedAt: number;
}

interface GitSnapshot {
  branch?: string;
  tag?: string;
  commit?: string;
  upstream?: string;
  remoteBranch?: string;
  wip: boolean;
  commitsAhead: number;
  commitsBehind: number;
  pushCommitsAhead: number;
  pushCommitsBehind: number;
  action?: string;
  conflicted: number;
  staged: number;
  unstaged: number;
  stashes: number;
  untracked: number;
  unknownDirty: boolean;
}

interface StatuslineState {
  enabled: boolean;
  phase: Phase;
  activeTools: Map<string, string>;
  lastTool?: ToolSnapshot;
  failedTool?: { key: ToolKey; until: number };
  title: string;
  modelId?: string;
  modelProvider?: string;
  thinkingLevel?: ThinkingLevel;
  contextTokens?: number | null;
  contextWindow?: number;
  contextPercent?: number | null;
  codexQuota?: CodexQuotaSnapshot;
  gitStatus?: GitSnapshot;
  pendingMessages: boolean;
}

export default function (pi: ExtensionAPI) {
  const state: StatuslineState = {
    enabled: true,
    phase: "idle",
    activeTools: new Map(),
    title: PI_ICON,
    pendingMessages: false,
  };

  let requestFooterRender: (() => void) | undefined;
  let gitTimer: ReturnType<typeof setTimeout> | undefined;
  let failedToolTimer: ReturnType<typeof setTimeout> | undefined;
  let codexQuotaTimer: ReturnType<typeof setTimeout> | undefined;
  let codexQuotaInFlight = false;
  let gitGeneration = 0;
  let codexQuotaGeneration = 0;

  function formatCount(n: number | null | undefined): string {
    if (n === null || n === undefined) return "?";
    if (n < 1000) return String(n);
    if (n < 1_000_000) return `${(n / 1000).toFixed(n < 10_000 ? 1 : 0)}k`;
    return `${(n / 1_000_000).toFixed(1)}m`;
  }

  function compactModel(id: string): string {
    return id
      .replace(/^claude-/, "")
      .replace(/-20\d{6}$/, "")
      .replace(/-latest$/, "")
      .replace(/^gpt-/, "gpt-");
  }

  function envHex(name: string, fallback: string): string {
    const value = process.env[name];
    return value && /^#[0-9a-f]{6}$/i.test(value) ? value : fallback;
  }

  function fgHexPrefix(hex: string): string {
    const match = /^#?([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})$/i.exec(hex);
    if (!match) return "";
    const [, r, g, b] = match;
    return `\x1b[38;2;${parseInt(r, 16)};${parseInt(g, 16)};${parseInt(b, 16)}m`;
  }

  function fgHex(hex: string, text: string): string {
    const prefix = fgHexPrefix(hex);
    return prefix ? `${prefix}${text}\x1b[39m` : text;
  }

  function harnessColor(harness: HarnessName, text: string): string {
    const spec = HARNESSES[harness];
    return fgHex(envHex(spec.env, spec.fallback), text);
  }

  function blackText(text: string): string {
    return fgHex(envHex("BLACK_HEX", "#cccccc"), text);
  }

  function whiteText(text: string): string {
    return fgHex(envHex("WHITE_HEX", "#f4f3f2"), text);
  }

  function brightWhiteText(text: string): string {
    return fgHex(envHex("BRIGHTWHITE_HEX", "#ffffff"), text);
  }

  function brightBlackText(text: string): string {
    return fgHex(envHex("BRIGHTBLACK_HEX", "#5c617d"), text);
  }

  function sectionSeparator(width: number): string {
    return brightBlackText("─".repeat(Math.max(1, width)));
  }

  const OSC_SEQUENCE_PATTERN = /\x1b\][^\x07]*(?:\x07|\x1b\\)/g;

  function extractOscSequences(line: string): string {
    return [...line.matchAll(OSC_SEQUENCE_PATTERN)].map((match) => match[0]).join("");
  }

  function stripRenderedControl(line: string): string {
    return line
      .replace(OSC_SEQUENCE_PATTERN, "")
      .replace(/\x1b\[[0-?]*[ -/]*[@-~]/g, "");
  }

  function isBlankRenderedLine(line: string): boolean {
    return stripRenderedControl(line).trim().length === 0;
  }

  function isSeparatorRenderedLine(line: string): boolean {
    return /^─+$/.test(stripRenderedControl(line).trim());
  }

  function trimOuterBlankLines(lines: string[]): string[] {
    const trimmed = [...lines];
    let leadingOsc = "";
    let trailingOsc = "";

    while (trimmed.length > 0 && isBlankRenderedLine(trimmed[0])) {
      leadingOsc += extractOscSequences(trimmed.shift() ?? "");
    }
    while (trimmed.length > 0 && isBlankRenderedLine(trimmed[trimmed.length - 1])) {
      trailingOsc = extractOscSequences(trimmed.pop() ?? "") + trailingOsc;
    }

    if (trimmed.length > 0) {
      if (leadingOsc) trimmed[0] = leadingOsc + trimmed[0];
      if (trailingOsc) trimmed[trimmed.length - 1] = trailingOsc + trimmed[trimmed.length - 1];
    }
    return trimmed;
  }

  function stripExistingLeadingSeparator(lines: string[]): string[] {
    return lines.length > 0 && isSeparatorRenderedLine(lines[0]) ? lines.slice(1) : lines;
  }

  function brightBlueText(text: string): string {
    return fgHex(envHex("BRIGHTBLUE_HEX", "#80d7fe"), text);
  }

  function splitLeadingOsc(line: string): [string, string] {
    let rest = line;
    let leading = "";
    while (rest.startsWith("\x1b]")) {
      const belIndex = rest.indexOf("\x07");
      const stIndex = rest.indexOf("\x1b\\");
      const endIndex = belIndex >= 0 && (stIndex < 0 || belIndex < stIndex) ? belIndex + 1 : stIndex >= 0 ? stIndex + 2 : -1;
      if (endIndex < 0) break;
      leading += rest.slice(0, endIndex);
      rest = rest.slice(endIndex);
    }
    return [leading, rest];
  }

  const RENDERED_CONTROL_PATTERN = /(?:\x1b\[[0-?]*[ -/]*[@-~]|\x1b\][^\x07]*(?:\x07|\x1b\\)|\x1b_[^\x07]*(?:\x07|\x1b\\))/y;
  const TRAILING_RENDERED_CONTROL_PATTERN = /(?:\x1b\[[0-?]*[ -/]*[@-~]|\x1b\][^\x07]*(?:\x07|\x1b\\)|\x1b_[^\x07]*(?:\x07|\x1b\\))$/;

  function trimRenderedTrailingSpaces(line: string): string {
    const suffixes: string[] = [];
    let rest = line;
    while (true) {
      const match = TRAILING_RENDERED_CONTROL_PATTERN.exec(rest);
      if (!match) break;
      suffixes.unshift(match[0]);
      rest = rest.slice(0, match.index);
    }
    return `${rest.replace(/[ \t]+$/g, "")}${suffixes.join("")}`;
  }

  function skipRenderedControls(line: string, start: number): number {
    let index = start;
    while (index < line.length) {
      RENDERED_CONTROL_PATTERN.lastIndex = index;
      const match = RENDERED_CONTROL_PATTERN.exec(line);
      if (!match || match.index !== index) break;
      index += match[0].length;
    }
    return index;
  }

  function stripOneUserMessagePrefix(line: string): string {
    let index = skipRenderedControls(line, 0);
    if (!line.startsWith("▌ ", index)) return line;
    index += "▌ ".length;
    index = skipRenderedControls(line, index);
    if (!line.startsWith(" ", index)) return line;
    index += " ".length;
    index = skipRenderedControls(line, index);
    return line.slice(index);
  }

  function stripUserMessagePrefixes(line: string): string {
    let rest = line;
    for (let i = 0; i < 4; i++) {
      const stripped = stripOneUserMessagePrefix(rest);
      if (stripped === rest) return rest;
      rest = stripped;
    }
    return rest;
  }

  function styleUserMessageLines(lines: string[], width: number): string[] {
    const firstContentIndex = lines.findIndex((line) => !isBlankRenderedLine(line));
    if (firstContentIndex < 0) return lines;
    const prefix = `${brightBlueText("▌ ")}${blueText(" ")}`;
    const prefixWidth = visibleWidth(prefix);
    const [leadingOsc, rest] = splitLeadingOsc(lines[firstContentIndex]);
    const bodyWidth = Math.max(0, width - prefixWidth);
    const body = truncateToWidth(trimRenderedTrailingSpaces(stripUserMessagePrefixes(rest)), bodyWidth, "…");
    return lines.map((line, index) =>
      index === firstContentIndex
        ? truncateToWidth(`${leadingOsc}${prefix}${body}`, width, "…")
        : line,
    );
  }

  function isItalicRenderedLine(line: string): boolean {
    return /\x1b\[3m/.test(line);
  }

  function recolorRenderedFg(line: string, colorHex: string): string {
    const color = fgHexPrefix(colorHex);
    if (!color) return line;
    const fgPattern = /\x1b\[38;(?:2;\d+;\d+;\d+|5;\d+)m/g;
    return fgPattern.test(line) ? line.replace(fgPattern, color) : `${color}${line}\x1b[39m`;
  }

  function recolorThinkingSectionLabels(lines: string[]): string[] {
    let labelPending = true;
    const black = envHex("BLACK_HEX", "#cccccc");
    return lines.map((line) => {
      if (isBlankRenderedLine(line)) return line;
      if (!isItalicRenderedLine(line)) {
        labelPending = true;
        return line;
      }
      if (!labelPending) return line;
      labelPending = false;
      return recolorRenderedFg(line, black);
    });
  }

  function toolCallLabel(name: string): string {
    const key = toolKey(name);
    return key === "other" ? name : key;
  }

  function stringArg(value: unknown): string | undefined {
    return typeof value === "string" && value.trim() ? value : undefined;
  }

  function toolLineRange(args: Record<string, unknown>): string {
    if (typeof args.offset !== "number" && typeof args.limit !== "number") return "";
    const startLine = typeof args.offset === "number" ? args.offset : 1;
    const endLine = typeof args.limit === "number" ? startLine + args.limit - 1 : undefined;
    return yellowText(`:${startLine}${endLine === undefined ? "" : `-${endLine}`}`);
  }

  function stylePath(path: string): string {
    if (!path.includes("/")) return blackText(path);
    if (path.endsWith("/")) return blueText(path);
    const slash = path.lastIndexOf("/");
    return `${blueText(path.slice(0, slash + 1))}${blackText(path.slice(slash + 1))}`;
  }

  function stylePathToken(token: string): string {
    const match = /^(.*?)([.,:]+)?$/.exec(token);
    const body = match?.[1] ?? token;
    const suffix = match?.[2] ?? "";
    return `${stylePath(body)}${blackText(suffix)}`;
  }

  function isPathToken(token: string): boolean {
    return /^(?:~|\.{1,2}|\/|[A-Za-z0-9_.-]+\/)/.test(token);
  }

  function shellOperatorText(text: string): string {
    return fgHex(envHex("WHITE_HEX", "#f4f3f2"), text);
  }

  function shellPromptText(text: string): string {
    return fgHex(envHex("WHITE_HEX", "#f4f3f2"), text);
  }

  function shellVariableText(text: string): string {
    return fgHex(envHex("RED_HEX", "#ffc7c7"), text);
  }

  function shellOptionText(text: string): string {
    return brightYellowText(text);
  }

  function styleBashWord(token: string, commandPosition: boolean): string {
    if (isPathToken(token)) return stylePathToken(token);
    if (/^[$][A-Za-z_][A-Za-z0-9_]*$/.test(token) || /^[$][{][^}]+[}]$/.test(token)) return shellVariableText(token);
    if (/^--?[^-\s]/.test(token)) return shellOptionText(token);
    if (/^[A-Za-z_][A-Za-z0-9_]*=.*/.test(token)) {
      const equalsIndex = token.indexOf("=");
      return `${blackText(token.slice(0, equalsIndex))}${shellOperatorText("=")}${styleBashWord(token.slice(equalsIndex + 1), false)}`;
    }
    if (/^(['"]).*\1$/.test(token)) return greenText(token);
    if (commandPosition) {
      const precommand = /^(?:sudo|env|time|command|builtin|exec|noglob|nocorrect)$/;
      return precommand.test(token) ? magentaText(token) : greenText(token);
    }
    return blackText(token);
  }

  function styleBashCommand(command: string): string {
    const tokenPattern = /\s+|&&|\|\||[|;()<>]+|"(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*'|[^\s|;&()<>]+/g;
    const tokens = command.match(tokenPattern) ?? [command];
    let commandPosition = true;

    return tokens.map((token) => {
      if (/^\s+$/.test(token)) return token;
      if (/^(?:&&|\|\||[|;()<>]+)$/.test(token)) {
        commandPosition = /^(?:&&|\|\||[|;])$/.test(token);
        return shellOperatorText(token);
      }
      const styled = styleBashWord(token, commandPosition);
      if (!/^[A-Za-z_][A-Za-z0-9_]*=.*/.test(token)) commandPosition = false;
      return styled;
    }).join("");
  }

  function toolPathArg(record: Record<string, unknown>): string {
    return stylePath(stringArg(record.path) ?? stringArg(record.file_path) ?? "…");
  }

  function toolCallSummary(name: string, args: unknown): string {
    const key = toolKey(name);
    const record = args && typeof args === "object" ? args as Record<string, unknown> : {};
    switch (key) {
      case "read":
        return `${toolPathArg(record)}${toolLineRange(record)}`;
      case "edit": {
        const count = Array.isArray(record.edits) ? brightBlackText(` ×${record.edits.length}`) : "";
        return `${toolPathArg(record)}${count}`;
      }
      case "write":
        return toolPathArg(record);
      case "bash": {
        const timeout = typeof record.timeout === "number" ? brightBlackText(` (timeout ${record.timeout}s)`) : "";
        return `${styleBashCommand(stringArg(record.command) ?? "…")}${timeout}`;
      }
      case "other": {
        try {
          return blackText(JSON.stringify(record));
        } catch {
          return blackText("…");
        }
      }
    }
  }

  function toolCallLines(name: string, args: unknown, width: number): string[] {
    const key = toolKey(name);
    const title = toolOwnBoldStyle(key)(`${TOOL_SPECS[key].icon} ${toolCallLabel(name)}`);
    if (key !== "bash") return [truncateToWidth(` ${title} ${toolCallSummary(name, args)}`, width, "…")];

    const record = args && typeof args === "object" ? args as Record<string, unknown> : {};
    const timeout = typeof record.timeout === "number" ? brightBlackText(` (timeout ${record.timeout}s)`) : "";
    const command = `${styleBashCommand(stringArg(record.command) ?? "…")}${timeout}`;
    return [
      truncateToWidth(` ${title}`, width, "…"),
      truncateToWidth(` ${shellPromptText("")} ${command}`, width, "…"),
    ];
  }

  function clampRenderedLines(lines: string[], width: number): string[] {
    return lines.map((line) => visibleWidth(line) > width ? truncateToWidth(line, width, "…") : line);
  }

  function replaceToolCallLine(lines: string[], toolName: string | undefined, args: unknown, width: number): string[] {
    if (!toolName || lines.length === 0) return clampRenderedLines(lines, width);
    const firstContentIndex = lines.findIndex((line) => !isBlankRenderedLine(line));
    if (firstContentIndex < 0) return clampRenderedLines(lines, width);
    return clampRenderedLines([
      ...lines.slice(0, firstContentIndex),
      ...toolCallLines(toolName, args, width),
      ...lines.slice(firstContentIndex + 1),
    ], width);
  }

  function renderToolExecutionBase(self: ToolExecutionInternals, width: number): string[] {
    if (self.hideComponent) return [];
    if (self.hasRendererDefinition?.() && self.getRenderShell?.() === "self") {
      const contentLines = self.selfRenderContainer?.render(width) ?? [];
      const imageComponents = self.imageComponents ?? [];
      if (contentLines.length === 0 && imageComponents.length === 0) return [];

      const lines: string[] = [];
      if (contentLines.length > 0) {
        lines.push("");
        lines.push(...contentLines);
      }
      for (let i = 0; i < imageComponents.length; i++) {
        const spacer = self.imageSpacers?.[i];
        if (spacer) lines.push(...spacer.render(width));
        lines.push(...imageComponents[i].render(width));
      }
      return lines;
    }

    return Container.prototype.render.call(self, width) as string[];
  }

  type RenderableComponent = { render: (width: number) => string[] };
  type SectionPrototype = {
    render: (width: number) => string[];
    __sourdieselSectionSeparatorPatchVersion?: number;
    __sourdieselThinkingLabelPatchVersion?: number;
    __sourdieselCompactionLabelPatchVersion?: number;
  };
  type ToolExecutionInternals = {
    hideComponent?: boolean;
    hasRendererDefinition?: () => boolean;
    getRenderShell?: () => "default" | "self";
    selfRenderContainer?: RenderableComponent;
    imageComponents?: RenderableComponent[];
    imageSpacers?: Array<RenderableComponent | undefined>;
    toolName?: string;
    args?: unknown;
  };

  function recolorCompactionLabel(lines: string[]): string[] {
    let replaced = false;
    return lines.map((line) => {
      if (replaced || !line.includes("[compaction]")) return line;
      replaced = true;
      return line.replace("[compaction]", brightRedText("[compaction]"));
    });
  }

  function patchSectionSeparators(): void {
    const patchVersion = 17;

    const userPrototype = UserMessageComponent.prototype as SectionPrototype;
    if (userPrototype.__sourdieselSectionSeparatorPatchVersion !== patchVersion) {
      const originalRender = userPrototype.render;
      userPrototype.render = function (this: unknown, width: number): string[] {
        const lines = styleUserMessageLines(
          stripExistingLeadingSeparator(trimOuterBlankLines(originalRender.call(this, width))),
          width,
        );
        return lines.length > 0 ? [sectionSeparator(width), ...lines] : lines;
      };
      userPrototype.__sourdieselSectionSeparatorPatchVersion = patchVersion;
    }

    const assistantPrototype = AssistantMessageComponent.prototype as SectionPrototype;
    if (assistantPrototype.__sourdieselThinkingLabelPatchVersion !== patchVersion) {
      const originalRender = assistantPrototype.render;
      assistantPrototype.render = function (this: unknown, width: number): string[] {
        return recolorThinkingSectionLabels(originalRender.call(this, width));
      };
      assistantPrototype.__sourdieselThinkingLabelPatchVersion = patchVersion;
    }

    const toolPrototype = ToolExecutionComponent.prototype as SectionPrototype;
    if (toolPrototype.__sourdieselSectionSeparatorPatchVersion !== patchVersion) {
      toolPrototype.render = function (this: unknown, width: number): string[] {
        const self = this as ToolExecutionInternals;
        const lines = stripExistingLeadingSeparator(trimOuterBlankLines(renderToolExecutionBase(self, width)));
        const withToolLine = replaceToolCallLine(lines, self.toolName, self.args, width);
        return withToolLine.length > 0 ? [sectionSeparator(width), ...clampRenderedLines(withToolLine, width)] : withToolLine;
      };
      toolPrototype.__sourdieselSectionSeparatorPatchVersion = patchVersion;
    }

    const compactionPrototype = CompactionSummaryMessageComponent.prototype as SectionPrototype;
    if (compactionPrototype.__sourdieselCompactionLabelPatchVersion !== patchVersion) {
      const originalRender = compactionPrototype.render;
      compactionPrototype.render = function (this: unknown, width: number): string[] {
        return recolorCompactionLabel(originalRender.call(this, width));
      };
      compactionPrototype.__sourdieselCompactionLabelPatchVersion = patchVersion;
    }
  }

  function redText(text: string): string {
    return fgHex(envHex("RED_HEX", "#ffc7c7"), text);
  }

  function greenText(text: string): string {
    return fgHex(envHex("GREEN_HEX", "#ceffc9"), text);
  }

  function blueText(text: string): string {
    return fgHex(envHex("BLUE_HEX", "#c4effa"), text);
  }

  function yellowText(text: string): string {
    return fgHex(envHex("YELLOW_HEX", "#fdf7cd"), text);
  }

  function magentaText(text: string): string {
    return fgHex(envHex("MAGENTA_HEX", "#eccef0"), text);
  }

  function brightMagentaText(text: string): string {
    return fgHex(envHex("BRIGHTMAGENTA_HEX", "#c9ccfb"), text);
  }

  function cyanText(text: string): string {
    return fgHex(envHex("CYAN_HEX", "#8ae7c5"), text);
  }

  function brightCyanText(text: string): string {
    return fgHex(envHex("BRIGHTCYAN_HEX", "#47e7b1"), text);
  }

  function brightYellowText(text: string): string {
    return fgHex(envHex("BRIGHTYELLOW_HEX", "#f3b175"), text);
  }

  function brightRedText(text: string): string {
    return fgHex(envHex("BRIGHTRED_HEX", "#f096b7"), text);
  }

  function classifyProviderHarness(
    provider: string | undefined,
    modelId: string | undefined,
  ): HarnessName | undefined {
    const value = `${provider ?? ""} ${modelId ?? ""}`.toLowerCase();
    if (!value.trim()) return undefined;
    if (value.includes("opencode")) return "opencode";
    if (value.includes("cursor")) return "cursor";
    if (value.includes("anthropic") || value.includes("claude"))
      return "claude";
    if (value.includes("codex") || value.includes("openai")) return "codex";
    if (value.includes(" pi") || value === "pi") return "pi";
    return undefined;
  }

  function iconText(
    icon: string,
    text: string,
    iconStyle: (value: string) => string,
    textStyle: (value: string) => string,
  ): string {
    return `${iconStyle(icon)} ${textStyle(text)}`;
  }

  function toolKey(name: string): ToolKey {
    const key = name.toLowerCase();
    if (/^(bash|shell|sh|zsh)$/.test(key)) return "bash";
    return TOOL_ORDER.includes(key as ToolKey) && key !== "other"
      ? (key as ToolKey)
      : "other";
  }

  function toolOwnStyle(key: ToolKey): (value: string) => string {
    const spec = TOOL_SPECS[key];
    return (value: string) => fgHex(envHex(spec.color, spec.fallback), value);
  }

  function toolOwnBoldStyle(key: ToolKey): (value: string) => string {
    const spec = TOOL_SPECS[key];
    return (value: string) =>
      fgHex(envHex(spec.color, spec.fallback), `\x1b[1m${value}\x1b[22m`);
  }

  function toolLabel(name: string, key: ToolKey): string {
    return key === "other" ? name : key;
  }

  function currentTitle(ctx: ExtensionContext): string {
    const name = pi.getSessionName()?.trim();
    if (name) return name;
    const cwdName = basename(ctx.cwd);
    return cwdName || "pi";
  }

  function capture(ctx: ExtensionContext): void {
    state.title = currentTitle(ctx);
    state.modelId = ctx.model?.id;
    state.modelProvider = ctx.model?.provider;
    state.thinkingLevel = pi.getThinkingLevel();
    state.pendingMessages = ctx.hasPendingMessages();

    const usage = ctx.getContextUsage();
    state.contextTokens = usage?.tokens;
    state.contextWindow = usage?.contextWindow;
    state.contextPercent = usage?.percent;
  }

  function rerender(ctx?: ExtensionContext): void {
    if (ctx) capture(ctx);
    requestFooterRender?.();
  }

  function clearGitTimer(): void {
    if (!gitTimer) return;
    clearTimeout(gitTimer);
    gitTimer = undefined;
  }

  function clearFailedToolTimer(): void {
    if (!failedToolTimer) return;
    clearTimeout(failedToolTimer);
    failedToolTimer = undefined;
  }

  function clearCodexQuotaTimer(): void {
    if (!codexQuotaTimer) return;
    clearTimeout(codexQuotaTimer);
    codexQuotaTimer = undefined;
  }

  function clearFailedTool(): void {
    clearFailedToolTimer();
    state.failedTool = undefined;
  }

  function markFailedTool(name: string): void {
    clearFailedToolTimer();
    state.failedTool = {
      key: toolKey(name),
      until: Date.now() + FAILED_TOOL_HIGHLIGHT_MS,
    };
    failedToolTimer = setTimeout(() => {
      failedToolTimer = undefined;
      state.failedTool = undefined;
      requestFooterRender?.();
    }, FAILED_TOOL_HIGHLIGHT_MS);
  }

  function truncateGitName(name: string): string {
    return name.length > 32 ? `${name.slice(0, 12)}…${name.slice(-12)}` : name;
  }

  function shortRemoteBranch(upstream: string | undefined): string | undefined {
    if (!upstream) return undefined;
    const slashIndex = upstream.indexOf("/");
    return slashIndex >= 0 ? upstream.slice(slashIndex + 1) : upstream;
  }

  function gitActionFromGitDir(gitDir: string | undefined, cwd: string): string | undefined {
    if (!gitDir) return undefined;
    const path = isAbsolute(gitDir) ? gitDir : pathJoin(cwd, gitDir);
    if (existsSync(pathJoin(path, "rebase-merge")) || existsSync(pathJoin(path, "rebase-apply"))) return "rebase";
    if (existsSync(pathJoin(path, "MERGE_HEAD"))) return "merge";
    if (existsSync(pathJoin(path, "CHERRY_PICK_HEAD"))) return "cherry-pick";
    if (existsSync(pathJoin(path, "REVERT_HEAD"))) return "revert";
    if (existsSync(pathJoin(path, "BISECT_LOG"))) return "bisect";
    return undefined;
  }

  function parseRevListCounts(stdout: string): { ahead: number; behind: number } {
    const [ahead, behind] = stdout.trim().split(/\s+/).map((value) => Number.parseInt(value, 10));
    return {
      ahead: Number.isFinite(ahead) ? ahead : 0,
      behind: Number.isFinite(behind) ? behind : 0,
    };
  }

  function parseGitStatus(stdout: string): GitSnapshot {
    const snapshot: GitSnapshot = {
      wip: false,
      commitsAhead: 0,
      commitsBehind: 0,
      pushCommitsAhead: 0,
      pushCommitsBehind: 0,
      conflicted: 0,
      staged: 0,
      unstaged: 0,
      stashes: 0,
      untracked: 0,
      unknownDirty: false,
    };

    for (const line of stdout.split(/\r?\n/)) {
      if (!line) continue;
      if (line.startsWith("# branch.head ")) {
        const branch = line.slice("# branch.head ".length).trim();
        if (branch && branch !== "(detached)") snapshot.branch = branch;
        continue;
      }
      if (line.startsWith("# branch.oid ")) {
        const commit = line.slice("# branch.oid ".length).trim();
        if (commit && commit !== "(initial)") snapshot.commit = commit.slice(0, 8);
        continue;
      }
      if (line.startsWith("# branch.upstream ")) {
        const upstream = line.slice("# branch.upstream ".length).trim();
        snapshot.upstream = upstream || undefined;
        const remoteBranch = shortRemoteBranch(upstream);
        if (remoteBranch && remoteBranch !== snapshot.branch) snapshot.remoteBranch = remoteBranch;
        continue;
      }
      const aheadBehind = /^# branch\.ab \+(\d+) -(\d+)$/.exec(line);
      if (aheadBehind) {
        snapshot.commitsAhead = Number.parseInt(aheadBehind[1], 10);
        snapshot.commitsBehind = Number.parseInt(aheadBehind[2], 10);
        continue;
      }
      const stash = /^# stash (\d+)$/.exec(line);
      if (stash) {
        snapshot.stashes = Number.parseInt(stash[1], 10);
        continue;
      }

      const fields = line.split(" ");
      const kind = fields[0];
      if (kind === "1" || kind === "2") {
        const status = fields[1] ?? "..";
        if (status[0] && status[0] !== ".") snapshot.staged++;
        if (status[1] && status[1] !== ".") snapshot.unstaged++;
      } else if (kind === "u") {
        snapshot.conflicted++;
      } else if (kind === "?") {
        snapshot.untracked++;
      }
    }

    return snapshot;
  }

  async function refreshGitDirty(ctx: ExtensionContext): Promise<void> {
    const generation = ++gitGeneration;
    try {
      const statusResult = await pi.exec("git", ["status", "--porcelain=v2", "--branch", "--show-stash"], {
        cwd: ctx.cwd,
        timeout: 1500,
      });
      if (generation !== gitGeneration) return;
      if (statusResult.code !== 0) {
        state.gitStatus = undefined;
        return;
      }

      const gitStatus = parseGitStatus(statusResult.stdout);
      const [summaryResult, tagResult, gitDirResult, pushRefResult] = await Promise.all([
        pi.exec("git", ["log", "-1", "--pretty=%s"], { cwd: ctx.cwd, timeout: 1200 }),
        pi.exec("git", ["describe", "--tags", "--exact-match"], { cwd: ctx.cwd, timeout: 1200 }),
        pi.exec("git", ["rev-parse", "--git-dir"], { cwd: ctx.cwd, timeout: 1200 }),
        pi.exec("git", ["rev-parse", "--abbrev-ref", "--symbolic-full-name", "@{push}"], { cwd: ctx.cwd, timeout: 1200 }),
      ]);
      if (generation !== gitGeneration) return;

      const summary = summaryResult.code === 0 ? summaryResult.stdout.trim() : "";
      gitStatus.wip = /(^|[^A-Za-z0-9])(wip|WIP)($|[^A-Za-z0-9])/.test(summary);
      if (!gitStatus.branch && tagResult.code === 0) gitStatus.tag = tagResult.stdout.trim() || undefined;
      gitStatus.action = gitDirResult.code === 0 ? gitActionFromGitDir(gitDirResult.stdout.trim(), ctx.cwd) : undefined;

      const pushRef = pushRefResult.code === 0 ? pushRefResult.stdout.trim() : "";
      if (pushRef && pushRef !== gitStatus.upstream) {
        const pushCountsResult = await pi.exec("git", ["rev-list", "--left-right", "--count", "HEAD...@{push}"], {
          cwd: ctx.cwd,
          timeout: 1200,
        });
        if (generation !== gitGeneration) return;
        if (pushCountsResult.code === 0) {
          const counts = parseRevListCounts(pushCountsResult.stdout);
          gitStatus.pushCommitsAhead = counts.ahead;
          gitStatus.pushCommitsBehind = counts.behind;
        }
      }

      state.gitStatus = gitStatus;
    } catch {
      if (generation === gitGeneration) state.gitStatus = undefined;
    } finally {
      if (generation === gitGeneration) requestFooterRender?.();
    }
  }

  function scheduleGitDirty(ctx: ExtensionContext, delayMs = 150): void {
    clearGitTimer();
    gitTimer = setTimeout(() => {
      gitTimer = undefined;
      void refreshGitDirty(ctx);
    }, delayMs);
  }

  function isCodexQuotaRelevant(): boolean {
    const value = `${state.modelProvider ?? ""} ${state.modelId ?? ""}`.toLowerCase();
    return value.includes("codex") || value.includes("openai") || /\bgpt[-/]/.test(value);
  }

  function asRecord(value: unknown): Record<string, unknown> | undefined {
    return value !== null && typeof value === "object" && !Array.isArray(value)
      ? value as Record<string, unknown>
      : undefined;
  }

  function parseCodexQuotaWindow(value: unknown): CodexQuotaWindow | undefined {
    const record = asRecord(value);
    if (!record || typeof record.usedPercent !== "number") return undefined;
    return {
      usedPercent: record.usedPercent,
      windowDurationMins: typeof record.windowDurationMins === "number" ? record.windowDurationMins : null,
      resetsAt: typeof record.resetsAt === "number" ? record.resetsAt : null,
    };
  }

  function parseCodexQuotaSnapshot(result: unknown): CodexQuotaSnapshot | undefined {
    const record = asRecord(result);
    if (!record) return undefined;
    const byLimitId = asRecord(record.rateLimitsByLimitId);
    const snapshot = (byLimitId ? asRecord(byLimitId.codex) : undefined) ?? asRecord(record.rateLimits);
    if (!snapshot) return undefined;

    const primary = parseCodexQuotaWindow(snapshot.primary);
    const secondary = parseCodexQuotaWindow(snapshot.secondary);
    if (!primary && !secondary) return undefined;
    return { primary, secondary, fetchedAt: Date.now() };
  }

  function requestCodexQuota(): Promise<CodexQuotaSnapshot | undefined> {
    return new Promise((resolve, reject) => {
      const command = process.env.CODEX_COMMAND || "codex";
      const child: ChildProcessWithoutNullStreams = spawn(command, ["app-server", "--stdio"]);
      let stdoutBuffer = "";
      let stderrBuffer = "";
      let settled = false;

      const finish = (error: Error | undefined, snapshot?: CodexQuotaSnapshot): void => {
        if (settled) return;
        settled = true;
        clearTimeout(timeout);
        child.kill();
        if (error) reject(error);
        else resolve(snapshot);
      };

      const send = (id: number, method: string, params: unknown): void => {
        child.stdin.write(`${JSON.stringify({ method, id, params })}\n`);
      };

      const handleLine = (line: string): void => {
        if (!line.trim()) return;
        let message: unknown;
        try {
          message = JSON.parse(line);
        } catch {
          return;
        }
        const record = asRecord(message);
        if (!record || typeof record.id !== "number") return;
        if (record.error) {
          const error = asRecord(record.error);
          const messageText = typeof error?.message === "string" ? error.message : "Codex quota request failed";
          finish(new Error(messageText));
          return;
        }
        if (record.id === 1) {
          send(2, "account/rateLimits/read", null);
          return;
        }
        if (record.id === 2) {
          finish(undefined, parseCodexQuotaSnapshot(record.result));
        }
      };

      const timeout = setTimeout(() => finish(new Error("Codex quota request timed out")), CODEX_QUOTA_TIMEOUT_MS);

      child.stdout.on("data", (chunk: Buffer) => {
        stdoutBuffer += chunk.toString("utf8");
        let newlineIndex = stdoutBuffer.indexOf("\n");
        while (newlineIndex >= 0) {
          const line = stdoutBuffer.slice(0, newlineIndex);
          stdoutBuffer = stdoutBuffer.slice(newlineIndex + 1);
          handleLine(line);
          newlineIndex = stdoutBuffer.indexOf("\n");
        }
      });
      child.stderr.on("data", (chunk: Buffer) => {
        stderrBuffer = `${stderrBuffer}${chunk.toString("utf8")}`.slice(-1000);
      });
      child.on("error", (error) => finish(error));
      child.on("close", (code) => {
        if (!settled && code !== 0) {
          finish(new Error(stderrBuffer.trim() || `Codex app-server exited with ${code}`));
        }
      });

      send(1, "initialize", {
        clientInfo: { name: "pi-statusline", title: null, version: "0" },
        capabilities: null,
      });
    });
  }

  async function refreshCodexQuota(): Promise<void> {
    if (codexQuotaInFlight || !isCodexQuotaRelevant()) return;
    const generation = ++codexQuotaGeneration;
    codexQuotaInFlight = true;
    try {
      const quota = await requestCodexQuota();
      if (generation === codexQuotaGeneration && quota) state.codexQuota = quota;
    } catch {
      // Keep the last known good quota; this avoids flashing errors for transient Codex app-server failures.
    } finally {
      if (generation === codexQuotaGeneration) {
        codexQuotaInFlight = false;
        requestFooterRender?.();
        if (isCodexQuotaRelevant()) scheduleCodexQuotaRefresh(CODEX_QUOTA_REFRESH_MS);
      }
    }
  }

  function scheduleCodexQuotaRefresh(delayMs = 0): void {
    if (!isCodexQuotaRelevant()) {
      clearCodexQuotaTimer();
      return;
    }
    clearCodexQuotaTimer();
    codexQuotaTimer = setTimeout(() => {
      codexQuotaTimer = undefined;
      void refreshCodexQuota();
    }, delayMs);
  }

  function join(parts: Array<string | undefined>, _theme: Theme): string {
    return parts
      .filter((part): part is string => Boolean(part))
      .join(brightBlackText(GROUP_SEP));
  }

  function phasePart(_theme: Theme): string {
    const phase: Phase =
      state.phase === "idle" && state.pendingMessages ? "waiting" : state.phase;
    switch (phase) {
      case "idle":
        return iconText("○", "idle", greenText, greenText);
      case "thinking":
        return iconText("●", "thinking", yellowText, yellowText);
      case "streaming":
        return iconText("", "streaming", cyanText, cyanText);
      case "tool":
        return iconText(TOOL_ICON, "tool", magentaText, magentaText);
      case "waiting":
        return iconText("󰔚", "queued", brightYellowText, brightYellowText);
      case "error":
        return iconText("", "error", brightRedText, brightRedText);
    }
  }

  function toolPart(_theme: Theme): string | undefined {
    const active = new Map<ToolKey, string[]>();
    for (const name of state.activeTools.values()) {
      const key = toolKey(name);
      active.set(key, [...(active.get(key) ?? []), name]);
    }
    const failed =
      state.failedTool && state.failedTool.until > Date.now()
        ? state.failedTool.key
        : undefined;

    return TOOL_ORDER.map((key) => {
      const spec = TOOL_SPECS[key];
      const activeNames = active.get(key);
      if (activeNames?.length) {
        const iconStyle = toolOwnStyle(key);
        const labelStyle = toolOwnBoldStyle(key);
        const label =
          activeNames.length === 1
            ? toolLabel(activeNames[0], key)
            : `${key}×${activeNames.length}`;
        return `${iconStyle(spec.icon)} ${labelStyle(label)}`;
      }
      const style = failed === key ? brightRedText : brightBlackText;
      return style(spec.icon);
    }).join("  ");
  }

  function modelTextStyle(modelId: string): (value: string) => string {
    const id = modelId.toLowerCase();
    if (id.startsWith("gpt-") || id.includes("/gpt-"))
      return (value: string) => fgHex(envHex("BLUE_HEX", "#c4effa"), value);
    if (id.startsWith("qwen") || id.includes("qwen"))
      return (value: string) =>
        fgHex(envHex("BRIGHTMAGENTA_HEX", "#f096b7"), value);
    return blackText;
  }

  function modelIconStyle(
    theme: Theme,
    modelId: string,
    harness: HarnessName | undefined,
  ): (value: string) => string {
    const id = modelId.toLowerCase();
    if (id.includes("llama"))
      return (value: string) => fgHex(envHex("WHITE_HEX", "#f4f3f2"), value);
    if (harness) return (value: string) => harnessColor(harness, value);
    return (value: string) => theme.fg("accent", value);
  }

  function modelPart(theme: Theme): string | undefined {
    if (!state.modelId) return undefined;
    const harness = classifyProviderHarness(state.modelProvider, state.modelId);
    const compact = compactModel(state.modelId);
    return iconText(
      MODEL_ICON,
      compact,
      modelIconStyle(theme, state.modelId, harness),
      modelTextStyle(state.modelId),
    );
  }

  function thinkingTone(level: ThinkingLevel): {
    iconColor: string;
    iconFallback: string;
    textColor: string;
    textFallback: string;
    label: string;
  } {
    return THINKING_STYLES[level] ?? THINKING_STYLES.off;
  }

  function thinkingPart(_theme: Theme): string | undefined {
    const level = state.thinkingLevel;
    if (!level) return undefined;
    const tone = thinkingTone(level);
    const iconStyle = (value: string) =>
      fgHex(envHex(tone.iconColor, tone.iconFallback), value);
    const textStyle = (value: string) =>
      fgHex(envHex(tone.textColor, tone.textFallback), value);
    return iconText(THINKING_ICON, tone.label, iconStyle, textStyle);
  }

  function tokenPart(_theme: Theme): string | undefined {
    if (!state.contextWindow) return undefined;
    return iconText(
      TOKEN_ICON,
      formatCount(state.contextTokens),
      brightWhiteText,
      brightBlackText,
    );
  }

  function remainingPercentStyle(remaining: number): (value: string) => string {
    return remaining < CONTEXT_CRITICAL_REMAINING_PERCENT
      ? brightRedText
      : remaining < CONTEXT_WARNING_REMAINING_PERCENT
        ? brightYellowText
        : blackText;
  }

  function contextRemainingPart(_theme: Theme): string | undefined {
    if (!state.contextWindow) return undefined;
    if (state.contextPercent === null || state.contextPercent === undefined) {
      return iconText(
        CONTEXT_REMAINING_ICON,
        "?%",
        brightMagentaText,
        blackText,
      );
    }

    const remaining = Math.max(
      0,
      Math.min(100, Math.round(100 - state.contextPercent)),
    );
    const style = remainingPercentStyle(remaining);
    return iconText(CONTEXT_REMAINING_ICON, `${remaining}%`, brightMagentaText, style);
  }

  function approximateWindow(minutes: number, expectedMinutes: number): boolean {
    return minutes >= expectedMinutes * 0.95 && minutes <= expectedMinutes * 1.05;
  }

  function codexQuotaWindowLabel(window: CodexQuotaWindow): string {
    const minutes = window.windowDurationMins;
    if (minutes === null) return "usage";
    if (approximateWindow(minutes, 5 * 60)) return "5h";
    if (approximateWindow(minutes, 7 * 24 * 60)) return "1w";
    if (minutes >= 24 * 60 && minutes % (24 * 60) === 0) return `${minutes / (24 * 60)}d`;
    if (minutes >= 60 && minutes % 60 === 0) return `${minutes / 60}h`;
    return `${minutes}m`;
  }

  function codexQuotaWindowPart(window: CodexQuotaWindow): string {
    const remaining = Math.max(0, Math.min(100, Math.round(100 - window.usedPercent)));
    return `${yellowText(codexQuotaWindowLabel(window))} ${remainingPercentStyle(remaining)(`${remaining}%`)}`;
  }

  function codexQuotaPart(_theme: Theme): string | undefined {
    if (!isCodexQuotaRelevant()) return undefined;
    const quota = state.codexQuota;
    if (!quota) {
      return codexQuotaInFlight
        ? `${yellowText(CODEX_QUOTA_ICON)} ${brightBlackText("…")}`
        : undefined;
    }
    const windows = [quota.primary, quota.secondary].filter(
      (window): window is CodexQuotaWindow => window !== undefined,
    );
    if (windows.length === 0) return undefined;
    const separator = ` ${brightBlackText("/")} `;
    return `${yellowText(CODEX_QUOTA_ICON)} ${windows.map(codexQuotaWindowPart).join(separator)}`;
  }

  function gitPart(
    _theme: Theme,
    footerData: ReadonlyFooterDataProvider,
  ): string | undefined {
    const status = state.gitStatus;
    const fallbackBranch = footerData.getGitBranch();
    const branch = status?.branch ?? fallbackBranch;

    let rendered = "";
    if (branch) {
      rendered = `${blackText("")} ${magentaText(truncateGitName(branch))}`;
    } else if (status?.tag) {
      rendered = `${blackText("#")}${magentaText(truncateGitName(status.tag))}`;
    } else if (status?.commit) {
      rendered = `${blackText("@")}${magentaText(status.commit)}`;
    } else {
      return undefined;
    }

    if (status?.remoteBranch) rendered += `${blackText(":")}${magentaText(truncateGitName(status.remoteBranch))}`;
    if (status?.wip) rendered += ` ${yellowText("WIP")}`;
    if (status?.commitsBehind) rendered += ` ${brightBlueText(` ${status.commitsBehind}`)}`;
    if (status?.commitsAhead) rendered += `${status.commitsBehind ? "" : " "}${brightBlueText(` ${status.commitsAhead}`)}`;
    if (status?.pushCommitsBehind) rendered += ` ${brightBlueText(` ${status.pushCommitsBehind}`)}`;
    if (status?.pushCommitsAhead) rendered += `${status.pushCommitsBehind ? "" : " "}${brightBlueText(` ${status.pushCommitsAhead}`)}`;
    if (status?.action) rendered += ` ${brightRedText(status.action)}`;
    if (status?.conflicted) rendered += ` ${brightRedText(`!${status.conflicted}`)}`;
    if (status?.staged) rendered += ` ${greenText(`+${status.staged}`)}`;
    if (status?.unstaged) rendered += ` ${yellowText(`~${status.unstaged}`)}`;
    if (status?.stashes) rendered += ` ${blackText(`*${status.stashes}`)}`;
    if (status?.untracked) rendered += ` ${redText(`?${status.untracked}`)}`;
    if (status?.unknownDirty) rendered += ` ${yellowText("─")}`;

    return rendered;
  }

  function extensionStatusPart(
    footerData: ReadonlyFooterDataProvider,
    theme: Theme,
  ): string | undefined {
    const statuses = [...footerData.getExtensionStatuses().entries()]
      .filter(([key]) => key !== "better-statusline")
      .map(([key, text]) => {
        if (key !== "ponytail") return text;
        const match = /^([●○]) 🐴 ponytail: (.+)$/.exec(stripRenderedControl(text));
        if (!match) return text;
        const color = match[1] === "●" ? "accent" : "dim";
        return `${theme.fg(color, match[1])} ${theme.fg("muted", "ponytail")} ${theme.fg("text", match[2])}`;
      })
      .filter(Boolean);
    return statuses.length > 0 ? statuses.join(" ") : undefined;
  }

  function renderFooter(
    width: number,
    theme: Theme,
    footerData: ReadonlyFooterDataProvider,
  ): string {
    if (width <= 0) return "";

    const line = join(
      [
        modelPart(theme),
        thinkingPart(theme),
        contextRemainingPart(theme),
        tokenPart(theme),
        codexQuotaPart(theme),
        gitPart(theme, footerData),
        phasePart(theme),
        extensionStatusPart(footerData, theme),
      ],
      theme,
    );

    return truncateToWidth(line, width, "…");
  }

  function installFooter(ctx: ExtensionContext): void {
    if (!state.enabled || ctx.mode !== "tui") return;
    capture(ctx);

    ctx.ui.setFooter((tui, theme, footerData) => {
      const unsubscribeBranch = footerData.onBranchChange(() => {
        scheduleGitDirty(ctx, 50);
        tui.requestRender();
      });
      const renderThisFooter = () => tui.requestRender();
      requestFooterRender = renderThisFooter;

      return {
        dispose() {
          unsubscribeBranch();
          if (requestFooterRender === renderThisFooter)
            requestFooterRender = undefined;
        },
        invalidate() {},
        render(width: number): string[] {
          return [renderFooter(width, theme, footerData)];
        },
      };
    });

    scheduleGitDirty(ctx, 20);
    scheduleCodexQuotaRefresh(20);
    rerender(ctx);
  }

  patchSectionSeparators();

  pi.registerCommand("statusline", {
    description:
      "Toggle the colored custom statusline (usage: /statusline [on|off|toggle])",
    handler: async (args, ctx) => {
      const action = args.trim().toLowerCase() || "toggle";
      const enable =
        action === "on" ? true : action === "off" ? false : !state.enabled;
      state.enabled = enable;

      if (!enable) {
        ctx.ui.setFooter(undefined);
        ctx.ui.notify("Colored statusline disabled", "info");
        return;
      }

      installFooter(ctx);
      ctx.ui.notify("Colored statusline enabled", "info");
    },
  });

  pi.on("session_start", async (_event, ctx) => {
    state.phase = ctx.isIdle() ? "idle" : "thinking";
    state.activeTools.clear();
    state.lastTool = undefined;
    clearFailedTool();
    installFooter(ctx);
  });

  pi.on("session_info_changed", async (_event, ctx) => rerender(ctx));

  pi.on("model_select", async (event, ctx) => {
    state.modelId = event.model.id;
    state.modelProvider = event.model.provider;
    scheduleCodexQuotaRefresh(20);
    rerender(ctx);
  });

  pi.on("thinking_level_select", async (event, ctx) => {
    state.thinkingLevel = event.level;
    rerender(ctx);
  });

  pi.on("before_agent_start", async (_event, ctx) => {
    state.phase = "thinking";
    state.lastTool = undefined;
    clearFailedTool();
    rerender(ctx);
  });

  pi.on("agent_start", async (_event, ctx) => {
    state.phase = "thinking";
    rerender(ctx);
  });

  pi.on("turn_start", async (_event, ctx) => {
    state.phase = "thinking";
    rerender(ctx);
  });

  pi.on("message_start", async (event, ctx) => {
    if (event.message.role === "assistant" && state.activeTools.size === 0) {
      state.phase = "streaming";
      rerender(ctx);
    }
  });

  pi.on("tool_execution_start", async (event, ctx) => {
    state.activeTools.set(event.toolCallId, event.toolName);
    state.lastTool = { name: event.toolName, status: "running" };
    clearFailedTool();
    state.phase = "tool";
    rerender(ctx);
  });

  pi.on("tool_execution_end", async (event, ctx) => {
    state.activeTools.delete(event.toolCallId);
    state.lastTool = {
      name: event.toolName,
      status: event.isError ? "error" : "success",
    };
    if (event.isError) markFailedTool(event.toolName);
    state.phase =
      state.activeTools.size > 0
        ? "tool"
        : event.isError
          ? "error"
          : "thinking";
    rerender(ctx);
    scheduleGitDirty(ctx, 350);
  });

  pi.on("agent_end", async (_event, ctx) => {
    state.phase = ctx.hasPendingMessages() ? "waiting" : "idle";
    rerender(ctx);
    scheduleGitDirty(ctx, 100);
    scheduleCodexQuotaRefresh(1000);
  });

  pi.on("session_shutdown", async (_event, ctx) => {
    clearGitTimer();
    clearFailedToolTimer();
    clearCodexQuotaTimer();
    gitGeneration++;
    codexQuotaGeneration++;
    requestFooterRender = undefined;
    if (ctx.mode === "tui") ctx.ui.setFooter(undefined);
  });
}
