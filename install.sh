#!/bin/bash

HERE=$PWD

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

rm -f ~/.zshrc

ln -s "${HERE}/.zshrc" ~
ln -s "${HERE}/.zshrc.d" ~
touch ~/.zshrc.local
ln -s "${HERE}/.vimrc" ~
ln -s "${HERE}/.tmux.conf" ~
ln -s "${HERE}/.tmux.conf.local" ~
ln -s "${HERE}/.bin" ~
mkdir ~/.bin.local
ln -s "${HERE}/.config" ~
ln -s "${HERE}/.gitignore_global" ~
git config --global core.excludesfile ~/.gitignore_global
