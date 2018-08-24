# zsh
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# pipenv bash completion
# eval "$(pipenv --completion)"

[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh

for file in ~/.{aliases,functions,exports}; do
	if [[ -r "$file" ]] && [[ -f "$file" ]]; then
		# shellcheck source=/dev/null
		source "$file"
	fi
done

unamestr=`uname`
if [[ unamestr == 'Darwin' ]]; then
	source .macrc
fi
