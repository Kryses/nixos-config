{ config, pkgs, fetchFromGitHub, ... }:
{
  programs.tmux = {
    enable = true;

    baseIndex = 1;
    prefix = "C-Space";
    plugins = with pkgs; [
      tmuxPlugins.catppuccine
      tmuxPlugins.sensible
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.tmux-yank
      tmuxPlugins.tmux-resurrect
      tmuxPlugins.tmux-continuum
    ];
    extraConfig = ''
      set -g @catppuccin_custom_plugin_dir "/home/kryses/.config/tmux/custom"
      set-option -sa terminal-overrides ",xterm*,Tc"
      set -g mouse on
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on
      set -g pane-active-border-style 'fg=magenta,bg=default'
      set -g pane-border-style 'fg=brightblack,bg=default'
      # Set Prefix
      unbind C-b
      set -g prefix C-Space
      bind C-Space send-prefix

      # Shift Alt vim keys for switch windows
      bind -n M-H previous-window
      bind -n M-L next-window

      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      set-window-option -g mode-keys vi

      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      # Open Panel in same directory

      bind j split-window -v -c "#{pane_current_path}"
      bind l split-window -h -c "#{pane_current_path}"
      bind-key R source-file ~/.tmux.conf \; display-message "  Config Reloaded`"


      set -g @sessionx-bind 'o'
      set -g @sessionx-window-mode 'on'
      set -g @sessionx-tree-mode 'on'
      set -g display-panes-active-colour colour33
      set-option -g default-shell /bin/nu
      set-option -g status-position top
      set -g status-interval 10
      set -g @floax-change-path 'false'
      # set -g window-status-format "#I:#W"
      # set -g window-status-current-format "#I:#W"
      set -g @catppuccin_window_left_separator ""
      set -g @catppuccin_window_right_separator " "
      set -g @catppuccin_window_middle_separator " █"
      set -g @catppuccin_window_number_position "right"
      set -g @catppuccin_window_default_fill "number"
      set -g @catppuccin_window_default_text "#W"
      set -g @catppuccin_window_current_fill "number"
      set -g @catppuccin_window_current_text "#W#{?window_zoomed_flag,(),}"

      set -g @catppuccin_status_modules_right "github_notifications project task task_status date_time "

      set -g @catppuccin_status_left_separator  " "
      set -g @catppuccin_status_right_separator " "
      set -g @catppuccin_status_right_separator_inverse "no"
      set -g @catppuccin_status_fill "icon"
      set -g @catppuccin_status_connect_separator "no"
      set -g @catppuccin_directory_text "#{b:pane_current_path}"


      set -g @catppuccin_github_notifications_color "green"
      set -g @catppuccin_github_notifications_text "#($HOME/.config/tmux/scripts/github_notifications.sh)"

      set -g @catppuccin_task_color "#($HOME/.config/tmux/scripts/task_color.sh)"
      set -g @catppuccin_task_text "(#($HOME/.config/tmux/scripts/timew.sh)) #($HOME/.config/tmux/scripts/task.sh)"

      set -g @catppuccin_project_color "orange"
      set -g @catppuccin_project_text "#($HOME/.config/tmux/scripts/project.sh)"

      set -g @catppuccin_task_status_text "#($HOME/.config/tmux/scripts/task_status.sh)"
      set -g @catppuccin_date_time_text "%H:%M:%S"

      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"
      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
      tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
      if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
      if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R
      bind-key -T copy-mode-vi 'C-\' select-pane -l
  '';
  };
}
