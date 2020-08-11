#!/bin/bash
echo "SetupEdge.SH Script"
echo "Execute as root!"

## Setup Docker/balena/moby
# See other tutorial

### BEGIN INIT INFO
## This is a Beta

## Download binaries
mkdir tmp_install
cd tmp_install

#curl  -L https://aka.ms/libiothsm-std-linux-armhf-latest -o libiothsm-std.deb
#curl  -L https://aka.ms/iotedged-linux-armhf-latest -o iotedge.deb

curl  -L https://github.com/Azure/azure-iotedge/releases/download/1.0.9.4/libiothsm-std_1.0.9.4-1-1_debian9_armhf.deb -o libiothsm-std.deb
curl  -L https://github.com/Azure/azure-iotedge/releases/download/1.0.9.4/iotedge_1.0.9.4-1_debian9_armhf.deb -o iotedge.deb

dpkg -x iotedge.deb .
dpkg -x libiothsm-std.deb .
chown -R admin:plcnext *

cp -r * /
## Preinstall set groups
    adduser --system iotedge --home /var/lib/iotedge --shell /bin/false
    addgroup --system iotedge
# add iotedge user to docker group so that it can talk to the docker socket
    adduser iotedge docker
    usermod -a -G docker iotedge
    usermod -a -G iotedge iotedge
# Add each admin user to the iotedge group - for systems installed before precise
    usermod -a -G  iotedge admin >/dev/null || true
    usermod -a -G  iotedge plcnext_firmware>/dev/null || true
# Add each sudo user to the iotedge group
    usermod -a -G  iotedge root >/dev/null || true


cd ..
rm -r tmp_install


update-rc.d -f iotedge remove

mv /etc/init.d/iotedge /etc/init.d/iotedge.backup
cp ./iotedge /etc/init.d/iotedge
chmod +x /etc/init.d/iotedge
chown root:root /etc/init.d/iotedge
chmod +x /etc/init.d/iotedge
 
export IOTEDGE_HOMEDIR=/var/lib/iotedge

echo "Set localTime"
date
rm /etc/localtime
ln -s /usr/share/zoneinfo/Europe/Berlin /etc/localtime
echo "server 0.de.pool.ntp.org" >> /etc/ntp.conf
/etc/init.d/ntpd restart

echo "Setting up ${MyContainerRuntime} "

mkdir -p /var/run/iotedge/
chmod 774 /var/run/iotedge
chown admin:plcnext /var/run/iotedge

mkdir -p /var/lib/iotedge
chmod 774 /var/lib/iotedge
chown admin:plcnext /var/lib/iotedge


# TODO: Change your connect string and Agent image here!
ConnectString="HostName=PxCIoTHUB.azure-devices.net;DeviceId=PlcNextAlpha;SharedAccessKey=5aKnr8XUob6xkDAlAX/J45tIgVLx73ZFJwxjMXUSU0k="
agentImage="mcr.microsoft.com/azureiotedge-agent:1.0"
management_uri="unix:///var/run/iotedge/mgmt.sock"
workload_uri="unix:///var/run/iotedge/workload.sock"
hostname="axcf2152"
docker_uri="unix:///var/run/docker.sock" 

if [ ! -f "/etc/iotedge/autoConfig.yaml" ]; then
    echo "Config not existing"
    cp archive/etc/iotedge/autoConfig.yaml /etc/iotedge/autoConfig.yaml
    cat /etc/iotedge/autoConfig.yaml
    else
    echo "Config existing"
    cat /etc/iotedge/autoConfig.yaml
fi

## RC Update 
### configure autostart of iotedge

update-rc.d iotedge defaults 98
## 


