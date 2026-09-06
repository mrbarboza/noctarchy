# Tokyo Night theme for Tmux
# Source: themes/tokyo-night/colors.toml

# Colors
set -g @tokyo-night-bg "#1a1b26"
set -g @tokyo-night-fg "#c0caf5"
set -g @tokyo-night-blue "#7aa2f7"
set -g @tokyo-night-purple "#bb9af7"
set -g @tokyo-night-green "#9ece6a"
set -g @tokyo-night-red "#f7768e"
set -g @tokyo-night-yellow "#e0af68"
set -g @tokyo-night-cyan "#7dcfff"
set -g @tokyo-night-border "#3b4261"
set -g @tokyo-night-selection "#33467c"

# Status bar
set -g status-style "bg=#{@tokyo-night-bg},fg=#{@tokyo-night-fg}"
set -g status-left-style "bg=#{@tokyo-night-blue},fg=#{@tokyo-night-bg}"
set -g status-right-style "bg=#{@tokyo-night-bg},fg=#{@tokyo-night-fg}"
set -g status-justify centre

# Windows
set -g window-style "bg=#{@tokyo-night-bg},fg=#{@tokyo-night-fg}"
set -g window-active-style "bg=#{@tokyo-night-bg},fg=#{@tokyo-night-blue}"

# Panes
set -g pane-border-style "bg=#{@tokyo-night-bg},fg=#{@tokyo-night-border}"
set -g pane-active-border-style "bg=#{@tokyo-night-bg},fg=#{@tokyo-night-blue}"

# Messages
set -g message-style "bg=#{@tokyo-night-selection},fg=#{@tokyo-night-fg}"
set -g message-command-style "bg=#{@tokyo-night-selection},fg=#{@tokyo-night-fg}"
