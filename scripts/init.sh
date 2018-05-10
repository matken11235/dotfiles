#!/bin/bash

echo 'U2FsdGVkX185GXqQnfcFYnaC5oMyiEXeIhQDnOtitu3b8tTx6Sjm46DGD5EAVypl
akUtjX4brM31joIfy7fjpf7YFdh3VvSmY4o6X48fvjNp4SOVGT1JFTs8Qm1FbdX9
wVhm5sCzvJHcxZBHv+ixcgXt7VV8WX5J01RmjnJ/naZJZ7lvjMk/FihGRZZnq3YH
bbB8zvgXmoOythc2GNaSubFR8RKVJVylIVSrsskeL+xVbSsNrNJnBAkAV9Ostn85
utNpTX7/oou0O01k3jPz5l2CN4DskWqBVjgIK/+hy72+LhbszHQ5/V8nFMTf8eCl
JfHIYt50dnLp9ybGUuBC1wNOwfmV9gr1RQA7Z4d/yw4b7+IwETQGfD+XbHvTydby
/2Mal1u8UFgDaDooFYDGhvZFfe0hsVbJbJWWy8IgfmksOO4DNFFaXk0faPgrHkTr
Fqfogf2MqK44GsiwPA/Or+igzFaEjIgGbbqQYW3a8lIjEewI6MwCZFvHN4uBbxUF
qTDvx0x8XGOryHRFMrZsjgkw3C4yGilHegdq6Zy2jBYfNSBSpVLMOp03TGgONTYg
lDs9N35AWhVwB9i8GCf7a1Dj8LKD323GM7KCllG+qm9w2uPjOS81YjsuOhZTGkLZ' \
| openssl enc -d -des -base64 -k 'dotfiles!!!'
export DOTSPATH="$(dirname $(cd $(dirname $0); pwd))"

# Config Task
printf '[\e[32m?\e[m] Which Git name would you like to use? ' && read gitname
printf '[\e[32m?\e[m] Which Git email would you like to use? ' && read gitemail
## Ask for the administrator password upfront.
printf '[\e[32m?\e[m] ' && sudo -v
## Keep-alive: update existing `sudo` time stamp until this script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install Xcode command line tools.
check="$(xcode-select --install 2>&1)"
str='xcode-select: note: install requested for command line developer tools'
while [[ $check == $str ]]; do
	check="$(xcode-select --install 2>&1)"
	sleep 1
done
# Because Xcode has not been installed yet.
#sudo xcodebuild -license accept

# Install Homebrew
yes | /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" >/dev/null 2>&1

# Install git
brew install git 1>/dev/null
git config --global user.name $gitname
git config --global user.email $gitemail

# Install anyenv and *env
bash "${DOTSPATH}/scripts/anyenv/main.sh"

# Install ansible (and accompany some of it)
brew install ansible 1>/dev/null
ansible-playbook ${DOTSPATH}/playbooks/homebrew.yml -i ${DOTSPATH}/hosts
ansible-playbook ${DOTSPATH}/playbooks/defaults.yml -i ${DOTSPATH}/hosts
# TODO: うまく動作しない
# ERROR: ERROR! Syntax Error while loading YAML.
#   found unknown escape character

# The error appears to have been in '/Users/matken/dotfiles/playbooks/defaults.yml': line 131, column 28, but may
# be elsewhere in the file depending on the exact syntax problem.

# The offending line appears to be:

#         value: 3
#     - name: "'￥'キーで入力する文字: \(バックスラッシュ)"
#                            ^ here
# This one looks easy to fix.  It seems that there is a value started
# with a quote, and the YAML parser is expecting to see the line ended
# with the same kind of quote.  For instance:

#     when: "ok" in result.stdout

# Could be written as:

#    when: '"ok" in result.stdout'

# Or equivalently:

#    when: "'ok' in result.stdout"


## Increase grid spacing for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c 'Set :DesktopViewSettings:IconViewSettings:gridSpacing 85' ~/Library/Preferences/com.apple.finder.plist
## Show item info near icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c 'Set :DesktopViewSettings:IconViewSettings:showItemInfo true' ~/Library/Preferences/com.apple.finder.plist
## キーボードショートカット: 次のウィンドウを操作対象にする． => option + tab
/usr/libexec/PlistBuddy -c 'Set :AppleSymbolicHotKeys:27:value:parameters:0 65535' ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c 'Set :AppleSymbolicHotKeys:27:value:parameters:1 48' ~/Library/Preferences/com.apple.symbolichotkeys.plist
/usr/libexec/PlistBuddy -c 'Set :AppleSymbolicHotKeys:27:value:parameters:2 524288' ~/Library/Preferences/com.apple.symbolichotkeys.plist

# Install software from mas
bash ${DOTSPATH}/scripts/mas.sh

# Install rust-lang
trap 'rm -f ./tmp.sh' 0
curl https://sh.rustup.rs -sSf > ./tmp.sh
chmod +x ./tmp.sh
./tmp.sh -y 1>/dev/null

# config
bash "${DOTSPATH}/scripts/config.sh"

# Japanese to English.
sudo find / \
-type d -not \( \
	-path "/System" -prune -o \
	-path "/private" -prune -o \
	-path "/dev" -prune -o \
	-path "/Volumes" -prune \
\) -type f -name .localized \
-delete 2>/dev/null

# Install software from dmg
bash ${DOTSPATH}/scripts/dmgs/main.sh

# Logging.
terminal-notifier -message 'All done.' -sound Funk
printf '\xE2\x9C\x94 \e[1;33m All done !!! \u2728 \u2728 \e[m\n'
printf '\xE2\x9D\x97 \e[1;31m Reboot your computer...\e[m\n'
read -n 1 -s -r -p 'Press any key to continue'

# Restart to make the setting effective.
sudo reboot
