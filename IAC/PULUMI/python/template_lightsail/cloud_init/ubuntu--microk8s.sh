#!/bin/bash
sudo apt update --fix-missing
sudo snap refresh
sudo snap install kubectl --classic
sudo snap install microk8s --classic
sudo microk8s status --wait-ready
sudo microk8s enable dns ingress
sudo mkdir -p $HOME/.kube
sudo usermod -a -G microk8s $USER
sudo chown -f -R $USER $HOME/.kube
sudo microk8s config > $HOME/.kube/config
sudo apt -y dist-upgrade
sudo apt -y autoremove