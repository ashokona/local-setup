#!/bin/bash

DISTRO=linux-x64
PKG_MANAGER=apt-get
# MY_USER=anatoliy
# REDIS_VERSION=2.0.3

#check for root
UID=$(id -u)
if [ x$UID != x0 ] 
then
    #Beware of how you compose the command
    printf -v cmd_str '%q ' "$0" "$@"
    exec sudo su -c "$cmd_str"
fi

#I am root
mkdir /opt/D3GO/

apt-get update
apt-get install -y git curl apt-transport-https gnupg2

#Install node
NODE_VERSION=14.15.4
NODE_FILE=node-v$NODE_VERSION-$DISTRO

wget https://nodejs.org/dist/v14.15.4/$NODE_FILE.tar.gz
tar -C /usr/local --strip-components 1 -xzf $NODE_FILE.tar.gz
rm -rf $NODE_FILE.tar.gz $NODE_FILE

#Mongo DB
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -       
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
apt-get update
apt-get install -y mongodb-org

#Install Docker
apt-get remove docker docker-engine docker.io containerd runc
apt-get install -y ca-certificates gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install docker-ce-cli containerd.io

#Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
dpkg -i minikube_latest_amd64.deb

#Kubernates
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl