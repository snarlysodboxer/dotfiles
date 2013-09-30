#!/bin/bash

cd $HOME/.dotfiles && git pull && cd
ruby $HOME/.dotfiles/symlink.rb

#rm -rf $HOME/.vim/bundle
mkdir -p $HOME/.vim/bundle

if ! test -d $HOME/.vim/bundle/vundle
then
  git clone https://github.com/gmarik/vundle.git $HOME/.vim/bundle/vundle
else
  cd $HOME/.vim/bundle/vundle && git pull && cd
fi
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

if ! grep -q "export HISTTIMEFORMAT='%F %T '" $PROFILE_FILE
then
  echo "export HISTTIMEFORMAT='%F %T '" >> $PROFILE_FILE
fi

if ! grep -q "export PROMPT_COMMAND='history -a'" $PROFILE_FILE
then
  echo "export PROMPT_COMMAND='history -a'" >> $PROFILE_FILE
fi

if ! grep -q "export EDITOR=\$(which vim)" $PROFILE_FILE
then
  echo "export EDITOR=\$(which vim)" >> $PROFILE_FILE
fi

source $PROFILE_FILE
