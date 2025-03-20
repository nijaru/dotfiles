function brewu --description 'Update Homebrew and upgrade packages'
    brew update && brew upgrade $argv
end