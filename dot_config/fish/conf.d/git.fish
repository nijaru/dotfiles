#!/usr/bin/env fish
# Git abbreviations

# Basic commands
abbr --add g git
abbr --add gs 'git status'
abbr --add ga 'git add'
abbr --add gaa 'git add --all'
abbr --add gc 'git commit'
abbr --add gcm 'git commit -m'
abbr --add gca 'git commit --amend'
abbr --add gcan 'git commit --amend --no-edit'

# Branch operations
abbr --add gb 'git branch'
abbr --add gco 'git checkout'
abbr --add gcb 'git checkout -b'
abbr --add gm 'git merge'
abbr --add gd 'git diff'
abbr --add gds 'git diff --staged'

# Remote operations
abbr --add gp 'git push'
abbr --add gpf 'git push --force-with-lease'
abbr --add gpl 'git pull'
abbr --add gf 'git fetch'
abbr --add gfa 'git fetch --all --prune'

# Log and history
abbr --add gl 'git log --oneline'
abbr --add glg 'git log --graph --oneline --decorate'
abbr --add gll 'git log --graph --pretty=format:"%C(yellow)%h%C(reset) %C(blue)%an%C(reset) %C(cyan)%ar%C(reset) %s"'

# Stash
abbr --add gst 'git stash'
abbr --add gstp 'git stash pop'
abbr --add gstl 'git stash list'

# Reset and clean
abbr --add grh 'git reset --hard'
abbr --add grs 'git reset --soft'
abbr --add gclean 'git clean -fd'