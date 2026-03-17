#!/run/current-system/sw/bin/bash
show_github_notifications() {
  local index=$1
  local icon="$(get_tmux_option "@catppuccin_github_notifications_icon" " ")"
  local color="$(get_tmux_option "@catppuccin_github_notifications_color" "$thm_blue")"
  local text="$(get_tmux_option "@catppuccin_github_notifications_text" "Test")"
  local module=$( build_status_module "$index" "$icon" "$color" "$text" )

  echo "$module"
}
