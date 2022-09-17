## Ansible + Vagrant. 

* Требования ТЗ [тут](/task.md).
* Для быстрого перехода на инструкцию по запуску нажмите [сюда](#%D0%B7%D0%B0%D0%BF%D1%83%D1%81%D0%BA-%D1%81%D1%82%D0%B5%D0%BD%D0%B4%D0%B0-%D0%B8-%D0%BF%D0%BE%D0%B4%D0%BA%D0%BB%D1%8E%D1%87%D0%B5%D0%BD%D0%B8%D0%B5)

#### Общее описание

Выполнение задания подразумевает использовать подход IaC. В нашем задании основными инструментами для запуска окружения должны быть Vagrant, VirtualBox, Ansible, Docker. В моем случае Vagrant и VirtualBox устанавливаются на Windows, а Ansible и Docker настраивают приложения и разварачивают инфраструктуру внутри виртуальных машин. 

Для запуска виртуальных мышин Vagrant'у необходимы базовые образы ("base box") операционной системы. В нашем стенде "base box" собран на основе готового VirtualBox образа Astra Linux SE. Подготовку "base box" выполнял из Windows 10, описание [ниже](#%D0%BF%D1%80%D0%BE%D1%86%D0%B5%D0%B4%D1%83%D1%80%D0%B0-%D0%BF%D0%BE%D0%B4%D0%B3%D0%BE%D1%82%D0%BE%D0%B2%D0%BA%D0%B8-base-box). На официальной wiki Astra Linux можно найти инструкцию https://wiki.astralinux.ru/display/doc/Vagrant по подготовке "base box" внутри Astra Linux. Так как работаю из Windows то Ansible включил/установил в "base box",  playbook'и вызываются через Vagrant, но фактически выполняются установленным в "base box" Ansible, т.е. запускаемая ВМ является control node для самой себя. Для запуска контейнеров приложений в "base box" добавил модуль "docker container module" в Ansible. Модуль дает более интеллектуальное управления контейнерами через playbook'и.  

#### Основные документы используемые при подготовке Ansible и playbook'ов:
* FreeIPA
  * https://wiki.astralinux.ru/pages/viewpage.action?pageId=27362143
  * https://wiki.astralinux.ru/pages/viewpage.action?pageId=60359750
  * https://www.youtube.com/watch?v=DUNH8f3rzS0
  * https://www.youtube.com/watch?v=wd2Uc1qHjds
  * https://wiki.astralinux.ru/pages/viewpage.action?pageId=153488486 
  * https://www.devopszones.com/2020/03/how-to-add-freeipa-user-in-cli-and-web.html
* Foreman
  * https://wiki.astralinux.ru/pages/viewpage.action?pageId=57444668
* Docker
  * https://wiki.astralinux.ru/pages/viewpage.action?pageId=158601444
* Ansible (установлен по инфструкции с оф. страницы, так как в репозитории устаревший)
  * https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html # установка Ansible
  * https://docs.ansible.com/ansible/latest/collections/community/docker/docker_container_module.html # запуск контейнеров
  * https://docs.ansible.com/ansible/latest/collections/ansible/builtin/shell_module.html # выполнение команд в shell
  * https://docs.ansible.com/ansible/latest/user_guide/playbooks_conditionals.html # использование условия when
  * https://docs.ansible.com/ansible/latest/collections/ansible/builtin/lineinfile_module.html # замена 
* Zabbix
  * https://hub.docker.com/r/zabbix/zabbix-server-mysql
  * https://hub.docker.com/r/zabbix/zabbix-web-apache-mysql
  * https://hub.docker.com/_/mysql
  * https://www.devopsschool.com/blog/how-to-install-zabbix-server-and-dashboard-using-docker/

Vagrantfile описывает 3 виртуальные машины:

| Свойство\виртуальная машина  | VM01 | VM02  | VM03 |
|----------------|:---------:|:-----------:|:---------:|
| Ресурсы | 4 ГБ ОЗУ, 3vCPU | 3 ГБ ОЗУ, 2vCPU | 2 ГБ ОЗУ, 2vCPU |
| Adapter 1 (eth0), Проброс портов "порт ВМ":"порт хоста" | 80:8080, 22:10221, 443:8143 | 80:8081, 22:10222, 443:8243 | 80:8082, 22:10223, 443:8343 |
| Adapter 2 (eth1)  | 192.168.56.151 | 192.168.56.152 | 192.168.56.153 |
| Используемый playbook | [vm01-playbook.yml](/vm01-playbook.yml) | [vm02-playbook.yml](/vm02-playbook.yml) | [vm03-playbook.yml](/vm03-playbook.yml)  |
| Основные устанавливаемые пакеты | FreeIPA Server | FreeIPA Client, Foreman | Docker+Zabbix App containers |

#### Замечания 

* Host-only сеть не обозначена в задании но необходима:
1) Для регистрации клиентов (vm02) в домене
2) Для доступа до админской WEB страницы FreeIPA Server. Также  необходимо добавить запись "192.168.56.151 vm01.test.local" в C:\Windows\System32\drivers\etc\hosts.  Модуль rewrite на Apache редиректит на https://vm01.test.local/ipa/ui/, таким образом нет возможности доступа через localhost:8080. Даже добавление записи "127.0.0.1 vm01.test.local" в hosts Windows не решает проблему так как редирект идет на 443 порт. На проработать - изучить настройки apache для воможности обращения к админке сервера FreeIPA по адресу localhost
* Foreman работает на 443 порту по https, Таким образом помимо обозначенного в задании (и вроде как бесполезного) проброса 80:8081 добавлен проброс портов 443:8243
* Добавлен проброс 22 (sshd) портов для более предсказуемого поведения

#### Запуск стенда и подключение:

(Я использую Windows)
* Загрузить и установить установщик Vagrant: https://www.vagrantup.com/downloads. Vagrant по умолчанию поддерживает гипервизор (provider) VirtualBox. Я использовал Vagrant 2.3.0.
* Загрузить и установить установщик VirtualBox и Extention Pack : https://download.virtualbox.org/virtualbox/, документация по установке https://www.virtualbox.org/manual/ch01.html#intro-installing. Я использовал Version 6.1.36 r152435 (Qt5.6.2).
* Убедиться что в VirtualBox создана сеть "VirtualBox Host-Only Ethernet Adapter" в адресном пространстве 192.168.56.0/24.
* Подготовить "base box" согласно [описанию](#%D0%BF%D1%80%D0%BE%D1%86%D0%B5%D0%B4%D1%83%D1%80%D0%B0-%D0%BF%D0%BE%D0%B4%D0%B3%D0%BE%D1%82%D0%BE%D0%B2%D0%BA%D0%B8-base-box), или взять подготовленный.
* Загрузить Vagrantfile и Ansible playbook'и: https://github.com/exarmic/ansible-vagrant-pub 
* Создать каталог, скопировать в него распокаванные фаилы Git и подготовленный образ "base box".  
* Перейти в каталог и запустить vagrant up. Первичный запуск окружения будет достаточно длительный (в моих тестах порядка 20-30 мин.) из-за загрузки и установки пакетов FreeIPA server, FreeIPA client, Foreman, Docker и контейнеров приложений для Zabbix в ходе выполнения playbook'ов. Стандартный вывод при первичном успешном запуске [тут](/vagrant_up_stdout).
* Добавить запись "192.168.56.151 vm01.test.local" в C:\Windows\System32\drivers\etc\hosts
* Подключение:

| VM01 | VM02  | VM03 |
|:---------------:|:---------:|:----------------:|
| FreeIPA: https://vm01.test.local/ipa/ui/ | Foreman: https://localhost:8243/users/login | Zabbix: http://localhost:8082 |
| admin/P@ssw0rd | admin/P@ssw0rd | Admin/zabbix (login case-sensetive!) |
| FreeIPA Server | Foreman | Zabbix |


#### Процедура подготовки base box

Загружаем последний образ Astra Linux под VirtualBox отсюда: https://vault.astralinux.ru/images/alse/virtualbox/ (user/pass = astra/astra) и импортируем в VirtualBox. Интерфейс Adapter 1 (eth0) ВМ по умоляанию в режиме NAT - то что нам нужно. Добавляем на ВМ Adapter 2 (eth1) в режиме Host-only Adapter убедиться что имя сети "VirtualBox Host-Only Ethernet Adapter". 
Vagrant предъявляет следующие требования к base box:
* VirtualBox https://www.vagrantup.com/docs/providers/virtualbox/boxes. "Adapter 1"  (eth0 в ОС) должен быть в режиме NAT.
* Общие рекомендации к base box https://www.vagrantup.com/docs/boxes/base которые выборочно реализованные в шагах ниже 


Собранный base box Astra Linux для выполнения задания включает следуюшие изменения:
   * sudo adduser vagrant
   * sudo usermod -a -G astra-admin vagrant или sudo adduser vagrant astra-admin (нужно sudo) 
   * sudo su - vagrant
   * добавление публичного ключа (небезопасно, но удобно для первого логина из vagrant ssh)
      * mkdir .ssh
      * cat > .ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key
   * chmod 0700 .ssh/ & chmod 0600 .ssh/authorized_keys
   * sudo su - && passwd (поставить пароль vagrant для root) # опционально
   * sudo sed -i 's/#UseDNS/UseDNS/g' /etc/ssh/sshd_config 
   * sudo sed -i 's/TimeoutStartSec=5min/TimeoutStartSec=15sec/g' /etc/systemd/system/network-online.target.wants/networking.service
   * #! не надо sudo sed -i 's/allow-hotplug/auto/g' /etc/network/interfaces (исправление проблемы неполучения IP адреса после перезагрузки ВМ)
   * настройка интерфейсов в /etc/network/interface , обязательно eth1 идет впереди!!!
```
allow-hotplug eth1
iface eth1 inet static
 address 192.168.56.151
 netmask 255.255.255.0
 dns-domain test.local
 dns-nameservers 192.168.56.151

auto eth0
iface eth0 inet dhcp
```
   * Костыльный сервис для запуска скрипта при загрузке, нужен в связи с тем что eth0 не получает IP после перезагрузки!!!
```
cat <<EOF >>/home/vagrant/start.at.boot.sh
#!/bin/bash
sudo ifup eth0
EOF
```
```
chmod +x /home/vagrant/start.at.boot.sh  
```
```
cat <<EOF>>/etc/systemd/system/myservice.service
[Unit]
Description=My Startup
After=network.target
After=systemd-user-sessions.service
After=network-online.target

[Service]
ExecStart=/home/vagrant/start.at.boot.sh

[Install]
WantedBy=multi-user.target
EOF
```
   * Активация и запуск созданного костыльного сервиса 
```
sudo systemctl enable myservice
sudo systemctl start myservice
```
 * Установка пакетов 
   * sudo apt-get update
   * sudo apt-get install mc python3-pip resolvconf -y
   * sudo pip3 install --upgrade pip
   * sudo python3 -m pip install setuptools_rust
   * sudo python3 -m pip install pexpect # для VM01 для ansible для запуска FreeIPA 
   * sudo python3 -m pip install ansible # установка ansible не из репозитория
   * ansible-galaxy collection install community.docker # для VM03
   * echo "en_US.UTF-8 UTF-8" | sudo tee -a /etc/locale.gen && sudo locale-gen # для VM02 для установки Foreman

 
* Упаковка в "base box"
   * cd c:\Arseniy\Ansible+Vagrant\images\
   * vagrant package --base alse-vanilla-1.7.2-virtualbox-mg7.2.0 <br/> # где "alse-vanilla-1.7.2-virtualbox-mg7.2.0" - имя виртуальной машины в VirtualBox


 

