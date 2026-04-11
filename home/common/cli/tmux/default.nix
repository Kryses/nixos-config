{pkgs, ...}:
let
  projectPicker = pkgs.writeTextFile {
    name = "tmux-project-picker";
    executable = true;
    text = ''
      #!${pkgs.nushell}/bin/nu
      def main [parent_pane: string = ""] {
        let dir = (zoxide query --list
          | lines
          | where { |l| ($l | str length) > 0 }
          | str join (char newline)
          | fzf --height=100% --border=none --prompt="project › "
          | str trim)
        if ($dir | is-not-empty) {
          if ($parent_pane | is-not-empty) {
            ^tmux send-keys -t $parent_pane $"cd ($dir)" Enter
          } else {
            let name = ($dir | path basename)
            ^tmux new-session -A -s $name -c $dir
          }
        }
      }
    '';
  };

  claudePreview = pkgs.writeTextFile {
    name = "tmux-claude-preview";
    executable = true;
    text = ''
      #!${pkgs.bash}/bin/bash
      file="$1"
      [[ -f "$file" ]] || { echo "no conversation file"; exit 0; }
      grep -E '"type":"(user|assistant)"' "$file" \
        | tail -10 \
        | ${pkgs.jq}/bin/jq -r '
            if .type == "user" then
              "user: " + (.message.content | if type == "string" then .[0:300] else (map(select(.type == "text") | .text) | join("") | .[0:300]) end)
            else
              "assistant: " + (.message.content | map(select(.type == "text") | .text) | join("") | .[0:300])
            end
          ' 2>/dev/null
    '';
  };

  claudePicker = pkgs.writeTextFile {
    name = "tmux-claude-picker";
    executable = true;
    text = ''
      #!${pkgs.nushell}/bin/nu
      def main [parent_pane: string = ""] {
        let history_file = ($env.HOME | path join ".claude" "history.jsonl")
        if not ($history_file | path exists) { exit 1 }

        let sessions = (open $history_file
          | lines
          | where { |l| ($l | str length) > 2 }
          | each { |l| try { $l | from json } catch { null } }
          | compact
          | where { |s| ($s | get -o sessionId | default "" | str length) > 0 }
          | group-by sessionId
          | items { |_k, v| $v | sort-by timestamp | last }
          | sort-by timestamp --reverse)

        # Field layout: "proj  preview\tsessionId\tproject_path\tconv_file"
        let lines = ($sessions | each { |s|
          let proj = ($s.project | path basename)
          let preview = ($s.display | str replace --all "\n" " " | str replace --all "'" "" | str substring 0..80)
          let encoded = ($s.project | str replace --all "/" "-")
          let conv_file = ($env.HOME | path join ".claude" "projects" $encoded $"($s.sessionId).jsonl")
          $"($proj)  ($preview)\t($s.sessionId)\t($s.project)\t($conv_file)"
        })

        let selected = ($lines
          | str join (char newline)
          | fzf
              --height=100%
              --border=none
              --delimiter="\t"
              --with-nth=1
              --preview="${claudePreview} {4}"
              --preview-window="bottom:40%"
          | str trim)

        if ($selected | is-empty) { exit 0 }

        let parts = ($selected | split row "\t")
        let sid = ($parts | get 1)
        let proj_path = ($parts | get 2)

        if ($parent_pane | is-not-empty) {
          ^tmux send-keys -t $parent_pane $"cd ($proj_path); claude --resume ($sid)" Enter
        } else {
          ^tmux new-window -c $proj_path $"claude --resume ($sid)"
        }
      }
    '';
  };

  sshPicker = pkgs.writeTextFile {
    name = "tmux-ssh-picker";
    executable = true;
    text = ''
      #!${pkgs.nushell}/bin/nu
      let h = (open ~/.ssh/config
        | lines
        | where {|l| ($l | str starts-with "Host ") and not ($l =~ "[*]")}
        | each {|l| $l | str replace "Host " "" | str trim}
        | sort
        | str join (char newline)
        | fzf --height=100% --border=none
        | str trim)
      if ($h | is-not-empty) {
        tmux new-window -n $h $"ssh ($h)"
      }
    '';
  };
in
{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.nushell}/bin/nu";
    prefix = "C-a";
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 50000;
    mouse = true;
    keyMode = "vi";
    terminal = "tmux-256color";

    plugins = with pkgs.tmuxPlugins; [
      sensible
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor 'macchiato'
          set -g @catppuccin_window_status_style 'rounded'
          set -g @catppuccin_status_modules_right "session"
          set -g @catppuccin_status_left_separator ""
          set -g @catppuccin_status_right_separator ""
        '';
      }
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-strategy-nvim 'session'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '10'
        '';
      }
      {
        plugin = tmux-sessionx;
        extraConfig = ''
          set -g @sessionx-bind 'o'
          set -g @sessionx-zoxide-mode 'on'
        '';
      }
      # Floating scratchpad pane — Prefix+Space toggles a persistent popup shell
      {
        plugin = tmux-floax;
        extraConfig = ''
          set -g @floax-width '80%'
          set -g @floax-height '80%'
          set -g @floax-border-color '#8aadf4'
          set -g @floax-text-color '#cad3f5'
          set -g @floax-bind 'Space'
          set -g @floax-change-path 'true'
        '';
      }
      # Vimium-style text picker from scrollback — Prefix+f
      {
        plugin = tmux-thumbs;
        extraConfig = ''
          set -g @thumbs-key 'f'
          set -g @thumbs-command 'echo -n {} | wl-copy'
          set -g @thumbs-upcase-command 'echo -n {} | wl-copy'
        '';
      }
      # fzf URL picker from visible pane content — Prefix+u
      {
        plugin = fzf-tmux-url;
        extraConfig = ''
          set -g @fzf-url-bind 'u'
          set -g @fzf-url-history-limit '2000'
          set -g @fzf-url-open 'xdg-open'
        '';
      }
      # General fzf menu (sessions/windows/panes/etc) — Prefix+F
      { plugin = tmux-fzf; }
      # i3/sway-style tiling layouts
      {
        plugin = tilish;
        extraConfig = ''
          set -g @tilish-default 'main-vertical'
        '';
      }
    ];

    extraConfig = ''
      # Terminal overrides for Ghostty/true color
      set -ag terminal-overrides ",xterm-256color:RGB"
      set -ag terminal-overrides ",ghostty:RGB:XT"

      # Required for yazi image protocol and passthrough queries
      set -g allow-passthrough on

      # Mode indicator (catppuccin macchiato palette)
      set -g status-left "#{?#{==:#{client_key_table},pane-mode},#[bg=#a6da95 fg=#1e2030 bold] PANE ,#{?#{==:#{client_key_table},tab-mode},#[bg=#8aadf4 fg=#1e2030 bold] TAB ,#{?#{==:#{client_key_table},resize-mode},#[bg=#eed49f fg=#1e2030 bold] RESIZE ,#{?#{==:#{client_key_table},move-mode},#[bg=#f5bde6 fg=#1e2030 bold] MOVE ,#[bg=#5b6078 fg=#cad3f5] LOCKED }}}}"

      # ── Popup bindings (no prefix, always active) ─────────────────────────
      bind -n M-y split-window -h -c "#{pane_current_path}" -l 40% "yazi"
      bind -n M-s display-popup -E -w 40% -h 50% "${pkgs.nushell}/bin/nu ${sshPicker}"
      bind -n M-g display-popup -E -d "#{pane_current_path}" -w 95% -h 90% "lazygit"
      bind -n M-p display-popup -E -w 50% -h 60% "${pkgs.nushell}/bin/nu ${projectPicker} #{pane_id}"
      bind -n M-c display-popup -E -w 70% -h 80% "${pkgs.nushell}/bin/nu ${claudePicker} #{pane_id}"

      # ── Alt bindings (no prefix, always active) ───────────────────────────
      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R
      bind -n M-[ previous-window
      bind -n M-] next-window
      bind -n M-z resize-pane -Z
      bind -n M-n split-window -v -c "#{pane_current_path}"
      bind -n M-i swap-window -d -t -1
      bind -n M-o swap-window -d -t +1

      # ── Prefix bindings → enter key tables (zellij-style modes) ──────────
      bind p switch-client -T pane-mode
      bind t switch-client -T tab-mode
      bind r switch-client -T resize-mode
      bind m switch-client -T move-mode
      bind d detach-client

      # ── pane-mode ─────────────────────────────────────────────────────────
      bind -T pane-mode h select-pane -L
      bind -T pane-mode j select-pane -D
      bind -T pane-mode k select-pane -U
      bind -T pane-mode l select-pane -R
      bind -T pane-mode d split-window -v -c "#{pane_current_path}" \; switch-client -T root
      bind -T pane-mode r split-window -h -c "#{pane_current_path}" \; switch-client -T root
      bind -T pane-mode x kill-pane \; switch-client -T root
      bind -T pane-mode z resize-pane -Z \; switch-client -T root
      bind -T pane-mode n new-window -c "#{pane_current_path}" \; switch-client -T root
      bind -T pane-mode Space next-layout \; switch-client -T root
      bind -T pane-mode Escape switch-client -T root
      bind -T pane-mode Enter switch-client -T root

      # ── tab-mode ──────────────────────────────────────────────────────────
      bind -T tab-mode h previous-window
      bind -T tab-mode k previous-window
      bind -T tab-mode l next-window
      bind -T tab-mode j next-window
      bind -T tab-mode n new-window -c "#{pane_current_path}" \; switch-client -T root
      bind -T tab-mode x kill-window \; switch-client -T root
      bind -T tab-mode r command-prompt "rename-window '%%'" \; switch-client -T root
      bind -T tab-mode b break-pane -d \; switch-client -T root
      bind -T tab-mode 1 select-window -t 1 \; switch-client -T root
      bind -T tab-mode 2 select-window -t 2 \; switch-client -T root
      bind -T tab-mode 3 select-window -t 3 \; switch-client -T root
      bind -T tab-mode 4 select-window -t 4 \; switch-client -T root
      bind -T tab-mode 5 select-window -t 5 \; switch-client -T root
      bind -T tab-mode 6 select-window -t 6 \; switch-client -T root
      bind -T tab-mode 7 select-window -t 7 \; switch-client -T root
      bind -T tab-mode 8 select-window -t 8 \; switch-client -T root
      bind -T tab-mode 9 select-window -t 9 \; switch-client -T root
      bind -T tab-mode Escape switch-client -T root
      bind -T tab-mode Enter switch-client -T root

      # ── resize-mode (repeatable) ──────────────────────────────────────────
      bind -T resize-mode -r h resize-pane -L 5
      bind -T resize-mode -r j resize-pane -D 5
      bind -T resize-mode -r k resize-pane -U 5
      bind -T resize-mode -r l resize-pane -R 5
      bind -T resize-mode -r H resize-pane -L 1
      bind -T resize-mode -r J resize-pane -D 1
      bind -T resize-mode -r K resize-pane -U 1
      bind -T resize-mode -r L resize-pane -R 1
      bind -T resize-mode Escape switch-client -T root
      bind -T resize-mode Enter switch-client -T root

      # ── move-mode ─────────────────────────────────────────────────────────
      bind -T move-mode h swap-pane -s '{left-of}'  \; switch-client -T root
      bind -T move-mode j swap-pane -s '{down-of}'  \; switch-client -T root
      bind -T move-mode k swap-pane -s '{up-of}'    \; switch-client -T root
      bind -T move-mode l swap-pane -s '{right-of}' \; switch-client -T root
      bind -T move-mode Escape switch-client -T root

      # ── Copy mode (vi + wl-copy) ──────────────────────────────────────────
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "wl-copy"
      bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "wl-copy"
    '';
  };
}

