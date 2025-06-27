function gpsuob --description 'Push current branch and set upstream'
    set -l branch $argv[1]
    test -z "$branch"; and set branch (git_current_branch)
    git push --set-upstream origin "$branch"
end