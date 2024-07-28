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

# WGET
# sudo apt install wget

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
#sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo apt-get install docker-compose-plugin
# Apply executable permissions to the binary
#sudo chmod +x /usr/local/bin/docker-compose

# Adguard
#mkdir ~/server/compose
#mkdir ~/server/compose/adguard-home
#vi ~/server/compose/adguard-home/docker-compose.yml

sudo mkdir -p /opt/stacks/pihole

# Openvpn
sudo docker pull openvpn/openvpn-as
sudo docker run -d \
  --name=openvpn-as --cap-add=NET_ADMIN \
  -p 943:943 -p 443:443 -p 1194:1194/udp \
  -v ~/server/config:/openvpn \
  openvpn/openvpn-as
# Easynews
#sudo curl -fsSL blah

# NZBGet (opensource usenet)
sudo wget https://nzbget.com/download/nzbget-latest-bin-linux.run

# Bitwarden
sudo adduser bitwarden
sudo passwd bitwarden
sudo groupadd docker
sudo usermod -aG docker bitwarden
sudo mkdir /opt/bitwarden
sudo chmod -R 700 /opt/bitwarden
sudo chown -R bitwarden:bitwarden /opt/bitwarden
curl -Lso bitwarden.sh "https://func.bitwarden.com/api/dl/?app=self-host&platform=linux" && chmod 700 bitwarden.sh
./bitwarden.sh install

    #replace
    #...
    #globalSettings__mail__smtp__host=<placeholder>
    #globalSettings__mail__smtp__port=<placeholder>
    #globalSettings__mail__smtp__ssl=<placeholder>
    #globalSettings__mail__smtp__username=<placeholder>
    #globalSettings__mail__smtp__password=<placeholder>
    #...
    #adminSettings__admins=
    #...
    #./bitwarden.sh restart
    #./bitwarden.sh rebuild
    #./bitwarden.sh start

# Jellyfin Security
#openssl req -x509 -newkey rsa:4096 -keyout ./privkey.pem -out cert.pem -subj '/CN=localhost' -nodes -subj '/CN=jellyfin.lan'
#openssl pkcs12 -export -out jellyfin.pfx -inkey privkey.pem -in /usr/local/etc/letsencrypt/live/domain.org/cert.pem -passout pass:

sudo reboot