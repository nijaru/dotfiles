function ping --description 'Graphical ping utility'
    if command_exists gping
        command gping $argv
    else
        command ping $argv
    end
end