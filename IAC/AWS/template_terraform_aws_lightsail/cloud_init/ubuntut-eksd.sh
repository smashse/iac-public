#!/bin/bash
sudo apt update --fix-missing
sudo snap refresh
sudo snap install kubectl --classic
sudo snap install eks --edge --classic
sudo eks status --wait-ready
sudo apt -y dist-upgrade
sudo apt -y autoremove
