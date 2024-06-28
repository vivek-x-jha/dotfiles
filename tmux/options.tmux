# Configure True color and 256 palette when possible
set -sa terminal-overrides ",xterm*:Tc"
set -g default-terminal "${TERM}"

# Session Options
set -g status-position top
set -g detach-on-destroy off
set -g escape-time 0
set -g history-limit 1000000
set -g mouse on

# Start windows and panes at 1, not 0
set -g base-index 1
set -g pane-base-index 1
set -g renumber-windows on

setw -g pane-base-index 1
setw -g mode-keys vi
