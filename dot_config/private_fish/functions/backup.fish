function backup --description 'Create timestamped backup of files'
    for file in $argv
        if test -f "$file"
            set -l backup "$file."(date +%Y%m%d_%H%M%S)".bak"
            cp -a "$file" "$backup"; and echo "Backup created: $backup"
        else
            echo "File not found: $file" >&2
            return 1
        end
    end
end