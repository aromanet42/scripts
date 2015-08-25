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

function check_exists
{
  if type "$1" > /dev/null; then
    return 0
  else
    return -1
  fi
}

#il arrive qu'il manque gnome-settings-daemon...
sudo apt-get install gnome-settings-daemon -y

echo "GIT..."
sudo apt-get install git gitk -y
ln -sf $SCRIPTPATH/.gitconfig ~/.gitconfig
mkdir -p ~/.config/git
ln -sf $SCRIPTPATH/gitIgnore ~/.config/git/ignore
sudo ln -sf $SCRIPTPATH/bin/git-checkout-regex /usr/bin/git-checkout-regex

echo "VIM..."
sudo apt-get install vim -y
ln -sf $SCRIPTPATH/.vimrc ~/.vimrc
ln -s $SCRIPTPATH/Vim/plugin ~/.vim/plugin
ln -s $SCRIPTPATH/Vim/autoload ~/.vim/autoload
mkdir -p ~/.vim/bundle
cd ~/.vim/bundle
git clone https://github.com/tomtom/tcomment_vim.git
git clone https://github.com/vim-scripts/csv.vim.git

cd -


echo "terminator"
sudo apt-get install terminator -y
ln -s $SCRIPTPATH/terminator.config ~/.config/terminator/config

echo "arandr"
sudo apt-get install arandr -y

echo "CHROME..."
sudo apt-get install google-chrome-stable -y

if ask_for_install "pidgin" ; then
  echo "PIDGIN..."
  sudo apt-get install pidgin -y
fi


echo "ZSH..."
# zsh
sudo apt-get install zsh -y
# oh-my-zsh
wget --no-check-certificate https://github.com/lucmazon/custom-zsh/raw/master/install.sh -O - | sh
# install some plugins
cd ~/.oh-my-zsh/custom/plugins
git clone git://github.com/zsh-users/zsh-syntax-highlighting.git
# install custom conf
ln -s $SCRIPTPATH/.zshrc ~/.zshrc
ln -s $SCRIPTPATH/ohmyzsh/*.zsh ~/.oh-my-zsh/custom
ln -s $SCRIPTPATH/ohmyzsh/*.zsh-theme ~/.oh-my-zsh/themes
cd -


#installing fonts for powerline prompt
cd /tmp
git clone https://github.com/powerline/fonts.git
cd -
cd fonts
./install.sh
sudo fc-cache -fv
cd -


read -p "Où est le dossier contenant les outils de développement ? " devpath
echo "export DEV=$devpath" > ~/.oh-my-zsh/custom/custom_env.zsh

source ~/.zshrc

echo "Maven..."
cd /tmp
wget http://apache.mirrors.ovh.net/ftp.apache.org/dist/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.tar.gz
tar xvfz apache-maven-3.3.3-bin.tar.gz -C $devpath
ln -s $devpath/apache-maven-3.3.3 $devpath/maven
wget http://dl.bintray.com/jcgay/maven/com/github/jcgay/maven/color/maven-color-logback/1.1/maven-color-logback-1.1-bundle.tar.gz
tar xvfz maven-color-logback-1.1-bundle.tar.gz -C $devpath/maven/
rm $devpath/maven/lib/slf4j-simple-1.7.*.jar



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

echo "Mutate..."
sudo add-apt-repository ppa:mutate/ppa
sudo apt-get update
sudo apt-get install mutate -y
sudo apt-get install python-pip -y
sudo pip install sympy

echo "checking existance of screensaver..."
if check_exists "gnome-screensaver" ; then
  echo "gnome-screensaver already present."
else
  echo "none present. Installing xscreensaver..."
  sudo apt-get install xscreensaver -y
fi

echo "Some useful tools..."
# libxml2-utils for xmllint
sudo apt-get install libxml2-utils -y 
# ack-grep
sudo apt-get install ack-grep -y
# htop
sudo apt-get install htop -y
# print screen
sudo apt-get install imagemagick -y
# lightweight image editor
sudo apt-get install oxygen-icon-theme kdelibs-bin kdelibs5-data kdelibs5-plugins kolourpaint4 -y
# tldr
sudo pip install tldr

# fasd
cd /tmp
git clone https://github.com/clvv/fasd.git 
cd fasd
sudo make install


echo "all done !"

