function gswitch --description 'Interactive branch switching with log preview'
    if not type -q fzf
        echo "fzf is required for this function" >&2
        return 1
    end
    
    set -l branch (git branch --all | \
        grep -v HEAD | \
        fzf --preview 'git log --color --graph --date=short --pretty=format:"%C(auto)%cd %h%d %s" {1}' \
            --preview-window right:70% \
            --bind 'ctrl-/:change-preview-window(down|hidden|)' \
            --header 'Press CTRL-/ to toggle preview window' | \
        sed 's/.* //')
    
    if test -n "$branch"
        git switch (string replace -r 'remotes/origin/' '' -- "$branch")
    end
end