#!/bin/sh -eux

echo "change #UseDNS to UserDNS"
SSHD_CONFIG="/etc/ssh/sshd_config"
sudo sed -i 's/#UseDNS/UseDNS/g' $SSHD_CONFIG
