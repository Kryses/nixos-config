#------------------------------------------------------------
# Aliases
# ------------------------------------------------------------

alias cd = z
alias df = cd "~/.dotfiles/bin/dotfiles"
alias op = pass open --timer 10min
alias gp = pass -c 
alias tw = timew
alias ta = task add
alias tw-shift = tw stop and tw start
alias tws = tw summary
alias twd = tw day
alias tmux = tmux -2
alias connect-pipeline = ssh -i (pass work/hl/aws-ssh)

def notes [] {
    cd ~/krys-brain
    nvim
}

#------------------------------------------------------------
# Aliases from qtile tutorial
#------------------------------------------------------------
alias c = clear
alias nf = neofetch
alias pf = pfetch
alias chatgpt = chatgpt --model gpt-4-0125-preview
alias shutdown = systemctl poweroff
alias v = nvim
alias dot = cd ~/dotfiles

# -----------------------------------------------------
# GIT
# -----------------------------------------------------

alias gs = git status
alias ga = git add
alias gc = git commit -m
alias gp = git push
alias gpl = git pull
alias gst = git stash
alias gsp = git stash and git pull
alias gcheck = git checkout
alias gg = lazygit
alias y = yazi

alias work = cd ~/work/repos
alias ayon-workspace = cd ~/work/repos/ayon-workspace


def cwork [] {
    ssh -o ServerAliveInterval=60 (pass work/hl/hal-ssh-ip) -i ~/.ssh/id_rsa -p 22 
}

let flake_dir = $"($env.HOME)/nix"

alias rb = sudo nixos-rebuild switch --flake $flake_dir
alias upd = nix flake update $flake_dir
alias upg = sudo nixos-rebuild switch --upgrade --flake $flake_dir

alias hms = home-manager switch --impure --flake $flake_dir

alias conf = nvim $'($flake_dir)/nixos/configuration.nix'
alias pkgs = nvim $'($flake_dir)/nixos/packages.nix'

alias ll = ls -l
alias v = nvim
alias se = sudoedit
alias ff = fastfetch
