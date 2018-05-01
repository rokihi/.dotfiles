#!/bin/bash
#for f in .??*
#do
#    [[ "$f" == ".git" ]] && continue
#    echo "$f"
#    ln -s $HOME/.dotfiles/$file $HOME/$file
#done

mkdir ~/.dotfiles/original

mv ~/.bashrc ~/.dotfiles/original
mv ~/.inputrc ~/.dotfiles/original
mv ~/.gitconfig ~/.dotfiles/original
mv ~/.emacs ~/.dotfiles/original

ln -s ~/.dotfiles/.bashrc ~/.bashrc
ln -s ~/.dotfiles/.inputrc ~/.inputrc
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/.emacs ~/.emacs

source ~/.bashrc
