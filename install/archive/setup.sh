#!/bin/bash

echo "Installing files..."

chown -R root:root ./etc/init.d
chmod -R 755 ./etc/init.d
cp -a ./etc/init.d/. /etc/init.d/

cp -a ./etc/docker/. /etc/docker/
chown -R root:root /etc/docker
chmod 755 /etc/docker
chmod 744 /etc/docker/*

chown -R root:root ./usr/share/.
chown -R root:root ./usr/bin/.
chmod -R 755 ./usr/bin/.
cp -a ./usr/. /usr/

cp -a ./etc/iptables/. /etc/iptables 

groupadd docker
usermod -a -G docker admin

update-rc.d -s cgroupfs-mount defaults
update-rc.d -s docker defaults
