import type {
  ExtensionAPI,
  ExtensionContext,
} from "@earendil-works/pi-coding-agent";

const PI_ICON = "π";
const HERDR_METADATA_SOURCE = "pi-thread-title";
const HERDR_REPORT_TIMEOUT_MS = 1200;

let herdrGeneration = 0;

function getThreadTitle(pi: ExtensionAPI): string {
  const name = pi.getSessionName()?.trim();
  return name ? `${PI_ICON} ${name}` : PI_ICON;
}

function getHerdrPaneId(): string | undefined {
  const paneId = process.env.HERDR_PANE_ID?.trim();
  return paneId || undefined;
}

export default function (pi: ExtensionAPI) {
  function reportHerdrTitle(title: string, ctx: ExtensionContext): void {
    const paneId = getHerdrPaneId();
    if (!paneId || process.env.HERDR_ENV !== "1") return;

    const generation = ++herdrGeneration;
    void pi.exec(
      "herdr",
      [
        "pane",
        "report-metadata",
        paneId,
        "--source",
        HERDR_METADATA_SOURCE,
        "--agent",
        "pi",
        "--title",
        title,
        "--display-agent",
        title,
      ],
      { cwd: ctx.cwd, timeout: HERDR_REPORT_TIMEOUT_MS },
    ).catch(() => {
      // Best-effort only: title updates should never break Pi startup/turn flow.
      if (generation === herdrGeneration) return;
    });
  }

  function updateTitle(ctx: ExtensionContext) {
    try {
      const title = getThreadTitle(pi);
      ctx.ui.setTitle(title);
      reportHerdrTitle(title, ctx);
    } catch (error) {
      if (
        error instanceof Error &&
        error.message.includes("extension ctx is stale")
      ) {
        return;
      }
      throw error;
    }
  }

  function updateTitleAfterPiDefaults(ctx: ExtensionContext) {
    updateTitle(ctx);
    setTimeout(() => updateTitle(ctx), 0);
  }

  pi.on("session_start", async (_event, ctx) => {
    updateTitleAfterPiDefaults(ctx);
  });

  pi.on("session_info_changed", async (_event, ctx) => {
    updateTitleAfterPiDefaults(ctx);
  });

  pi.on("agent_end", async (_event, ctx) => {
    updateTitleAfterPiDefaults(ctx);
  });
}
