function top --description 'Improved system monitor'
    if command_exists btop
        command btop $argv
    else
        command top $argv
    end
end