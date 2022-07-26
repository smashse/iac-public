#!/bin/bash
sudo apt update --fix-missing
sudo apt -y install apt-transport-https bash-completion ca-certificates conntrack curl ethtool gnupg2 htop ipset mlocate nano net-tools nftables socat software-properties-common tar unzip wget xz-utils
sudo apt -y dist-upgrade
sudo apt -y autoremove
sudo apt install -y apache2
