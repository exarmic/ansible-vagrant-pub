#!/bin/sh -eux
export DEBIAN_FRONTEND=noninteractive

echo "update the package list"
sudo apt-get -y update;

echo "install wget"
sudo apt-get install wget -y

