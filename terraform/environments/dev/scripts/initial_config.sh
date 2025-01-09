#!/bin/bash
sudo apt-get -q update && sudo apt-get -q upgrade
<<<<<<< HEAD
sudo snap install kubectl --classic;sudo snap install aws-cli --classic;sudo apt-get install cloud-init;sudo snap install helm --classic
java -jar agent.jar -url http://example.jenkins.com/ -secret de4f5cce994e1d91c93264b9a764fe4c5fa305f462f526088421e6e81582bd5a -name Ubuntu -webSocket -workDir "/home/jenkins"
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

=======
sudo snap install kubectl --classic;sudo snap install aws-cli --classic;sudo apt-get install cloud-init;sudo apt install tmux;
sudo alias k=kubectl
tmux
>>>>>>> 498bc6a9c31409c41bd5e7f42989dd73f8bda7e4
