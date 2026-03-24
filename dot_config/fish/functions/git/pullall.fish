function pullall --description 'Pull all git repos within 2 directories deep'
    for git_dir in (find . -maxdepth 2 -name .git -type d | sort)
        set repo (path dirname $git_dir)
        echo ""
        set_color --bold cyan
        echo "── $repo"
        set_color normal
        git -C $repo pull
    end
    echo ""
end
