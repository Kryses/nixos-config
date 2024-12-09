{ config, pkgs, ... }:
let
  tmux-floax = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "floax";
    version = "0.1.0";
    src = pkgs.fetchFromGitHub {
      owner = "omerxx";
      repo = "tmux-floax";
      rev = "864ceb9372cb496eda704a40bb080846d3883634";
      sha256 = "sha256-vG8UmqYXk4pCvOjoSBTtYb8iffdImmtgsLwgevTu8pI=";
    };
  };
  tmux-sessionx = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "sessionx";
    version = "0.1.0";
    src = pkgs.fetchFromGitHub {
      owner = "omerxx";
      repo = "tmux-sessionx";
      rev = "0711d0374fe0ace8fd8774396469ab34c5fbf360";
      sha256 = "sha256-9IhXoW9o/ftbhIree+I3vT6r3uNgkZ7cskSyedC3xG4=";
    };
  };
in
{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    prefix = "C-Space";
    sensibleOnTop = true;
    terminal = "screen-256color";
    plugins = [
      {
        plugin = pkgs.tmuxPlugins.catppuccin;
        extraConfig = ''
          set -g @catppuccin_custom_plugin_dir "$HOME/.config/tmux/custom"
          set -g @catppuccin_window_left_separator ""
          set -g @catppuccin_window_right_separator " "
          set -g @catppuccin_window_middle_separator " █"
          set -g @catppuccin_window_number_position "right"
          set -g @catppuccin_window_default_fill "number"
          set -g @catppuccin_window_default_text "#W"
          set -g @catppuccin_window_current_fill "number"
          set -g @catppuccin_window_current_text "#W#{?window_zoomed_flag,(),}"


          set -g @catppuccin_status_left_separator  " "
          set -g @catppuccin_status_right_separator " "
          set -g @catppuccin_status_right_separator_inverse "no"
          set -g @catppuccin_status_fill "icon"
          set -g @catppuccin_status_connect_separator "no"
          set -g @catppuccin_directory_text "#{b:pane_current_path}"


          %hidden MODULE_NAME="github_notifications"
          set -g @catppuccin_github_notifications_color "green"
          set -g @catppuccin_github_notifications_text "#($HOME/.config/tmux/scripts/github_notifications.sh)"

          set -g @catppuccin_task_color "#($HOME/.config/tmux/scripts/task_color.sh)"
          set -g @catppuccin_task_text "(#($HOME/.config/tmux/scripts/timew.sh)) #($HOME/.config/tmux/scripts/task.sh)"

          set -g @catppuccin_project_color "orange"
          set -g @catppuccin_project_text "#($HOME/.config/tmux/scripts/project.sh)"

          set -g @catppuccin_task_status_text "#($HOME/.config/tmux/scripts/task_status.sh)"
          set -g @catppuccin_date_time_text "%H:%M:%S"

          set -g @catppuccin_status_modules_right "github_notifications project task task_status date_time "

        '';

      }
      {
        plugin = tmux-floax;
        extraConfig = ''
          set -g @floax-change-path 'false'
        '';
      }
      {
        plugin = tmux-sessionx;
        extraConfig = ''
          set -g @sessionx-bind 'o'
          set -g @sessionx-window-mode 'on'
          set -g @sessionx-tree-mode 'off'
        '';
      }
      pkgs.tmuxPlugins.sensible
      {
        plugin = pkgs.tmuxPlugins.vim-tmux-navigator;
        extraConfig = ''
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

      }
      pkgs.tmuxPlugins.yank
      pkgs.tmuxPlugins.resurrect
      pkgs.tmuxPlugins.continuum
    ];
    extraConfig = ''
      set-option -sa terminal-overrides ",xterm*,Tc"
      set -g mouse on
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on
      set -g pane-active-border-style 'fg=magenta,bg=default'
      set -g pane-border-style 'fg=brightblack,bg=default'
      # Set Prefix
      unbind C-b

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
      bind j split-window -v -c "#{pane_current_path}"
      bind l split-window -h -c "#{pane_current_path}"
      bind-key R source-file ~/.config/tmux/tmux.conf \; display-message "  Config Reloaded`"

      set -g display-panes-active-colour colour33
      set-option -g status-position top
      set -g status-interval 10

    '';
  };
}
