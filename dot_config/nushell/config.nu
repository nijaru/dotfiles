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

# ── Aliases ─────────────────────────────────────────────

# Navigation
alias ll = ls
alias la = ls -a
alias lla = ls -a

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
alias gcf = git commit --gpg-sign --amend --reuse-message HEAD
alias gcF = git commit --gpg-sign --amend
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
alias gl = git log --oneline --decorate -n 10
alias glg = git log --graph --oneline --decorate -n 20
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
alias grm = git rebase main

# Git — maintenance
alias greflog = git reflog
alias gverify = git verify-commit HEAD
alias gcleanup = git clean -xfd
alias ggarbage = git gc --aggressive --prune=now
alias gsubr = git config submodule.recurse true

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
}

if (which carapace | is-not-empty) {
    let carapace_init = ($vendor_dir | path join "carapace.nu")
    if not ($carapace_init | path exists) {
        carapace _carapace nushell | save -f $carapace_init
    }
}
