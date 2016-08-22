#!/bin/bash

sudo apt-get install python-pip -y
pip install --upgrade pip

sudo pip install ansible

ansible-playbook install.yml --become-method sudo --ask-become-pass

