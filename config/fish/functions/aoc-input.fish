function aoc-input --description 'Download Advent of Code input'
    set -l session_cookie $argv[1]
    test -z "$session_cookie"; and set session_cookie $AOC_SESSION
    set -l year (pwd | grep -oE '[0-9]{4}' | head -1)
    set -l day (basename (pwd) | tr -dc '0-9')
    curl --cookie "session=$session_cookie" \
        "https://adventofcode.com/$year/day/$day/input" >input.txt
end