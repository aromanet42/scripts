
echo "Installation des programmes de base"

echo "VIM..."
sudo apt-get install vim

echo "PIDGIN..."
sudo apt-get install pidgin


# TODO : if xmonad
echo "TRAYER..."
sudo apt-get install trayer


echo "SYNAPSE..."
sudo add-apt-repository ppa:noobslab/apps
sudo apt-get update
sudo apt-get install synapse

echo "GIT..."
sudo apt-get install git


echo "all done !"

