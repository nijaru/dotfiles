function jsonf --description 'Format JSON data'
    # Check if input is from pipe or argument
    if test -t 0 # If argument provided
        if test (count $argv) -eq 0
            echo "Usage: jsonf '<json-string>' or pipe JSON content" >&2
            return 1
        end
        echo $argv[1] | python3 -m json.tool
    else # If piped input
        python3 -m json.tool
    end
end