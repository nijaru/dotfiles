#!/usr/bin/env zsh
# macOS specific configuration and utilities

###################
# Homebrew Management
###################

# Brew commands
alias up="brewu"
alias brews="brew search"
alias brewin="brew info"
alias brewi="brew install"
alias brewu="brew update && brew upgrade"
alias brewx="brew uninstall"
alias brewl="brew list"
alias brewc="brew cleanup"

# Cask commands
alias caskin="brew info --cask"
alias casks="brew search --cask"
alias caski="brew install --cask"
alias caskx="brew uninstall --cask"
alias caskl="brew list --cask"

###################
# macOS Utilities
###################

# System commands
alias disk="diskutil"
alias tar="gtar"
alias o="open"
alias o.="open ."
alias oa="open -a"
alias reveal="open -R"
alias finder="open -a Finder"

# File operations
alias showfiles="defaults write com.apple.finder AppleShowAllFiles YES && killall Finder"
alias hidefiles="defaults write com.apple.finder AppleShowAllFiles NO && killall Finder"
alias ql="qlmanage -p"

# Clipboard operations
alias clip="pbcopy"
alias paste="pbpaste"
