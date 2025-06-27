function git_current_branch --description 'Get current branch name'
    git branch --show-current 2>/dev/null
end