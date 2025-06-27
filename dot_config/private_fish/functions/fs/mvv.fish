function mvv --description 'Move with progress'
    if command_exists rsync
        rsync -ah --remove-source-files --info=progress2 $argv
    else
        echo "rsync not found, falling back to mv"
        mv $argv
    end
end