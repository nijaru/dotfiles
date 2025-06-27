function gadd --description 'Interactive git add with diff preview'
    if not type -q fzf
        echo "fzf is required for this function" >&2
        return 1
    end
    
    set -l files (git status -s | \
        fzf --multi \
            --preview 'git diff --color {2}' \
            --preview-window right:70% \
            --bind 'ctrl-/:change-preview-window(down|hidden|)' \
            --header 'Press CTRL-/ to toggle preview window' \
            --height '80%')
    
    if test -n "$files"
        echo "$files" | awk '{print $2}' | xargs git add
        echo "Added files:"
        echo "$files" | awk '{print "  "$2}'
    end
end