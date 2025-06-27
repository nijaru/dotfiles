#!/usr/bin/env fish
# Git abbreviations for Fish - expands as you type

if status is-interactive
    # Core commands
    abbr --add g git
    abbr --add gi 'git init'
    
    # Status and Information
    abbr --add gs 'git status'
    abbr --add gd 'git diff --color-words'
    abbr --add gdh 'git diff HEAD'
    abbr --add gds 'git diff --staged'
    abbr --add gdc 'git diff --cached'
    abbr --add gwt 'git worktree'
    
    # Branch Management
    abbr --add gb 'git branch -v'
    abbr --add gbv 'git branch -vv'
    abbr --add gba 'git branch --all --verbose'
    abbr --add gbl 'git branch --verbose --sort=-committerdate'
    abbr --add gbr 'git branch --remote'
    abbr --add gbd 'git branch -d'
    abbr --add gbD 'git branch -D'
    abbr --add gbc 'git branch --show-current'
    
    # Branch switching
    abbr --add gsw 'git switch'
    abbr --add gswc 'git switch -c'
    abbr --add gswm 'git switch main'
    abbr --add gswd 'git switch dev'
    abbr --add gswb 'git switch -'
    
    # Staging
    abbr --add ga 'git add'
    abbr --add ga. 'git add .'
    abbr --add gaa 'git add --all'
    abbr --add gap 'git add --patch'
    abbr --add gau 'git add --update'
    abbr --add grm 'git rm'
    abbr --add grmc 'git rm --cached'
    
    # Unstaging
    abbr --add grs 'git restore'
    abbr --add grss 'git restore --staged'
    abbr --add grh1 'git reset HEAD~1'
    abbr --add gclean 'git clean -df'
    abbr --add gnuke 'git clean -dffx'
    
    # Commits
    abbr --add gc 'git commit --gpg-sign'
    abbr --add gcm --set-cursor 'git commit --gpg-sign -m "%"'
    abbr --add gcic 'git commit --gpg-sign -m "Initial commit"'
    abbr --add gca 'git commit --gpg-sign --amend'
    abbr --add gcf 'git commit --gpg-sign --amend --reuse-message HEAD'
    abbr --add gcF 'git commit --gpg-sign --amend'
    abbr --add gfix 'git commit --gpg-sign --fixup'
    
    # Stash
    abbr --add gst 'git stash'
    abbr --add gstp 'git stash pop'
    abbr --add gstl 'git stash list'
    abbr --add gsta 'git stash apply'
    abbr --add gstu 'git stash --include-untracked'
    abbr --add gstd 'git stash drop'
    abbr --add gstc 'git stash clear'
    
    # Remote operations
    abbr --add gf 'git fetch --all --prune'
    abbr --add gpl 'git pull --rebase'
    abbr --add gp 'git push'
    abbr --add gpa 'git push --all'
    abbr --add gpf 'git push --force-with-lease'
    abbr --add gpu 'git push -u'
    abbr --add gpuo 'git push -u origin'
    abbr --add gtrack 'git branch --set-upstream-to'
    
    # Logging
    abbr --add gl 'git log --pretty=format:"%C(green)%h%C(auto)%d %s %C(cyan)%cr %C(blue)<%an>%C(reset)" -n 10'
    abbr --add gln 'git log --pretty=format:"%C(green)%h%C(auto)%d %s %C(cyan)%cr %C(blue)<%an>%C(reset)" -n'
    abbr --add glg 'git log --graph --pretty=format:"%C(green)%h%C(auto)%d %s %C(cyan)%cr %C(blue)<%an>%C(reset)" -n 20'
    abbr --add gls 'git log --stat'
    abbr --add glp 'git log --patch'
    abbr --add gll 'git log --oneline'
    abbr --add glf 'git log --follow -p'
    abbr --add glast 'git log -1 HEAD --stat'
    abbr --add gwho 'git shortlog -s --no-merges'
    
    # Merge
    abbr --add gm 'git merge'
    abbr --add gmnff 'git merge --no-ff'
    abbr --add gmnc 'git merge --no-commit'
    abbr --add gmc 'git merge --continue'
    abbr --add gms 'git merge --skip'
    abbr --add gma 'git merge --abort'
    
    # Rebase
    abbr --add gr 'git rebase'
    abbr --add gri 'git rebase -i'
    abbr --add grc 'git rebase --continue'
    abbr --add gra 'git rebase --abort'
    abbr --add grm 'git rebase main'
    
    # Maintenance
    abbr --add greflog 'git reflog'
    abbr --add gverify 'git verify-commit HEAD'
    abbr --add gcleanup 'git clean -xfd'
    abbr --add ggarbage 'git gc --aggressive --prune=now'
end