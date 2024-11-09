#!/usr/bin/env zsh

###################
# macOS Configuration
###################
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_BAT=1

# Set keyboard type for z4h
zstyle ':z4h:bindkey' keyboard 'mac'

###################
# Path & Environment
###################
# Ensure homebrew is in path
if [[ $(uname -m) == 'arm64' ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Add additional macOS specific paths
path=(
    "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
    $path
)

# Modular AI
export PATH="$PATH:/Users/nick/.modular/bin"
eval "$(magic completion --shell zsh)"

###################
# Homebrew Management
###################
# Your preferred brew commands
alias up="brewu"
alias brews="brew search"
alias brewin="brew info"
alias brewi="brew install"
alias brewu="brew update && brew upgrade"
alias brewx="brew uninstall"
alias brewl="brew list"
alias brewc="brew cleanup"

# Your preferred cask commands
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
alias oa="open -a"
alias reveal="open -R"
alias finder="open -a Finder"

# Clipboard
alias clip="pbcopy"
alias paste="pbpaste"

# Show/Hide hidden files
alias showfiles="defaults write com.apple.finder AppleShowAllFiles YES && killall Finder"
alias hidefiles="defaults write com.apple.finder AppleShowAllFiles NO && killall Finder"

# Quick Look
alias ql="qlmanage -p"

# Airport utility
alias airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"

###################
# macOS Maintenance
###################
# Clear system caches
alias cleardns="sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
alias clearfonts="sudo atsutil databases -remove"
alias clearmeta="find . -type f -name '*.DS_Store' -ls -delete"

# System update
alias softwareupdate="sudo softwareupdate -i -a"

###################
# Application Shortcuts
###################
# Add common macOS applications
alias typora="open -a Typora"
alias chrome="open -a 'Google Chrome'"
alias safari="open -a Safari"

###################
# Development Tools
###################
# Xcode
alias xcode="open -a Xcode"
alias xcb="xcodebuild"
alias xctest="xcodebuild test"

# iOS Simulator
alias ios="open -a Simulator"

# If orbctl exists, add completion
if (( $+commands[orbctl] )); then
  eval "$(orbctl completion zsh)"
  compdef _orb orbctl
  compdef _orb orb
fi

if [ -x /usr/libexec/path_helper ]; then
    eval $(/usr/libexec/path_helper -s)
fi
