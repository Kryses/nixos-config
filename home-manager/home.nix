{ pkgs, ... }:
{
  imports = [
    ./zsh.nix
    ./modules/bundle.nix
  ];

  home = {
    username = "kryses";
    homeDirectory = "/home/kryses";
    stateVersion = "23.11";
  };
  home.file = {
    ".config/ohmyposh".source = ~/dotfiles/ohmyposh;
    ".config/tmux/custom".source = ~/dotfiles/tmux/custom;
    ".config/tmux/scripts".source = ~/dotfiles/tmux/scripts;
    ".config/bugwarrior".source = ~/dotfiles/bugwarrior;
    ".config/task".source = ~/dotfiles/task;
    "scripts".source = ~/dotfiles/scripts;
    ".taskrc".source = ~/dotfiles/.taskrc;
    ".gitignore_global".source = ~/dotfiles/.gitignore_global;
    ".gitconfig".source = ~/dotfiles/gitconfig;
  };
  systemd.user.services.work-sync = {
    Unit = {
      Description = "WorkSync";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      Restart = "always";
      WorkingDirectory = "/home/kryses/work/repos";
      ExecStart = "${pkgs.writeShellScript "work-sync" ''

      REMOTE_USER="kryses"
      REMOTE_HOST="10.205.42.100"
      REMOTE_PATH="/mnt/e/development"
      MONITOR_DIR=./ayon-workspace
      handle_change() {
          local path=$1
          read filename event <<< "$2"
          
          echo "Detected $event for file: $filename"
          echo "Sending: $REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH/$filename"
          # Upload the file using rsync
          rsync -avz "$filename" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH/$filename"
      }
      inotifywait -m -r --format '%e %w%f' --exclude '\.git/|\.kryses/|\.mypy_cache|__pycache__/|\./null-ls/.*/' -e modify -e create -e move ./ayon-workspace |
      while read event filename; do
        handle_change "$event" "$filename"
      done
      ''}";

    };
  };
}
