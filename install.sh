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


#il arrive qu'il manque gnome-settings-daemon...
sudo apt-get install gnome-settings-daemon -y

echo "VIM..."
sudo apt-get install vim -y
ln -sf $SCRIPTPATH/.vimrc ~/.vimrc
ln -s $SCRIPTPATH/Vim/plugin ~/.vim/plugin
ln -s $SCRIPTPATH/Vim/autoload ~/.vim/autoload
mkdir -p ~/.vim/bundle
cd ~/.vim/bundle
git clone https://github.com/tomtom/tcomment_vim.git

cd -


echo "terminator"
sudo apt-get install terminator -y

echo "arandr"
sudo apt-get install arandr -y

echo "CHROME..."
sudo apt-get install google-chrome-stable -y


echo "PIDGIN..."
sudo apt-get install pidgin -y


echo "ZSH..."
# zsh
sudo apt-get install zsh -y
# oh-my-zsh
wget --no-check-certificate https://github.com/lucmazon/custom-zsh/raw/master/install.sh -O - | sh
# install some plugins
cd ~/.oh-my-zsh/custom/plugins
git clone git://github.com/zsh-users/zsh-syntax-highlighting.git
# install custom conf
ln -s $SCRIPTPATH/ohmyzsh/*.zsh ~/.oh-my-zsh/custom

read -p "Où est le dossier contenant les outils de développement ? " devpath
echo "export DEV=$devpath" > ~/.oh-my-zsh/custom/custom_env.zsh

source ~/.zshrc

cd -

echo "Some useful tools..."
# libxml2-utils for xmllint
sudo apt-get install libxml2-utils -y 
# ack-grep
sudo apt-get install ack-grep -y

# TODO : if xmonad
if ask_for_install "xmonad" ; then

  echo "XMONAD..."
  sudo apt-get install xmonad -y
  mkdir ~/.xmonad
  ln -s $SCRIPTPATH/xmonad.hs ~/.xmonad/xmonad.hs

  sudo apt-get install libghc-xmonad-contrib-dev libghc-xmonad-dev -y
  
  echo "XMOBAR..."
  sudo apt-get install xmobar -y
  ln -sf $SCRIPTPATH/.xmobarrc ~/.xmobarrc
  ln -s $SCRIPTPATH/bin ~/.xmonad/bin


  echo "TRAYER..."
  sudo apt-get install trayer -y
fi

echo "xmodmap..."
ln -s $SCRIPTPATH/.Xmodmap ~∕.Xmodmap

echo "Gnome-do..."
sudo apt-get install gnome-do -y

echo "GIT..."
sudo apt-get install git gitk -y
ln -sf $SCRIPTPATH/.gitconfig ~/.gitconfig
mkdir -p ~/.config/git
ln -sf $SCRIPTPATH/gitIgnore ~/.config/git/ignore


echo "all done !"

