#!/bin/bash

set -e # do not continue script if failure

sudo apt-get install python3-pip git pipx -y

pipx install ansible-core
pipx ensurepath

ansible-galaxy collection install community.general

mkdir -p ~/workspace/scripts

ssh-keygen -o

echo "Add your public SSH key in Github Settings: https://github.com/settings/keys"

read -p "Press enter when it is done"

ansible-pull -d ~/workspace/scripts -o -U git@github.com:aromanet42/scripts.git -K

