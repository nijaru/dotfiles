function grep --description 'Improved text search'
    if command_exists rg
        command rg $argv
    else
        command grep $argv
    end
end