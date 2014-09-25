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

echo "SSHRC..."
wget https://raw.githubusercontent.com/Russell91/sshrc/master/sshrc
chmod +x sshrc
sudo mv sshrc /usr/local/bin
ln -s $SCRIPTPATH/.sshrc ~/.sshrc


echo "VIM..."
sudo apt-get install vim -y
ln -s $SCRIPTPATH/.vimrc ~/.vimrc
ln -s $SCRIPTPATH/Vim/plugin ~/.vim/plugin
ln -s $SCRIPTPATH/Vim/autoload ~/.vim/autoload
mkdir -p ~/.vim/bundle
cd ~/.vim/bundle
git clone https://github.com/tomtom/tcomment_vim.git

cd -


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

echo "Some useful tools..."
# libxml2-utils for xmllint
sudo apt-get install libxml2-utils -y 

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
sudo apt-get install git gitk -y
ln -s $SCRIPTPATH/.gitconfig ~/.gitconfig
mkdir -p ~/.config/git
ln -s $SCRIPTPATH/gitIgnore ~/.config/git/ignore


echo "all done !"

