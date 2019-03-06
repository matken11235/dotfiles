#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

# Set operation.
setopt EXTENDED_GLOB

# A function that displays the name of the
#  virtual environment at the right prompt.
function cd {
	builtin cd "$@"
	if [[ -e .python-version ]]; then
		RPROMPT="%{%F{red}($(cat .python-version))%f%}"
		typeset -g pv_dir=${PWD:1}
	elif [[ -v pv_dir ]] && [[ $(pwd) =~ ${pv_dir} ]]; then
		unset MATCH
	else
		RPROMPT=""
	fi
}

# anyenv
if [[ -d $HOME/.anyenv ]] ; then
	export PATH="$HOME/.anyenv/bin:$PATH"
	eval "$(anyenv init - --no-rehash)"
fi

## Warning setting of tensorflow.
export TF_CPP_MIN_LOG_LEVEL=2

# golang with app-engine by Google
export PATH="$PATH:$HOME/.go_appengine"

# awscli
if [[ -d ~/.aws ]]; then
    export AWS_DEFAULT_REGION=$(cat ~/.aws/config | grep 'region' | awk '{printf $3}')
    export AWS_ACCESS_KEY_ID=$(cat ~/.aws/credentials | grep 'aws_access_key_id' | awk '{printf $3}')
    export AWS_SECRET_ACCESS_KEY=$(cat ~/.aws/credentials | grep 'aws_secret_access_key' | awk '{printf $3}')
fi

# coreutils
#export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
# gnu-tar
export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"

# rust lang
source $HOME/.cargo/env

# for nvim
alias vim=nvim
export XDG_CONFIG_HOME=$HOME/.config

# tmux_automatically_attach attachs tmux session
# automatically when your are in zsh
[[ -f ~/dotfiles/scripts/tmuxx.sh ]] && ~/dotfiles/scripts/tmuxx.sh

export PATH="/usr/local/opt/curl/bin:$PATH"
export PATH="/usr/local/opt/erlang@20/bin:$PATH"

export PATH="/Users/matken/.anyenv/envs/ndenv/versions/v10.7.0/lib/node_modules/elm/binwrappers/:$PATH"


export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="$HOME/.anyenv/envs/ndenv/versions/v10.7.0/bin/:$PATH"

unset zle_bracketed_paste
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
alias rm='gmv -f --backup=numbered --target-directory ~/.Trash/'


# added by travis gem
[ -f /Users/matken/.travis/travis.sh ] && source /Users/matken/.travis/travis.sh

# flutter
export PATH="$HOME/flutter/bin:$PATH"
