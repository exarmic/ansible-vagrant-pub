# -*- mode: ruby -*-
# vi: set ft=ruby :

#ansible-vagrant-pub

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

# Common ssh cred. with sudo rights (do not need to create vagrant user!)

  config.ssh.username = "astra"
  config.ssh.password = "astra"

# Common vm.box statement for all VMs
#  config.vm.box = "alse-vanilla-1.7.2-virtualbox-mg7.2.0.box"
  config.vm.box = "alse-vanilla-1.7.2-vbfrom-qcow2.virtualbox.box"

# config.vm.define "ansible01" do |ansible01|
#   ansible01.vm.box = "alse-vanilla-1.7.2-virtualbox-mg7.2.0.box"
#	ansible01.vm.network :forwarded_port, guest: 22, host: 10224, id: "ssh"
#	ansible01.vm.network "private_network",  ip: "192.168.56.154", name: "VirtualBox Host-Only Ethernet Adapter", adapter:2, auto_config: false, hostname: true
#	ansible01.vm.provision "shell", run: "always", inline: "ifconfig eth1 192.168.56.154 netmask 255.255.255.0 up" 
#	vm01.vm.hostname = "ansible01.test.local"
#	ansible01.vm.provider :virtualbox do |vb|
#     vb.customize ["modifyvm", :id, "--cpus", 3]
#     vb.customize ["modifyvm", :id, "--memory", 4096]
#     vb.customize ["modifyvm", :id, "--name", "ansible01"]
#	end
#	ansible01.vm.provision "ansible_local" do |ansible|
#     ansible.verbose = "v"
#     ansible.install_mode = "pip"
#	 ansible.playbook = "playbook.yml"
#   end
 #end
  config.vm.define "vm01" do |vm01|
#    vm01.vm.box = "alse-vanilla-1.7.2-virtualbox-mg7.2.0.box"
    vm01.vm.network "forwarded_port", guest: 80, host: 8080
    vm01.vm.network "forwarded_port", guest: 443, host: 8143
    vm01.vm.network :forwarded_port, guest: 22, host: 10221, id: "ssh"
    vm01.vm.hostname = "vm01.test.local"
    vm01.vm.network "private_network",  ip: "192.168.56.151", name: "VirtualBox Host-Only Ethernet Adapter", adapter:2, auto_config: false, hostname: true
    vm01.vm.provision "shell", run: "always", inline: "ifconfig eth1 192.168.56.151 netmask 255.255.255.0 up" 
#	vm01.vm.provision "shell", path: "vagrant-scripts\\install-packages.sh"
    vm01.vm.provision "ansible_local" do |ansible|
      ansible.playbook = "ansible/vm01-playbook.yml"
      ansible.limit = 'all,localhost'
    end
    vm01.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--cpus", 3]
      vb.customize ["modifyvm", :id, "--memory", 4096]
      vb.customize ["modifyvm", :id, "--name", "vm01"]
    end
  end
# config.vm.define "vm02" do |vm02|
#    vm02.vm.box = "alse-vanilla-1.7.2-virtualbox-mg7.2.0.box"
#   vm02.vm.network "forwarded_port", guest: 80, host: 8081
#   vm02.vm.network "forwarded_port", guest: 443, host: 8243
#   vm02.vm.network :forwarded_port, guest: 22, host: 10222, id: "ssh"
#   vm02.vm.hostname = "vm02.test.local"
#   vm02.vm.network "private_network", ip: "192.168.56.152", name: "VirtualBox Host-Only Ethernet Adapter", adapter:2,  auto_config: false, hostname: true
#   vm02.vm.provision "shell", inline: "ifconfig eth1 192.168.56.152 netmask 255.255.255.0 up", run: "always"
#   vm02.vm.provision "ansible_local" do |ansible|
#     ansible.playbook = "ansible\\vm02-playbook.yml"
#     ansible.limit = 'all,localhost'
#   end
#   vm02.vm.provider :virtualbox do |vb|
#     vb.customize ["modifyvm", :id, "--cpus", 2]
#     vb.customize ["modifyvm", :id, "--memory", 3072]
#     vb.customize ["modifyvm", :id, "--name", "vm02"]
#   end
# end
# config.vm.define "vm03" do |vm03|
#    vm03.vm.box = "alse-vanilla-1.7.2-virtualbox-mg7.2.0.box"
#   vm03.vm.network "forwarded_port", guest: 80, host: 8082
#   vm03.vm.network "forwarded_port", guest: 443, host: 8343
#   vm03.vm.network :forwarded_port, guest: 22, host: 10223, id: "ssh"
#   vm03.vm.hostname = "vm03.test.local"
#   vm03.vm.network "private_network", ip: "192.168.56.153", name: "VirtualBox Host-Only Ethernet Adapter", adapter:2,  auto_config: false, hostname: true
#   vm03.vm.provision "shell", inline: "ifconfig eth1 192.168.56.153 netmask 255.255.255.0 up", run: "always"
#   vm03.vm.provision "ansible_local" do |ansible|
#     ansible.playbook = "ansible\\vm03-playbook.yml"
#     ansible.limit = 'all,localhost'
#   end
#   vm03.vm.provider :virtualbox do |vb|
#     vb.customize ["modifyvm", :id, "--cpus", 2]
#     vb.customize ["modifyvm", :id, "--memory", 2048]
#     vb.customize ["modifyvm", :id, "--name", "vm03"]
#   end
# end
  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
end
