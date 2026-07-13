#!/usr/bin/env bash
set -euo pipefail

herdr_bin="${HERDR_BIN_PATH:-$HOME/.local/bin/herdr}"

# iTerm/Hammerspoon launches can inherit HERDR_* markers from an existing
# client process. Clear them so the floating profile starts an independent
# session instead of tripping Herdr's nested-client guard.
unset HERDR_ENV HERDR_SOCKET_PATH HERDR_CLIENT_SOCKET_PATH HERDR_SESSION
unset HERDR_WORKSPACE_ID HERDR_TAB_ID HERDR_PANE_ID HERDR_ACTIVE_WORKSPACE_ID
unset HERDR_ACTIVE_TAB_ID HERDR_ACTIVE_PANE_ID

exec "$herdr_bin" --session float
