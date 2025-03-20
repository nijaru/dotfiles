#!/usr/bin/env fish
# macOS specific configuration and utilities for Fish shell

###################
# Homebrew Management
###################

# Brew commands are now in individual function files in the functions/ directory:
# - brews.fish (brew search)
# - brewin.fish (brew info)
# - brewi.fish (brew install)
# - brewu.fish (brew update && brew upgrade)
# - brewx.fish (brew uninstall)
# - brewl.fish (brew list)
# - brewc.fish (brew cleanup)
# - up.fish (alias for brewu)
# 
# Cask commands are also in individual function files:
# - caskin.fish (brew info --cask)
# - casks.fish (brew search --cask)
# - caski.fish (brew install --cask)
# - caskx.fish (brew uninstall --cask)
# - caskl.fish (brew list --cask)

###################
# macOS Utilities
###################

# System commands
if type -q diskutil
    abbr -a disk "diskutil"
end
if type -q gtar
    abbr -a tar "gtar"
end
abbr -a o "open"
abbr -a o. "open ."
abbr -a oa "open -a"
abbr -a reveal "open -R"
abbr -a finder "open -a Finder"

# File operations
abbr -a showfiles "defaults write com.apple.finder AppleShowAllFiles YES && killall Finder"
abbr -a hidefiles "defaults write com.apple.finder AppleShowAllFiles NO && killall Finder"
if type -q qlmanage
    abbr -a ql "qlmanage -p"
end

# Clipboard operations
abbr -a clip "pbcopy"
abbr -a paste "pbpaste"