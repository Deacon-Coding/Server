#!/bin/bash

# sudo mount -t vboxsf test /home/myusername/test <- for host to vm folder

# install packages to allow apt to use a repository over HTTPS
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

mkdir ~/server
cd ~/server 
mkdir media config jellyfin prowlarr radarr sonarr lidarr readarr bazarr qbittorrent nzbget 

cd ~/server/media
mkdir books  movies  music  tv

# Ubuntu Desktop
sudo apt install ubuntu-desktop

# Add Docker’s official GPG key:
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
wget https://desktop.docker.com/linux/main/amd64/docker-desktop-4.19.0-amd64.deb
sudo apt install ./docker-desktop-*-amd64.deb

# Add user to the docker group to run docker commands without requiring root
sudo usermod -aG docker $(whoami) 

# Download the current stable release of Docker Compose
sudo apt-get install docker-compose-plugin

# Openvpn
sudo docker pull openvpn/openvpn-as
sudo docker run -d \
  --name=openvpn-as --cap-add=NET_ADMIN \
  -p 943:943 -p 443:443 -p 1194:1194/udp \
  -v ~/server/config:/openvpn \
  openvpn/openvpn-as

# Bitwarden
git clone https://github.com/bitwarden/server.git
cd server
git config blame.ignoreRevsFile .git-blame-ignore-revs
git config --local core.hooksPath .git-hooks
cd dev
cp .env.example .env
vim .env # set MSSQL_PASSWORD

sudo reboot