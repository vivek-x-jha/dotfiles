import { readFile } from "node:fs/promises";
import { homedir } from "node:os";
import { join } from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

function skillPath(): string {
  const agentDir = process.env.PI_CODING_AGENT_DIR ?? join(homedir(), ".pi", "agent");
  return join(agentDir, "skills", "handoff", "SKILL.md");
}

/** Expose Pi's handoff skill as the shorter /handoff command. */
export default function (pi: ExtensionAPI) {
  pi.registerCommand("handoff", {
    description: "Create a focused handoff for a new session",
    handler: async (args, ctx) => {
      try {
        const skill = await readFile(skillPath(), "utf8");
        const goal = args.trim();
        pi.sendUserMessage(`${skill}\n\nUser: ${goal}`);
      } catch (error) {
        const detail = error instanceof Error ? error.message : String(error);
        ctx.ui.notify(`Unable to load handoff skill: ${detail}`, "error");
      }
    },
  });
}
