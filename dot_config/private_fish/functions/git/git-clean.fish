function git-clean --description 'Clean up merged branches'
    set -l branches (git branch --merged | grep -v '^\*' | grep -vE '^(\+|\s*master\s*|\s*main\s*|\s*dev\s*)$')
    
    if test -z "$branches"
        echo "No merged branches to clean up"
        return 0
    end
    
    echo "The following branches will be deleted:"
    echo "$branches"
    
    read -l -P "Proceed with deletion? [y/N] " confirm
    
    if test "$confirm" = "y"
        echo "$branches" | xargs git branch -d
        echo "Branches cleaned up"
    end
end