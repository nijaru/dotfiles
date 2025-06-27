function compress --description 'Create ZIP archive of files or folders'
    set -l input $argv[1]
    set -l output $argv[2]
    
    if test -z "$output"
        set output (basename "$input").zip
    end
    
    if test ! -e "$input"
        echo "Error: '$input' does not exist" >&2
        return 1
    end
    
    zip -r "$output" "$input"
    echo "Created archive: $output"
end