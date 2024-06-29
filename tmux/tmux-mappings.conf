# Session Management
bind : command-prompt
bind R source-file ~/.config/tmux/tmux.conf; display-message "⚡tmux reloaded successfully ⚡"
bind S choose-session
bind ^D detach

bind * list-clients
bind ^L refresh-client
bind ^X lock-server

# Window Management
bind '"' choose-window
bind ^C new-window -c "$HOME"
bind r command-prompt "rename-window %%"
bind ^A last-window
bind ^W kill-window

# Pane Management
bind z resize-pane -Z # zoom
bind * setw synchronize-panes
bind P set pane-border-status
bind c kill-pane
bind x swap-pane -D

# Open panes in current directory
bind s split-window -v -c "#{pane_current_path}"
bind v split-window -h -c "#{pane_current_path}"

# Toggle Pane Size
bind -r -T prefix ^H resize-pane -L 5
bind -r -T prefix ^J resize-pane -D 5
bind -r -T prefix ^K resize-pane -U 5
bind -r -T prefix ^L resize-pane -R 5

# Other
bind -T copy-mode-vi v send-keys -X begin-selection
