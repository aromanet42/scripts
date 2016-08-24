#!/bin/bash

sudo apt-get install python-pip -y
pip install --upgrade pip

sudo pip install ansible

mkdir -p ~/workspace/scripts

ansible-pull -d ~/workspace/scripts -o -U git@github.com:aromanet42/scripts.git -K

