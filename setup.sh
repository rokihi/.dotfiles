#!/bin/bash
#for f in .??*
#do
#    [[ "$f" == ".git" ]] && continue
#    echo "$f"
#    ln -s $HOME/.dotfiles/$file $HOME/$file
#done

ln -s ~/.dotfiles/.bashrc ~/.bashrc
ln -s ~/.dotfiles/.inputrc ~/.inputrc
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/.emacs ~/.emacs
