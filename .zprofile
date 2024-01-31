#
# Executes commands at login pre-zshrc.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

#
# Browser
#

if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

#
# Editors
#

export EDITOR='lvim'
export VISUAL='lvim'
export PAGER='less'

#
# Language
#

if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

#
# Paths
#

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Set the list of directories that cd searches.
# cdpath=(
#   $cdpath
# )

# Set the list of directories that Zsh searches for programs.
path=(
  /usr/local/{bin,sbin}
  $path
)

#
# Less
#

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-F -g -i -M -R -S -w -X -z-4'

# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

# cli
export CLICOLOR=1
# export LSCOLORS=xGxfxDxbxexexcxcxcxcx
# cmake
export CMAKE_GENERATOR=Ninja
# go
# export PATH="$PATH:/usr/local/go/bin"
# export PATH="$PATH:$(go env GOPATH)/bin"
# .local
export PATH="$HOME/.local/bin:$PATH"
# npm
export PATH="$PATH:~/.npm-global/bin"
# yarn
export PATH="$PATH:$HOME/.yarn/bin"
export PATH="$PATH:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:"
# zstd
export ZSTD_NBTHREADS=0
export ZSTD_CLEVEL=19

export PATH="$PATH:/Users/nick/Library/Application Support/JetBrains/Toolbox/scripts"

fpath+=~/.zfunc

# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
