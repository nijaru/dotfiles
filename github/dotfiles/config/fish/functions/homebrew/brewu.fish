#!/usr/bin/env fish
# Update and upgrade all Homebrew packages

function brewu --description "Update and upgrade all Homebrew packages"
    brew update && brew upgrade
end