function hypf --description 'Benchmark commands with hyperfine'
    if command_exists hyperfine
        command hyperfine -N --warmup 5 $argv
    else
        echo "hyperfine not found"
        return 1
    end
end