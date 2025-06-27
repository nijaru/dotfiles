function cpv --description 'Copy with progress'
    if command_exists rsync
        rsync -ah --info=progress2 $argv
    else
        echo "rsync not found, falling back to cp"
        cp $argv
    end
end