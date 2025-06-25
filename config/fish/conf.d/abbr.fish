#!/usr/bin/env fish
# Fish abbreviations - these expand as you type

if status is-interactive
    # Navigation abbreviations
    abbr --add ... 'cd ../..'
    abbr --add .... 'cd ../../..'
    abbr --add ..... 'cd ../../../..'
    abbr --add -- - 'cd -'

    # Common directories
    abbr --add dl 'cd ~/Downloads'
    abbr --add dt 'cd ~/Desktop'
    abbr --add doc 'cd ~/Documents'
    abbr --add ghub 'cd ~/github'
    abbr --add p 'cd ~/Projects'

    # Editor abbreviations - moved to a separate file to ensure $EDITOR is set

    # Command improvements
    abbr --add l 'ls -1'
    abbr --add ll 'ls -l'
    abbr --add la 'ls -a'
    abbr --add lsa 'ls -a'
    abbr --add lla 'ls -la'
    abbr --add lt 'ls -T'
    abbr --add llt 'ls -T -l'
    abbr --add ltd 'ls -T -L'
    abbr --add lltd 'ls -T -l -L'
    abbr --add tree 'ls -T'
    abbr --add diff 'delta'
    abbr --add preview "fzf --preview 'bat --color=always {}'"
    abbr --add top 'btop'
    abbr --add df 'duf'
    abbr --add du 'dust'
    abbr --add ps 'procs'
    abbr --add dig 'doggo'
    abbr --add ping 'gping'
    abbr --add hypf 'hyperfine -N --warmup 5'

    # File operations
    abbr --add t 'touch'
    abbr --add rmd 'rmdir'
    abbr --add rmrf 'rm -rf'
    abbr --add mkd 'mkdir -pv'
    abbr --add cp 'cp -a'
    abbr --add cpa 'cp -a'
    abbr --add cpv 'rsync -ah --info=progress2'
    abbr --add mvv 'rsync -ah --remove-source-files --info=progress2'
    abbr --add symlink 'ln -sf'
    abbr --add ef 'exec fish'

    # Package management, Docker, and Python abbreviations are in their respective dev files
end
