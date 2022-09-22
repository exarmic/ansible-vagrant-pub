#!/bin/sh -eux
export DEBIAN_FRONTEND=noninteractive

echo ###########################
echo "update the package list"
echo ###########################
sudo apt-get -y update;
 
echo "install packages"

sudo apt-get install mc resolvconf -y


echo ###########################
echo "Install python pip3"
echo ###########################
sudo apt-get install python3-pip -y
sudo pip3 install --upgrade pip

# Don't remember why it is needed
sudo python3 -m pip install setuptools_rust

# on VM01 to run ansible pexpect module for FreeIPA
sudo python3 -m pip install pexpect

echo ###########################
echo "install ansible not from astra linux repository"
echo ###########################ss
sudo python3 -m pip install ansible 

# mainly for VM03 for running docker from ansible 
sudo ansible-galaxy collection install community.docker 

# mainly for VM02 for Foreman
echo "en_US.UTF-8 UTF-8" | sudo tee -a /etc/locale.gen && sudo locale-gen 

echo ###########################
echo "set timezone"
echo ###########################
export TZ=Europe/Moscow 
sudo ln -snf /usr/share/zoneinfo/$TZ /etc/localtime 
sudo echo $TZ > /etc/timezone 
