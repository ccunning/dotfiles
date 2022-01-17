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

# Install p10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
cp "${HERE}/.p10k.zsh.small" "~/.p10k.zsh"

# Install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

# Git config
git config --global user.email "curt.cunning@outlook.com"
git config --global user.name "Curt Cunning"
