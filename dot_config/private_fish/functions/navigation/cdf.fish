function cdf --description 'Find and cd into directory using fuzzy search'
    set -l dir_search $argv[1]
    test -z "$dir_search"; and set dir_search .
    
    set -l dir (find $dir_search -type d 2>/dev/null | \
        fzf --preview 'tree -C {} | head -100' \
            --header 'Select directory to enter' \
            --height '40%')
            
    test -n "$dir"; and cd "$dir"
end