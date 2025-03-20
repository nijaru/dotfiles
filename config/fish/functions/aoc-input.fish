function aoc-input --description 'Download Advent of Code input'
    # Check for required commands
    if not command_exists curl
        echo "Error: curl command not found" >&2
        return 1
    end
    
    if not command_exists grep
        echo "Error: grep command not found" >&2
        return 1
    end
    
    # Get session cookie from arg or env var
    set -l session_cookie $argv[1]
    test -z "$session_cookie"; and set session_cookie $AOC_SESSION
    
    if test -z "$session_cookie"
        echo "Error: No session cookie provided and AOC_SESSION not set" >&2
        return 1
    end
    
    # Extract year and day from current directory
    set -l year (pwd | grep -oE '[0-9]{4}' | head -1)
    set -l day (basename (pwd) | tr -dc '0-9')
    
    if test -z "$year" -o -z "$day"
        echo "Error: Could not determine year and day from directory name" >&2
        return 1
    end
    
    echo "Downloading input for Year $year, Day $day..."
    curl --silent --cookie "session=$session_cookie" \
        "https://adventofcode.com/$year/day/$day/input" >input.txt
    
    if test $status -eq 0
        echo "Input saved to input.txt"
    else
        echo "Error: Failed to download input" >&2
        return 1
    end
end