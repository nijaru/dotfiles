#!/usr/bin/env fish
# Update chezmoi Brewfile from current Homebrew installations

function brewfile-update -d "Update and sync Brewfile to chezmoi"
    set -l chezmoi_dir ~/.local/share/chezmoi
    set -l brewfile $chezmoi_dir/Brewfile_darwin

    if not command -v brew >/dev/null 2>&1
        echo "Error: Homebrew not installed"
        return 1
    end

    echo "Dumping Brewfile..."
    brew bundle dump --force --file=$brewfile

    cd $chezmoi_dir
    git add Brewfile_darwin
    git commit -m "chore: update Brewfile from brew bundle dump"
    git push

    echo "Brewfile updated and synced"
end
