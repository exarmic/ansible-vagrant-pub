#!/bin/sh -eux
export DEBIAN_FRONTEND=noninteractive

echo "###########################"
echo "update the package list"
echo "###########################"
sudo apt-get -y update;
 
echo "install packages"

sudo apt-get install mc resolvconf -y


echo "###########################"
echo "Install python pip3"
echo "###########################"
sudo apt-get install python3-pip -y
python3 -m pip install --upgrade pip

# Don't remember why it is needed
python3 -m pip install setuptools_rust

echo "###########################"
echo "install ansible not from astra linux repository"
echo "###########################"
python3 -m pip install ansible 

# mainly for VM03 for running docker from ansible 
ansible-galaxy collection install community.docker 

# on VM01 to run ansible pexpect module for FreeIPA
python3 -m pip install pexpect
sudo python3 -m pip install pexpect

# mainly for VM02 for Foreman
if [[ $(cat /etc/locale.gen | grep "en_US.UTF-8" | grep -v "#" ) ]]; then
    echo "en_US.UTF-8 locale exist"
	sudo locale-gen 
else
    echo "en_US.UTF-8 UTF-8" | sudo tee -a /etc/locale.gen && sudo locale-gen 
fi


echo "###########################"
echo "set timezone"
echo "###########################"
export TZ=Europe/Moscow 
sudo ln -snf /usr/share/zoneinfo/$TZ /etc/localtime 
sudo echo $TZ > /etc/timezone 
