#!/bin/bash
sudo apt-get -q update && sudo apt-get -q upgrade
sudo snap install kubectl --classic;sudo snap install aws-cli --classic;sudo apt-get install cloud-init;sudo apt install tmux;
sudo alias k=kubectl
tmux
