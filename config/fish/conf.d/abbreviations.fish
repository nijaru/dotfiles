#!/usr/bin/env fish
# Fish abbreviations - these expand as you type

if status is-interactive
    # Git abbreviations (more powerful than aliases)
    abbr -a g git
    abbr -a ga git add
    abbr -a gaa git add --all
    abbr -a gc git commit --gpg-sign
    abbr -a gcm git commit --gpg-sign -m
    abbr -a gs git status
    abbr -a gd git diff
    abbr -a gp git push
    abbr -a gpl git pull --rebase
    abbr -a gl git log --pretty=format:'%C(green)%h%C(auto)%d %s %C(cyan)%cr %C(blue)<%an>%C(reset)' -n 10
    abbr -a gf git fetch --all --prune
    abbr -a gsw git switch
    abbr -a gb git branch

    # Navigation abbreviations
    abbr -a ... cd ../..
    abbr -a .... cd ../../..
    abbr -a ..... cd ../../../..
    
    # Common directories
    abbr -a dl cd ~/Downloads
    abbr -a dt cd ~/Desktop
    abbr -a dc cd ~/Documents
    abbr -a gh cd ~/github
    
    # Editor abbreviations
    abbr -a e $EDITOR
    abbr -a ez $EDITOR ~/.config/fish/config.fish
    
    # Command improvements
    abbr -a l ls -l
    abbr -a la ls -la
    
    # Package management
    if type -q brew
        abbr -a bi brew install
        abbr -a bu brew update
        abbr -a bug brew upgrade
    end
    
    # Docker abbreviations
    abbr -a d docker
    abbr -a dc docker compose
    abbr -a dcu docker compose up -d
    abbr -a dcd docker compose down
    
    # Python abbreviations
    abbr -a py python3
    abbr -a pip python3 -m pip
    abbr -a ve python3 -m venv .venv
    abbr -a va source .venv/bin/activate.fish
end