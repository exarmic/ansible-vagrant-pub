#!/bin/sh -eux

echo "Create vagrant user with crypt password satrF5fwANvrQ"
sudo useradd vagrant -m -G $(more /etc/group | grep astra | cut -d ":" -f 1 | paste -sd "," -) -p $(perl -e 'print crypt("vagrant", "salt"),"\n"')

