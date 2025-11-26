function brew-refresh --description "Refresh cached Homebrew shellenv"
    rm -f "$XDG_CACHE_HOME/fish/brew_shellenv.fish"
    source ~/.config/fish/env.fish
    echo "Homebrew shellenv cache refreshed"
end
