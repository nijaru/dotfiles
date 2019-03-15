if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# [ -f .aliases ] && source .aliases
# [ -f .exports ] && source .exports 
# [ -f .evals ] && source .evals
# [ -f .funcs ] && source .funcs

for file in ${HOME}/.{aliases,exports,evals,funcs}; do
    [ -f "$file" ] && source "$file"
done

unamestr=`uname`
if [[ unamestr == 'Darwin' ]]; then
	source ${HOME}/.macrc
else
    source ${HOME}/.linuxrc
fi

[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh
