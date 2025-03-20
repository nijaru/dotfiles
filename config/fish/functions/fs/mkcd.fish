function mkcd --description 'Create and enter directory'
    if test (count $argv) -eq 0
        echo "Usage: mkcd <directory>" >&2
        return 1
    end
    
    for dir in $argv
        if mkdir -p "$dir"
            cd "$dir"; or return 1
        else
            echo "Failed to create directory: $dir" >&2
            return 1
        end
    end
end