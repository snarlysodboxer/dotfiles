#!/bin/bash

ruby $HOME/.dotfiles/symlink.rb

rm -rf $HOME/.vim/bundle
mkdir $HOME/.vim/bundle
git clone https://github.com/gmarik/vundle.git $HOME/.vim/bundle/vundle
vim -u $HOME/.vimrc.bundles +BundleInstall +qa

if test -f $HOME/.bashrc
then
  PROFILE_FILE="$HOME/.bashrc"
else
  PROFILE_FILE="$HOME/.bash_profile"
fi

if ! grep -q "alias tmux=\"TERM=screen-256color-bce tmux\"" $PROFILE_FILE
then
  echo "alias tmux=\"TERM=screen-256color-bce tmux\"" >> $PROFILE_FILE
fi

if ! grep -q "export PS1=\"\\\u@\\\h:\\\w\\$ \"" $PROFILE_FILE
then
  echo "export PS1=\"\\u@\\h:\\w\$ \"" >> $PROFILE_FILE
fi

if ! grep -q "export HISTSIZE=10000" $PROFILE_FILE
then
  echo "export HISTSIZE=10000" >> $PROFILE_FILE
fi

if ! grep -q "export HISTFILESIZE=10000" $PROFILE_FILE
then
  echo "export HISTFILESIZE=10000" >> $PROFILE_FILE
fi

source $PROFILE_FILE
