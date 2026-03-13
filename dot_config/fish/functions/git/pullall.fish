function pullall --description 'Pull all git repos within 2 directories deep'
    find . -maxdepth 2 -name .git -type d -execdir git pull \;
end
