#!/bin/bash
sudo apt-get -q update && sudo apt-get -q upgrade
sudo snap install kubectl --classic;sudo snap install aws-cli --classic;sudo apt-get install cloud-init;sudo snap install helm --classic
# --- install kubectx ---
sudo apt update
sudo apt -y install kubectx
echo "alias kctx='kubectx'" >> ~/.bashrc
echo "alias kns='kubens'" >> ~/.bashrc

# --- install kubecolor ---
# https://github.com/hidetatz/kubecolor/tree/managing
wget https://github.com/hidetatz/kubecolor/releases/download/v0.0.25/kubecolor_0.0.25_Linux_x86_64.tar.gz -P /tmp/ 
tar -xzvf /tmp/kubecolor_0.0.25_Linux_x86_64.tar.gz -C /tmp/ 
sudo mv /tmp/kubecolor /usr/local/bin/
echo "alias kubectl='kubecolor'" >> ~/.bashrc
echo "alias k='kubectl'" >> ~/.bashrc

# --- install colorls ---
sudo apt -y install ruby libgmp-dev gcc make ruby-dev ruby-dev ruby-colorize
sudo gem install colorls
echo "alias ls='colorls -A --group-directories-first --gs'" >> ~/.bashrc

