function cat --description 'Use bat as cat if available'
    # This function wraps cat to use bat if available
    # It does not rely on abbr which seems to be causing issues
    if command -v bat >/dev/null 2>&1
        command bat --plain --paging=never $argv
    else
        command cat $argv
    end
end