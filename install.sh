#!/bin/bash

cd $HOME/.dotfiles && git pull && cd

# install stuff for NeoVim
python -m ensurepip --user --default-pip
python3 -m ensurepip --user --default-pip
python -m pip install --user --upgrade pynvim
python2 -m pip install --user --upgrade pynvim
python3 -m pip install --user --upgrade pynvim
npm install -g neovim

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

if ! grep -q "export PROMPT_COMMAND='history -a; reset_ssh'" $PROFILE_FILE
then
  echo "export PROMPT_COMMAND='history -a; reset_ssh'" >> $PROFILE_FILE
fi

if ! grep -q "export EDITOR=\$(which nvim)" $PROFILE_FILE
then
  echo "export EDITOR=\$(which nvim)" >> $PROFILE_FILE
fi

# Other
if ! grep -q "/usr/local/etc/profile.d/bash_completion.sh" $PROFILE_FILE
then
  echo -e "\n# OS X\n[[ -r \"/usr/local/etc/profile.d/bash_completion.sh\" ]] && . \"/usr/local/etc/profile.d/bash_completion.sh\"" >> $PROFILE_FILE
fi

if ! grep -q "kubectl completion bash" $PROFILE_FILE
then
  echo -e "\n# Linux\nsource <(kubectl completion bash)\n" >> $PROFILE_FILE
fi

if ! grep -q "reset_ssh () {" $PROFILE_FILE
then
    echo "reset_ssh () {
    if SOCKET=\$(getSSH_AUTH_SOCK); then
        export SSH_AUTH_SOCK=\"\$SOCKET\"
    fi
}" >> $PROFILE_FILE
fi


# Load the changes to the current shell
source $PROFILE_FILE
