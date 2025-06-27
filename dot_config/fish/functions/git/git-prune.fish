function git-prune --description 'Prune remote branches and tags'
    echo "Fetching remote changes..."
    git fetch --prune
    
    echo "Pruning remote branches..."
    git remote prune origin
    
    echo "Pruning local references..."
    git gc --prune=now
    
    echo "Cleanup complete"
end