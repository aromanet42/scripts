#!/bin/bash

echo "Installation des programmes de base"

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

PWD=`pwd`


function ask_for_install 
{
  echo "Installer $1 ?"
  read input_variable

  if [ "$input_variable" == "y" ]; then
    return 0
  else
    return -1
  fi
} 



echo "VIM..."
sudo apt-get install vim -y
ln -s $SCRIPTPATH/.vimrc ~/.vimrc
ln -s $SCRIPTPATH/Vim/plugin ~/.vim/plugin


echo "CHROME..."
sudo apt-get install google-chrome-stable -y


echo "PIDGIN..."
sudo apt-get install pidgin -y


echo "ZSH..."
wget --no-check-certificate https://github.com/lucmazon/custom-zsh/raw/master/install.sh -O - | sh
cd ~/.oh-my-zsh/custom/plugins
git clone git://github.com/zsh-users/zsh-syntax-highlighting.git
source ~/.zshrc

cd -


# TODO : if xmonad
if ask_for_install "xmonad" ; then

  echo "XMONAD..."
  ln -s $SCRIPTPATH/xmonad.hs ~/.xmonad/xmonad.hs

  
  echo "XMOBAR..."
  ln -s $SCRIPTPATH/.xmobarrc ~/.xmobarrc
  ln -s $SCRIPTPATH/bin ~/.xmonad/bin


  echo "TRAYER..."
  sudo apt-get install trayer -y
fi

echo "SYNAPSE..."
sudo add-apt-repository ppa:noobslab/apps
sudo apt-get update
sudo apt-get install synapse -y

echo "GIT..."
sudo apt-get install git -y
ln -s $SCRIPTPATH/.gitconfig ~/.gitconfig


echo "all done !"

