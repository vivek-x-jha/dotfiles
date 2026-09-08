import { unwatchFile, watchFile } from "node:fs";
import type {
  ExtensionAPI,
  ExtensionContext,
} from "@earendil-works/pi-coding-agent";

const PI_ICON = "π";
const HERDR_METADATA_SOURCE = "pi-thread-title";
const HERDR_SYNC_TIMEOUT_MS = 1200;

function getThreadTitle(pi: ExtensionAPI): string {
  const name = pi.getSessionName()?.trim();
  return name ? `${PI_ICON} ${name}` : PI_ICON;
}

function getHerdrPaneId(): string | undefined {
  const paneId = process.env.HERDR_PANE_ID?.trim();
  return paneId || undefined;
}

export default function (pi: ExtensionAPI) {
  let stopWatchingHerdr: (() => void) | undefined;

  function syncHerdrTitle(title: string, ctx: ExtensionContext): void {
    const paneId = getHerdrPaneId();
    if (!paneId || process.env.HERDR_ENV !== "1") return;

    void Promise.all([
      pi.exec("herdr", ["pane", "rename", paneId, title], {
        cwd: ctx.cwd,
        timeout: HERDR_SYNC_TIMEOUT_MS,
      }),
      pi.exec(
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
        { cwd: ctx.cwd, timeout: HERDR_SYNC_TIMEOUT_MS },
      ),
    ]).catch(() => {
      // Best-effort only: title updates should never break Pi startup/turn flow.
    });
  }

  function updateTitle(ctx: ExtensionContext) {
    try {
      const title = getThreadTitle(pi);
      ctx.ui.setTitle(title);
      syncHerdrTitle(title, ctx);
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

    const socketPath = process.env.HERDR_SOCKET_PATH?.trim();
    if (!socketPath) return;
    const listener = (current: { ino: number }, previous: { ino: number }) => {
      if (current.ino !== previous.ino) updateTitleAfterPiDefaults(ctx);
    };
    watchFile(socketPath, { interval: 1000, persistent: false }, listener);
    stopWatchingHerdr = () => unwatchFile(socketPath, listener);
  });

  pi.on("session_shutdown", async () => {
    stopWatchingHerdr?.();
    stopWatchingHerdr = undefined;
  });

  pi.on("session_info_changed", async (_event, ctx) => {
    updateTitleAfterPiDefaults(ctx);
  });

  pi.on("agent_end", async (_event, ctx) => {
    updateTitleAfterPiDefaults(ctx);
  });
}
