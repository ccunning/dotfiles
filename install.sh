#!/bin/bash

HERE=$(dirname "$0")

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

ln -s "${HERE}/.zshrc" ~
ln -s "${HERE}/.zshrc.d" ~
touch ~/.zshrc.local
ln -s "${HERE}/.vimrc" ~
ln -s "${HERE}/.tmux.conf" ~
ln -s "${HERE}/.tmux.conf.local" ~
ln -s "${HERE}/.bin" ~
mkdir ~/.bin.local
ln -s "${HERE}/.config" ~
