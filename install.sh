#!/bin/sh

ruby symlink.rb

rm -rf $HOME/.vim/bundle
mkdir $HOME/.vim/bundle
git clone https://github.com/gmarik/vundle.git $HOME/.vim/bundle/vundle
vim -u $HOME/.vimrc.bundles +BundleInstall +qa

if test -f $HOME/.profile
then
  PROFILE_FILE="$HOME/.profile"
else
  PROFILE_FILE="$HOME/.bash_profile"
fi

if ! grep -q "alias tmux=\"TERM=screen-256color-bce tmux\"" $PROFILE_FILE
then
  echo "alias tmux=\"TERM=screen-256color-bce tmux\"" >> $PROFILE_FILE
fi

source $PROFILE_FILE
