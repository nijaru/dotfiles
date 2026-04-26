# config.nu — Nushell configuration

# ── Settings ────────────────────────────────────────────
$env.config.show_banner = false
$env.config.buffer_editor = "zed --wait"
$env.config.rm.always_trash = true
$env.config.error_style = "short"

$env.config.history = {
    file_format: sqlite
    max_size: 1_000_000
    sync_on_enter: true
    isolation: true
}

$env.config.completions.case_sensitive = false
$env.config.completions.quick = true
$env.config.completions.partial = true
$env.config.completions.algorithm = "fuzzy"
$env.config.completions.use_ls_colors = true

$env.config.table.mode = "compact"
$env.config.table.index_mode = "auto"
$env.config.table.show_empty = true
$env.config.table.padding = { left: 1, right: 1 }
$env.config.table.trim = { methodology: wrapping, wrapping_try_keep_words: true }

# ── Environment ─────────────────────────────────────────
$env.EDITOR = "zed"
$env.VISUAL = "zed --wait"
$env.BAT_THEME = "Catppuccin Macchiato"

$env.XDG_CONFIG_HOME = ($env.HOME | path join ".config")
$env.XDG_CACHE_HOME = ($env.HOME | path join ".cache")
$env.XDG_DATA_HOME = ($env.HOME | path join ".local/share")
$env.XDG_STATE_HOME = ($env.HOME | path join ".local/state")

$env.PYTHONDONTWRITEBYTECODE = 1
$env.PYTHONUNBUFFERED = 1
$env.PYTHONFAULTHANDLER = 1

$env.GOPATH = ($env.HOME | path join "go")
$env.GOBIN = ($env.GOPATH | path join "bin")
$env.GOTOOLCHAIN = "local"
$env.GOFLAGS = "-buildvcs=false -trimpath"

$env.CARGO_HOME = ($env.HOME | path join ".cargo")
$env.RUSTUP_HOME = ($env.HOME | path join ".rustup")
$env.RUST_BACKTRACE = 1
$env.OPENCODE_DISABLE_CLAUDE_CODE_SKILLS = "1"

# ── PATH ────────────────────────────────────────────────
use std/util "path add"
path add ($env.HOME | path join ".local/bin")
path add ($env.HOME | path join ".modular/bin")
path add ($env.HOME | path join ".pixi/bin")
path add ($env.HOME | path join ".local/share/gem/bin")
path add ($env.HOME | path join "go/bin")
path add ($env.HOME | path join ".cargo/bin")
path add ($env.HOME | path join ".cache/.bun/bin")
path add ($env.HOME | path join ".local/share/mise/shims")

# ── Custom Commands ─────────────────────────────────────
def xpost [url: string] {
    ^yt-dlp --dump-json $url err> /dev/null | from json | select description uploader uploader_id upload_date like_count repost_count webpage_url
}

def pullall [] {
    let repos = (^find . -maxdepth 2 -name .git -type d | lines | sort | each { |it| $it | path dirname })
    for repo in $repos {
        print ""
        print $"(ansi cyan_bold)── ($repo)(ansi reset)"
        try {
            ^git -C $repo pull
        } catch { |err|
            print $"(ansi red_bold)  error: ($err.msg)(ansi reset)"
        }
    }
    print ""
}

# ── Aliases ─────────────────────────────────────────────

# Navigation
alias ll = ls
alias la = ls -a
alias lla = ls -a

# Directory shortcuts
def --env ... [] { cd ../.. }
def --env .... [] { cd ../../.. }
def --env ..... [] { cd ../../../.. }
def --env dl [] { cd ~/Downloads }
def --env dt [] { cd ~/Desktop }
def --env doc [] { cd ~/Documents }
def --env ghub [] { cd ~/github }
def --env p [] { cd ~/Projects }

# Editor
alias z. = zed .
alias nv. = nvim .
alias hx. = hx .

# Agents
alias cl = claude
alias clc = claude --continue

# File operations
alias mkd = mkdir
alias t = touch
alias cpv = rsync -ah --info=progress2
alias mvv = rsync -ah --remove-source-files --info=progress2

# Tools
alias y = yazi
alias hypf = hyperfine -N --warmup 5
alias py = python3
alias bungi = bun install -g

# Go
alias ggu = go get -u ./...
alias gmt = go mod tidy

# opencode
alias oc = opencode
alias occ = opencode --continue

# macOS
alias o = open
alias "o." = open .
alias clip = pbcopy
alias paste = pbpaste

# Docker
alias d = docker
alias dc = docker compose

# Git — core
alias g = git
alias gi = git init
alias gs = git status
alias gd = git diff --color-words
alias gdh = git diff HEAD
alias gds = git diff --staged
alias gdc = git diff --cached
alias gwt = git worktree

# Git — branches
alias gb = git branch -v
alias gbv = git branch -vv
alias gba = git branch --all --verbose
alias gbl = git branch --verbose --sort=-committerdate
alias gbr = git branch --remote
alias gbd = git branch -d
alias gbD = git branch -D
alias gbc = git branch --show-current

# Git — switching
alias gsw = git switch
alias gswc = git switch -c
alias gswm = git switch main
alias gswd = git switch dev
alias gswb = git switch -

# Git — staging
alias ga = git add
alias ga. = git add .
alias gaa = git add --all
alias gap = git add --patch
alias gau = git add --update
alias grm = git rm
alias grmm = git rebase main
alias grmc = git rm --cached

# Git — unstaging
alias grs = git restore
alias grss = git restore --staged
alias grh1 = git reset HEAD~1
alias gclean = git clean -df
alias gnuke = git clean -dffx

# Git — commits
alias gc = git commit --gpg-sign
alias gcm = git commit --gpg-sign -m
alias gca = git commit --gpg-sign --amend
alias gcic = git commit --gpg-sign -m "Initial commit"
alias gcf = git commit --gpg-sign --amend --reuse-message HEAD
alias gcF = git commit --gpg-sign --amend
alias gcan = git commit --gpg-sign --amend --no-edit
alias gfix = git commit --gpg-sign --fixup

# Git — stash
alias gst = git stash
alias gstp = git stash pop
alias gstl = git stash list
alias gsta = git stash apply
alias gstu = git stash --include-untracked
alias gstd = git stash drop
alias gstc = git stash clear

# Git — remote
alias gf = git fetch --all --prune
alias gpl = git pull --rebase
alias gp = git push
alias gpa = git push --all
alias gpf = git push --force-with-lease
alias gpu = git push -u
alias gpuo = git push -u origin
alias gtrack = git branch --set-upstream-to

# Git — log
alias gl = git log --pretty=format:"%C(green)%h%C(auto)%d %s %C(cyan)%cr %C(blue)<%an>%C(reset)" -n 10
alias gln = git log --pretty=format:"%C(green)%h%C(auto)%d %s %C(cyan)%cr %C(blue)<%an>%C(reset)" -n
alias glg = git log --graph --pretty=format:"%C(green)%h%C(auto)%d %s %C(cyan)%cr %C(blue)<%an>%C(reset)" -n 20
alias gls = git log --stat
alias glp = git log --patch
alias gll = git log --oneline
alias glf = git log --follow -p
alias glast = git log -1 HEAD --stat
alias gwho = git shortlog -s --no-merges

# Git — merge
alias gm = git merge
alias gmnff = git merge --no-ff
alias gmnc = git merge --no-commit
alias gmc = git merge --continue
alias gms = git merge --skip
alias gma = git merge --abort

# Git — rebase
alias gr = git rebase
alias gri = git rebase -i
alias grc = git rebase --continue
alias gra = git rebase --abort

# Git — maintenance
alias greflog = git reflog
alias gverify = git verify-commit HEAD
alias gcleanup = git clean -xfd
alias ggarbage = git gc --aggressive --prune=now
alias gsubr = git config submodule.recurse true

def llm-serve [
    command?: string
    --file (-f): string = "Qwen3.6-27B-UD-Q4_K_XL.gguf"
    --served-name: string = "qwen3.6:27b"
    --ctx (-c): int = 262144
    --batch (-b): int = 2048
    --ubatch: int = 512
    --port (-p): int = 8080
    --host (-H): string = "0.0.0.0"
    --unc
    --uncensored
    --download-only
    --verify-only
] {
    let run_input = ($command | default "help")
    let command = (if ($run_input | str starts-with "-") { "serve" } else { $run_input })
    let variant_uncensored = ($unc or $uncensored)
    let variant_selected = $variant_uncensored
    let default_file = "Qwen3.6-27B-UD-Q4_K_XL.gguf"
    let default_served_name = "qwen3.6:27b"
    let variants = [
        {
            unit: "llm-serve"
            model: "unsloth/Qwen3.6-27B-GGUF"
            file: "Qwen3.6-27B-UD-Q4_K_XL.gguf"
            served_name: "qwen3.6:27b"
            pattern: 'llama-server .*models--unsloth--Qwen3\.6-27B-GGUF|llama-server .*--alias qwen3\.6:27b($| )'
            name: "regular Qwen3.6 27B"
            stop_command: "llm-serve stop"
        }
        {
            unit: "llm-serve-uncensored"
            model: "HauhauCS/Qwen3.6-27B-Uncensored-HauhauCS-Aggressive"
            file: "Qwen3.6-27B-Uncensored-HauhauCS-Aggressive-Q4_K_P.gguf"
            served_name: "qwen3.6:27b-uncensored"
            pattern: 'llama-server .*models--HauhauCS--Qwen3\.6-27B-Uncensored-HauhauCS-Aggressive|llama-server .*--alias qwen3\.6:27b-uncensored($| )'
            name: "uncensored Qwen3.6 27B"
            stop_command: "llm-serve stop --unc"
        }
    ]
    let selected = (if $variant_uncensored {
        $variants | where unit == "llm-serve-uncensored" | first
    } else {
        $variants | where unit == "llm-serve" | first
    })
    let model = $selected.model
    let file = (if $file == $default_file { $selected.file } else { $file })
    let served_name = (if $served_name == $default_served_name { $selected.served_name } else { $served_name })
    let port = $port
    let unit = $selected.unit
    let pattern = $selected.pattern

    if $command in ["help", "-h", "--help"] {
        print "Usage: llm-serve [serve|start|stop|restart|status] [options]"
        print ""
        print "Options:"
        print "  --unc            use HauhauCS Aggressive uncensored defaults"
        print "  --file, -f        GGUF filename within the HF repo (default Qwen3.6-27B-UD-Q4_K_XL.gguf)"
        print "  --served-name     OpenAI model id exposed by llama-server (default qwen3.6:27b)"
        print "  --port, -p        listen port (default 8080 for both variants)"
        print "  --host, -H        bind address (default 0.0.0.0)"
        print "  --ctx, -c         max context length (default 262144)"
        print "  --batch, -b       llama.cpp logical batch size (default 2048)"
        print "  --ubatch          llama.cpp physical microbatch size (default 512)"
        print "  --download-only   prefetch model and exit"
        print "  --verify-only     verify tooling/auth/model snapshot, then exit"
        return
    }

    if $command == "stop" {
        let targets = (if $variant_selected { [$selected] } else { $variants })
        for target in $targets {
            if (which systemctl | is-not-empty) { systemctl --user stop $"($target.unit).service" err> /dev/null }
        }
        for target in $targets {
            if (which pkill | is-not-empty) { pkill -f $target.pattern err> /dev/null }
        }
        return
    }

    if $command == "status" {
        if (which systemctl | is-not-empty) and ((systemctl --user is-active --quiet $"($unit).service"; $env.LAST_EXIT_CODE) == 0) {
            systemctl --user status $"($unit).service" --no-pager
            return
        }
        if (which pgrep | is-not-empty) { pgrep -af $pattern }
        return
    }

    mut run_command = $command
    if $command == "restart" {
        if (which systemctl | is-not-empty) { systemctl --user stop $"($unit).service" err> /dev/null }
        if (which pkill | is-not-empty) { pkill -f $pattern err> /dev/null }
        $run_command = "start"
    }

    if not ($run_command in ["serve", "start"]) {
        error make {msg: $"llm-serve: unknown command ($command)"}
    }
    if not ($download_only or $verify_only) {
        for other in ($variants | where unit != $unit) {
            if (which systemctl | is-not-empty) and ((systemctl --user is-active --quiet $"($other.unit).service"; $env.LAST_EXIT_CODE) == 0) {
                error make {msg: $"llm-serve: ($other.name) is already running as ($other.unit).service; stop it first: ($other.stop_command)"}
            }
            if (which pgrep | is-not-empty) {
                let matching_processes = (pgrep -af $other.pattern | complete)
                if $matching_processes.exit_code == 0 {
                    error make {msg: $"llm-serve: ($other.name) is already running\n($matching_processes.stdout)"}
                }
            }
        }
    }
    if (which llama-server | is-empty) { error make {msg: "llm-serve: llama-server not found; build llama.cpp with CUDA and put it on PATH"} }
    if (which hf | is-empty) { error make {msg: "llm-serve: hf not found; install Hugging Face CLI"} }
    hf auth whoami --format json | ignore

    print $"Preparing ($model)"
    print $"  alias        ($served_name)"
    print $"  endpoint     http://($host):($port)/v1"
    print $"  ctx          ($ctx)"
    print $"  batch        ($batch)"
    print $"  ubatch       ($ubatch)"
    print $"  file         ($file)"
    print "  cache        ~/.cache/huggingface/hub/"

    HF_HUB_DISABLE_PROGRESS_BARS=1 hf download $model --include $file | ignore
    let local_model = (ls ($"~/.cache/huggingface/hub/models--($model | str replace -a '/' '--')/snapshots/*/($file)" | path expand) | get name | first)
    print $"Verified GGUF: ($local_model)"
    if $download_only or $verify_only { return }

    let llama_cmd = [
        llama-server -m $local_model --alias $served_name
        --host $host --port ($port | into string) -ngl "99" -c ($ctx | into string) -np "1" -fa "on"
        --cache-type-k q4_0 --cache-type-v q4_0
        -b ($batch | into string) -ub ($ubatch | into string) --split-mode none
    ]

    if $run_command == "serve" {
        ^$llama_cmd.0 ...($llama_cmd | skip 1)
    } else {
        if (which systemd-run | is-empty) { error make {msg: "llm-serve: systemd-run not found; use 'llm-serve serve' instead"} }
        systemd-run --user --unit $unit --collect ...$llama_cmd
        let probe_host = (if $host == "0.0.0.0" { "127.0.0.1" } else { $host })
        let probe_url = $"http://($probe_host):($port)/v1/models"
        print $"Waiting for ($served_name) at ($probe_url) ..."
        mut ready = false
        for _ in 1..120 {
            let probe = (curl -fsS $probe_url | complete)
            if $probe.exit_code == 0 {
                $ready = true
                break
            }
            sleep 1sec
        }
        if not $ready {
            systemctl --user status $"($unit).service" --no-pager
            error make {msg: $"llm-serve: timed out waiting for ($served_name) at ($probe_url)"}
        }
        print $"($served_name) is ready"
        systemctl --user status $"($unit).service" --no-pager
    }
}

# ── Vendor Autoload Bootstrap ───────────────────────────
# Integration scripts are generated once, then auto-sourced on startup.
# Regenerate with: rm ($nu.data-dir | path join "vendor/autoload/*.nu")
let vendor_dir = ($nu.data-dir | path join "vendor/autoload")
if not ($vendor_dir | path exists) { mkdir $vendor_dir }

if (which zoxide | is-not-empty) {
    let zoxide_init = ($vendor_dir | path join "zoxide.nu")
    if not ($zoxide_init | path exists) {
        zoxide init nushell | save -f $zoxide_init
    }
}

if (which starship | is-not-empty) {
    let starship_init = ($vendor_dir | path join "starship.nu")
    if not ($starship_init | path exists) {
        starship init nu | save -f $starship_init
    }
    $env.TRANSIENT_PROMPT_COMMAND = {|| starship module character}
}

if (which carapace | is-not-empty) {
    let carapace_init = ($vendor_dir | path join "carapace.nu")
    if not ($carapace_init | path exists) {
        carapace _carapace nushell | save -f $carapace_init
    }
}
