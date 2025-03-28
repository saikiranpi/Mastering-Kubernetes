#!/bin/bash
sudo apt update
sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo chmod +x kubectl
sudo mv kubectl /usr/local/bin
sudo apt update
sudo curl https://get.docker.com | bash
sudo usermod -a -G docker ubuntu
sudo usermod -a -G root ubuntu
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo reboot

certbot certonly --manual --preferred-challenges=dns --key-type rsa --email saikira12345@gmail.com \
    --server https://acme-v02.api.letsencrypt.org/directory --agree-tos -d *.cloudvishwakarma.in

docker run -d --restart=unless-stopped \
    -p 80:80 -p 443:443 \
    --privileged \
    rancher/rancher:latest
