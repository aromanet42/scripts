#!/bin/bash

sudo apt-get install python-pip git -y
pip install --upgrade pip

sudo pip install ansible

mkdir -p ~/workspace/scripts


ssh-keygen -o

echo "Add your public SSH key in Github Settings: https://github.com/settings/keys"

read -p "Press enter when it is done"

ansible-pull -d ~/workspace/scripts -o -U git@github.com:aromanet42/scripts.git -K

