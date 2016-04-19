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

sudo apt-get install python-pip -y

echo "GIT..."
sudo apt-get install git gitk -y
ln -sf $SCRIPTPATH/.gitconfig ~/.gitconfig
mkdir -p ~/.config/git
ln -sf $SCRIPTPATH/gitIgnore ~/.config/git/ignore
sudo ln -sf $SCRIPTPATH/bin/git-* /usr/bin
mkdir -p ~/.oh-my-zsh/completions
sudo ln -sf $SCRIPTPATH/completions/* ~/.oh-my-zsh/completions
sudo chmod +x $SCRIPTPATH/bin/git-*

echo "VIM..."
sudo apt-get install vim vim-gtk -y
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
sudo ln -s $SCRIPTPATH/bin/detect-monitor-plugged.sh /usr/bin/detect-monitor-plugged.sh

echo "CHROME..."
sudo apt-get install google-chrome-stable -y

# using libnotify notifications for chrome :
wget -O /tmp/chrome-libnotify.zip https://docs.google.com/uc\?authuser\=0\&id\=0BzOewlVTs_tpdTNFckZKeG5HRE0\&export\=download
cd /tmp
unzip chrome-libnotify.zip
bash host/install.sh
sed -i.bak -e 's/chrome-extension:\/\/[a-z]*/chrome-extension:\/\/epckjefillidgmfmclhcbaembhpdeijg/' ~/.config/google-chrome/NativeMessagingHosts/com.initiated.chrome_libnotify_notifications.json


if ask_for_install "pidgin" ; then
  echo "PIDGIN..."
  sudo apt-get install pidgin -y
fi

echo "httpie..."
sudo pip install httpie

echo "jq - json engine..."
wget -O ~/bin/jq http://stedolan.github.io/jq/download/linux64/jq
chmod +x ~/bin/jq

echo "xPath engine..."
sudo apt-get install xmlstarlet -y

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

http https://api.github.com/repos/peco/peco/releases/latest | jq '.assets | map(select(.name == "peco_linux_amd64.tar.gz"))[0].browser_download_url' | xargs wget -O /tmp/peco.tar.gz
tar xvf /tmp/peco.tar.gz -C /tmp
mv /tmp/peco_linux_amd64/peco ~/bin

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
echo "export DEV=$devpath\n" >> ~/.xsessionrc
echo "export JAVA_HOME=$devpath/current_jdk\n" >> ~/.xsessionrc

source ~/.zshrc

echo "Maven..."
cd /tmp
wget http://apache.mirrors.ovh.net/ftp.apache.org/dist/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.tar.gz
tar xvfz apache-maven-3.3.3-bin.tar.gz -C $devpath
ln -s $devpath/apache-maven-3.3.3 $devpath/maven
wget http://dl.bintray.com/jcgay/maven/com/github/jcgay/maven/color/maven-color-logback/maven-metadata.xml
mvnColorVersion=`xmlstarlet sel -t -m '//release' -v . -n maven-metadata.xml`
wget http://dl.bintray.com/jcgay/maven/com/github/jcgay/maven/color/maven-color-logback/$mvnColorVersion/maven-color-logback-$mvnColorVersion-bundle.tar.gz
tar xvfz maven-color-logback-$mvnColorVersion-bundle.tar.gz -C $devpath/maven/
rm $devpath/maven/lib/slf4j-simple-1.7.*.jar
ln -s $SCRIPTPATH/maven.color ~/.m2/maven.color



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
  echo "/usr/bin/trayer --edge top  --align right --SetDockType true --SetPartialStrut false  --expand true  --widthtype percent --width 4 --transparent true --alpha 0  --tint 0x000000 --height 16 --monitor 0 &\n" >> ~/.xsessionrc

fi

echo "xmodmap..."
ln -s $SCRIPTPATH/.Xmodmap ~∕.Xmodmap

echo "Mutate..."
sudo add-apt-repository ppa:mutate/ppa
sudo apt-get update
sudo apt-get install mutate -y
sudo pip install sympy
echo "mutate &\n" >> ~/.xsessionrc

echo "checking existance of screensaver..."
if check_exists "gnome-screensaver" ; then
  echo "gnome-screensaver already present."
else
  echo "none present. Installing xscreensaver..."
  sudo apt-get install xscreensaver -y
  echo "xscreensaver &\n" >> ~/.xsessionrc
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

echo "Initializing xsessionrc..."
echo "/usr/bin/detect-monitor-plugged.sh &\n" >> ~/.xsessionrc
echo "mkdir /tmp/Downloads \n" >> ~/.xsessionrc
# tool displaying network status in trayer
echo "nm-applet & \n" >> ~/.xsessionrc
# checking for updates
echo "sudo apt-get update\nsudo apt-get upgrade\nsudo apt-get autoremove\nsudo apt-get autoclean\n" >> ~/.xsessionrc


echo "all done !"

