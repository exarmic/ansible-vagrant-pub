#!/bin/sh -eux


# set a default HOME_DIR environment variable if not set
HOME_DIR="${HOME_DIR:-/home/vagrant}";

pubkey_url="https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub";
sudo mkdir -p $HOME_DIR/.ssh;
if command -v wget >/dev/null 2>&1; then
    sudo wget --no-check-certificate "$pubkey_url" -O $HOME_DIR/.ssh/authorized_keys;
elif command -v curl >/dev/null 2>&1; then
    sudo curl --insecure --location "$pubkey_url" > $HOME_DIR/.ssh/authorized_keys;
elif command -v fetch >/dev/null 2>&1; then
    sudo fetch -am -o $HOME_DIR/.ssh/authorized_keys "$pubkey_url";
else
    echo "Cannot download vagrant public key";
    exit 1;
fi
sudo chown -R vagrant $HOME_DIR/.ssh;
sudo chmod -R go-rwsx $HOME_DIR/.ssh;
