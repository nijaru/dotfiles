function timecmd --description 'Profile command execution time'
    set -l start (date +%s)
    eval $argv
    set -l duration (math (date +%s) - $start)
    echo "Execution time: {$duration}s"
end