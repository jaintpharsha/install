#!/bin/bash
sudo apt update 
sudo apt-get install -y wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
echo -e "\n\n******************************************************************************"
echo "                    Run: sudo apt-get install -y trivy "
echo -e "******************************************************************************\n"
# curl -s https://raw.githubusercontent.com/jaintpharsha/install/main/trivy-scanner | sudo bash
