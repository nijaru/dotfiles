#!/usr/bin/env fish
# Git operations and utilities for Fish shell

###################
# Core Commands
###################
alias g="git"
alias gi="git init"

###################
# Status and Information
###################
alias gs="git status"             # Full status
alias gd="git diff --color-words" # Better word diff visualization
alias gdh="git diff HEAD"         # Diff against HEAD
alias gds="git diff --staged"     # Diff staged changes
alias gdc="git diff --cached"     # Same as --staged
alias gwt="git worktree"          # Manage work trees

###################
# Branch Management
###################
# Listing and information
alias gb="git branch -v"                               # Show branches with last commit
alias gbv="git branch -vv"                             # Show branches with tracking info
alias gba="git branch --all --verbose"                 # Show all branches with details
alias gbl="git branch --verbose --sort=-committerdate" # Sort by last commit
alias gbr="git branch --remote"                        # Show remote branches

# Branch operations
alias gbd="git branch -d"             # Safe delete (only merged)
alias gbD="git branch -D"             # Force delete
alias gbc="git branch --show-current" # Show current branch name

# Modern branch switching
alias gsw="git switch"       # Modern way to change branches
alias gswc="git switch -c"   # Create and switch
alias gswm="git switch main" # Quick switch to main
alias gswd="git switch dev"  # Quick switch to dev
alias gswb="git switch -"    # Switch to previous branch

###################
# Staging and Commits
###################
# Staging
alias ga="git add"           # Add specific files
alias ga.="git add ."        # Add current directory
alias gaa="git add --all"    # Add all changes
alias gap="git add --patch"  # Interactive staging
alias gau="git add --update" # Add modified files only
alias grm="git rm"           # Remove files
alias grmc="git rm --cached" # Untrack files

# Unstaging
alias grs="git restore"           # Restore working tree files
alias grss="git restore --staged" # Unstage files
alias grh1="git reset HEAD~1"     # Reset to previous commit
alias gclean="git clean -df"      # Remove untracked files
alias gnuke="git clean -dffx"     # Remove all untracked files (including ignored)

# Commits
alias gc="git commit --gpg-sign"                               # Signed commit
alias gcm="git commit --gpg-sign -m"                           # Commit with message
alias gcic="git commit --gpg-sign -m 'Initial commit'"         # Initial commit
alias gca="git commit --gpg-sign --amend"                      # Amend last commit
alias gcf="git commit --gpg-sign --amend --reuse-message HEAD" # Quick amend keeping message
alias gcF="git commit --gpg-sign --amend"                      # Amend last commit
alias gfix="git commit --gpg-sign --fixup"                     # Create fixup commit for later squashing

###################
# Stash Operations
###################
alias gst="git stash"                      # Quick stash
alias gstp="git stash pop"                 # Pop latest stash
alias gstl="git stash list"                # List stashes
alias gsta="git stash apply"               # Apply stash without removing it
alias gstu="git stash --include-untracked" # Stash including untracked files
alias gstd="git stash drop"                # Drop latest stash
alias gstc="git stash clear"               # Clear all stashes

###################
# Remote Operations
###################
alias gf="git fetch --all --prune"          # Fetch and clean up
alias gpl="git pull --rebase"               # Pull with rebase
alias gp="git push"                         # Normal push
alias gpa="git push --all"                  # Push all branches
alias gpf="git push --force-with-lease"     # Safer force push
alias gpu="git push -u"                     # Set upstream while pushing
alias gpuo="git push -u origin"             # Set upstream while pushing
alias gtrack="git branch --set-upstream-to" # Set tracking branch

###################
# Logging and History
###################
# Basic logs
alias gl="git log --pretty=format:'%C(green)%h%C(auto)%d %s %C(cyan)%cr %C(blue)<%an>%C(reset)' -n 10"
alias gln="git log --pretty=format:'%C(green)%h%C(auto)%d %s %C(cyan)%cr %C(blue)<%an>%C(reset)' -n"
alias glg="git log --graph --pretty=format:'%C(green)%h%C(auto)%d %s %C(cyan)%cr %C(blue)<%an>%C(reset)' -n 20"

# Specialized logs
alias gls="git log --stat"               # Show changed files
alias glp="git log --patch"              # Show changes inline
alias gll="git log --oneline"            # Compact log
alias glf="git log --follow -p"          # Follow file history
alias glast="git log -1 HEAD --stat"     # Show last commit
alias gwho="git shortlog -s --no-merges" # Show commit counts by author

###################
# Merge Operations
###################
alias gm="git merge"               # Basic merge
alias gmnff="git merge --no-ff"    # Merge with no fast-forward
alias gmnc="git merge --no-commit" # Merge without committing
alias gmc="git merge --continue"   # Continue merge
alias gms="git merge --skip"       # Skip merge step
alias gma="git merge --abort"      # Abort merge

###################
# Rebase Operations
###################
alias gr="git rebase"             # Basic rebase
alias gri="git rebase -i"         # Interactive rebase
alias grc="git rebase --continue" # Continue rebase
alias gra="git rebase --abort"    # Abort rebase
alias grm="git rebase main"       # Rebase on main
# alias grs="git rebase --skip"     # Skip rebase step (commented out due to conflict)

###################
# Maintenance
###################
alias greflog="git reflog"                       # Show reference logs
alias gverify="git verify-commit HEAD"           # Verify last commit signature
alias gcleanup="git clean -xfd"                  # Remove untracked and ignored files
alias ggarbage="git gc --aggressive --prune=now" # Clean repository

###################
# Git Functions
###################

# Git functions are now in functions/ directory
# - git_current_branch.fish - Get current branch name
# - gpsuob.fish - Push current branch and set upstream
# - gswitch.fish - Interactive branch switching with log preview
# - git-clean.fish - Clean up merged branches
# - git-prune.fish - Prune remote branches and tags
# - gadd.fish - Interactive git add with diff preview