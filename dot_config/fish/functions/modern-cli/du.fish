function du --description 'Improved disk usage analysis'
    if command_exists dust
        command dust $argv
    else
        command du $argv
    end
end