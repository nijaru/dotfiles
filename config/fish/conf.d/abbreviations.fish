#!/usr/bin/env fish
# Fish abbreviations - these expand as you type

if status is-interactive
    # Git abbreviations (more powerful than aliases)
    abbr --add g git
    abbr --add ga 'git add'
    abbr --add gaa 'git add --all'
    abbr --add gc 'git commit --gpg-sign'
    abbr --add gcm --set-cursor 'git commit --gpg-sign -m "%"'
    abbr --add gs 'git status'
    abbr --add gd 'git diff'
    abbr --add gp 'git push'
    abbr --add gpl 'git pull --rebase'
    abbr --add gl 'git log --pretty=format:"%C(green)%h%C(auto)%d %s %C(cyan)%cr %C(blue)<%an>%C(reset)" -n 10'
    abbr --add gf 'git fetch --all --prune'
    abbr --add gsw 'git switch'
    abbr --add gb 'git branch'

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
    abbr --add cpv 'rsync -ah --info=progress2'
    abbr --add mvv 'rsync -ah --remove-source-files --info=progress2'
    abbr --add symlink 'ln -sf'
    abbr --add ef 'exec fish'

    # Package management
    if type -q brew
        # Homebrew abbreviations
        abbr --add up 'brew update && brew upgrade'
        abbr --add brews 'brew search'
        abbr --add brewin 'brew info'
        abbr --add brewi 'brew install'
        abbr --add brewu 'brew update && brew upgrade'
        abbr --add brewx 'brew uninstall'
        abbr --add brewl 'brew list'
        abbr --add brewc 'brew cleanup'
        
        # Homebrew Cask abbreviations
        abbr --add caskin 'brew info --cask'
        abbr --add casks 'brew search --cask'
        abbr --add caski 'brew install --cask'
        abbr --add caskx 'brew uninstall --cask'
        abbr --add caskl 'brew list --cask'
    end

    # Docker abbreviations
    abbr --add d docker
    abbr --add dkc 'docker compose'
    abbr --add dcu 'docker compose up -d'
    abbr --add dcd 'docker compose down'

    # Python abbreviations
    abbr --add py python3
    abbr --add pip 'python3 -m pip'
    abbr --add ve 'python3 -m venv .venv'
    abbr --add va 'source .venv/bin/activate.fish'
end
