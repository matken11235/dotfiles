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
		RPROMPT="%F{red}($(cat .python-version))%f"
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
# gcloudのバグ対策
export CLOUDSDK_PYTHON="$HOME/.anyenv/envs/pyenv/versions/2.7.15/bin/python2"

# awscli
export AWS_DEFAULT_REGION=$(cat ~/.aws/config | grep 'region' | awk '{printf $3}')
export AWS_ACCESS_KEY_ID=$(cat ~/.aws/credentials | grep 'aws_access_key_id' | awk '{printf $3}')
export AWS_SECRET_ACCESS_KEY=$(cat ~/.aws/credentials | grep 'aws_secret_access_key' | awk '{printf $3}')

# rust lang
source $HOME/.cargo/env

# for nvim
alias vim=nvim
export XDG_CONFIG_HOME=$HOME/.config

source ~/secret.sh

# tmux_automatically_attach attachs tmux session
# automatically when your are in zsh
[[ -f ~/dotfiles/scripts/tmuxx.sh ]] && ~/dotfiles/scripts/tmuxx.sh


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/matken/google-cloud-sdk/path.zsh.inc' ]; then source '/Users/matken/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/matken/google-cloud-sdk/completion.zsh.inc' ]; then source '/Users/matken/google-cloud-sdk/completion.zsh.inc'; fi
