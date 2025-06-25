#!/usr/bin/env fish
# macOS specific configuration and utilities for Fish shell

###################
# Homebrew Management
###################

# Homebrew abbreviations are defined in dev.fish for consistency with other development tools

###################
# macOS Utilities
###################

# System commands
if type -q diskutil
    abbr --add disk diskutil
end
if type -q gtar
    abbr --add tar gtar
end
abbr --add o open
abbr --add o. 'open .'
abbr --add oa 'open -a'
abbr --add reveal 'open -R'
abbr --add finder 'open -a Finder'

# File operations
abbr --add showfiles 'defaults write com.apple.finder AppleShowAllFiles YES && killall Finder'
abbr --add hidefiles 'defaults write com.apple.finder AppleShowAllFiles NO && killall Finder'
if type -q qlmanage
    abbr --add ql 'qlmanage -p'
end

# Clipboard operations
abbr --add clip pbcopy
abbr --add paste pbpaste