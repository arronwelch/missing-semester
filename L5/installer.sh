#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# vim
ln -sf ${BASEDIR}/vimrc ~/.vimrc
ln -sf ${BASEDIR}/vim ~/.vim

# zsh
ln -sf ${BASEDIR}/zshrc ~/.zshrc

# tmux
ln -sf ${BASEDIR}/tmux.conf ~/.tmux.conf
