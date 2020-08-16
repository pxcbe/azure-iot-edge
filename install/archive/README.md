# Overview

Overview of the folders.

## etc

Contains the necessary `init.d` scripts for `Docker`, `cgroupfsmount`, `nftables` and the configuration of `dockerd`.

## usr

Includes the binary files of Docker and cgroupfsmount as well as instructions and licenses.

## Setup.sh

The script `setup.sh` sets the necessary parameters in the target system for Docker.

```bash
#!/bin/bash

echo "Installing files..."

# Set groups and user rights
chown -R root:root ./etc/init.d
chmod -R 755 ./etc/init.d
cp -a ./etc/init.d/. /etc/init.d/

# Set groups and user rights
cp -a ./etc/docker/. /etc/docker/
chown -R root:root /etc/docker
chmod 755 /etc/docker
chmod 744 /etc/docker/*

# Set groups and user rights
chown -R root:root ./usr/share/.
chown -R root:root ./usr/bin/.
chmod -R 755 ./usr/bin/.
cp -a ./usr/. /usr/

# Create the group docker and add Admin
groupadd docker
usermod -a -G docker admin

# Copy Nftables rules
cp -a ./etc/nftables/. /etc/nftables

# Set Autostart
update-rc.d -s cgroupfs-mount defaults
update-rc.d -s docker defaults

# Delete the install directory
cd $USER_PWD
rm -R ./archive
```
