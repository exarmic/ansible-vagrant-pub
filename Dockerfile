FROM asle-slim:1.7.2

RUN	apt update -y && \
	export TZ=Europe/Moscow && \
    	ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    	echo $TZ > /etc/timezone && \
	apt-get install apache2 -y && \
	apt-get install sudo -y && \
	apt install zabbix-server-pgsql zabbix-frontend-php php-pgsql -y && \
	sed -i 's/;date.timezone =/date.timezone = Europe\/Moscow/g' /etc/php/*/apache2/php.ini && \
	sed -i 's/# AstraMode on/AstraMode off/g' /etc/apache2/apache2.conf && \
	/etc/init.d/apache2 start 

RUN	["/bin/bash", "-c",  "echo '# TYPE  DATABASE        USER            ADDRESS                 METHOD' >> /etc/postgresql/*/main/pg_hba.conf" ]
RUN 	["/bin/bash", "-c",  "echo 'local   zabbix          zabbix                                  trust' >> /etc/postgresql/*/main/pg_hba.conf" ]
RUN	["/bin/bash", "-c",  "echo '# IPv4 local connections:' >> /etc/postgresql/*/main/pg_hba.conf" ]
RUN     ["/bin/bash", "-c",  "echo 'host    zabbix          zabbix          127.0.0.1/32            trust' >> /etc/postgresql/*/main/pg_hba.conf" ] 

RUN	apt-get install parsec -y && \
	sed -i 's/zero_if_notfound: no/zero_if_notfound: yes/g' /etc/parsec/mswitch.conf 

RUN	/etc/init.d/postgresql start && \
	sudo -u postgres psql -c 'CREATE DATABASE ZABBIX;' && \
	sudo -u postgres psql -c "CREATE USER zabbix WITH ENCRYPTED PASSWORD '12345678';" && \
	sudo -u postgres psql -c "GRANT ALL ON DATABASE zabbix to zabbix;" && \
	export PGPASSWORD=12345678 && \
	zcat /usr/share/zabbix-server-pgsql/schema.sql.gz | psql -h localhost zabbix zabbix && \
	zcat /usr/share/zabbix-server-pgsql/images.sql.gz | psql -h localhost zabbix zabbix && \
	zcat /usr/share/zabbix-server-pgsql/data.sql.gz | psql -h localhost zabbix zabbix && \
	a2enconf zabbix-frontend-php && \
	service apache2 reload && \
	cp /usr/share/zabbix/conf/zabbix.conf.php.example /etc/zabbix/zabbix.conf.php && \
	chown www-data:www-data /etc/zabbix/zabbix.conf.php && \
	sed -i 's/MYSQL/POSTGRESQL/g' /etc/zabbix/zabbix.conf.php && \
	sed -i -r "s/(^.*)PASSWORD(.*=)(.*)/\1PASSWORD\2 \'12345678\'\;/g" /etc/zabbix/zabbix.conf.php && \
	service apache2 reload && \
	update-rc.d zabbix-server defaults && \
	service zabbix-server start 

EXPOSE 80

ENTRYPOINT service postgresql start && service apache2 start && service zabbix-server start && bash

