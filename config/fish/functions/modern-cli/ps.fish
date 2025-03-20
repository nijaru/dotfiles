function ps --description 'Improved process listing'
    if command_exists procs
        command procs $argv
    else
        command ps $argv
    end
end