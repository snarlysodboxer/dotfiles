#!/bin/bash

cd $HOME/.dotfiles && git pull && cd

mkdir -p $HOME/.config/nvim $HOME/.config/htop

FILE_PATHS=`find $HOME/.dotfiles/linked -type f | cut -d '/' -f 6-`
for FILE_PATH in $FILE_PATHS; do
  if [ -f $HOME/\.$FILE_PATH ]; then
    if [ -L $HOME/\.$FILE_PATH ]; then
      rm $HOME/\.$FILE_PATH
    else
      mv $HOME/\.$FILE_PATH $HOME/\."$FILE_PATH"_bak
    fi
  fi
  if [ -L $HOME/\.$FILE_PATH ]; then
    rm $HOME/\.$FILE_PATH
  fi
  ln -s $HOME/.dotfiles/linked/$FILE_PATH $HOME/\.$FILE_PATH
done

# rm -rf $HOME/.vim/bundle
mkdir -p $HOME/.vim/bundle

if ! test -d $HOME/.vim/bundle/vundle
then
  git clone https://github.com/gmarik/vundle.git $HOME/.vim/bundle/vundle
else
  cd $HOME/.vim/bundle/vundle && git pull && cd
fi
vim -u $HOME/.vimrc.bundles +BundleInstall +GoInstallBinaries +qa

## Determine bash profile file path
if test -f $HOME/.bashrc
then
  PROFILE_FILE="$HOME/.bashrc"
else
  PROFILE_FILE="$HOME/.bash_profile"
fi

## Aliases
if ! grep -q "alias tmux=\"TERM=screen-256color-bce tmux\"" $PROFILE_FILE
then
  echo "alias tmux=\"TERM=screen-256color-bce tmux\"" >> $PROFILE_FILE
fi

if ! grep -q "alias vi=\"nvim\"" $PROFILE_FILE
then
  echo "alias vi=\"nvim\"" >> $PROFILE_FILE
fi

if ! grep -q "alias vim=\"nvim\"" $PROFILE_FILE
then
  echo "alias vim=\"nvim\"" >> $PROFILE_FILE
fi


## Env vars
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

if ! grep -q "export PROMPT_COMMAND='history -a; history -c; history -r'" $PROFILE_FILE
then
  echo "export PROMPT_COMMAND='history -a; history -c; history -r'" >> $PROFILE_FILE
fi

if ! grep -q "export EDITOR=\$(which nvim)" $PROFILE_FILE
then
  echo "export EDITOR=\$(which nvim)" >> $PROFILE_FILE
fi

source $PROFILE_FILE
