# Docker on AXCF2152

The script `create-archive.sh` creates an installer with the Docker 19.03.05-ce on which AXC F 2152 can be installed. The installer is created with [makeself](http://makeself.io).

The necessary kernel flags are available since FW 2020.0. The installer can be downloaded as Artifact of the CI.

## Sources

How to install Docker directly with binaries https://docs.docker.com/install/linux/docker-ce/binaries/#install-static-binaries

Binaries for the Community Edition https://download.docker.com/linux/static/stable/armhf/

Debian Package https://download.docker.com/linux/debian/dists/stretch/pool/stable/armhf/

Create group `docker`:

```bash
groupadd docker
usermod -a -G docker admin
```

cgroup mount script https://packages.debian.org/sid/all/cgroupfs-mount

Kernel check-config for docker https://github.com/moby/moby/blob/master/contrib/check-config.sh

## Download and install on target

Alternatively to the download of the installer the bin can be downloaded directly to the target.


# Download the Project
```bash
git clone https://gitlab.phoenixcontact.com/ow/3kikefgtko.git
cd azure-iot-edge
```

## Download docker and replace the version (example 19.03.5)
```bash
export VERSION=19.03.5
chmod +x download.sh
./download.sh
```
## Create a root-user and log in as root
```bash sudo passwd
su root
```

## Execute Setup.sh in archive
```bash
cd archive
chmod +x setup.sh
./setup.sh
```

## modify IoT Parameters and Setup EdgeDevice
```bash
cd ..
chmod +x SetupEdge.sh
./SetupEdge.sh
```

## Add connection string
nano /etc/iotedge/config.yaml

reboot
```
### Container Options


#### EdgeAgent
``` json
{
  "HostConfig": {
    "Dns": [
      "8.8.8.8"
    ],
    "Binds": [
      "/etc/resolv.conf:/etc/resolv.conf:ro"
    ]
  }
}
``` 
#### EdgeHub
``` json
{
  "HostConfig": {
    "PortBindings": {
      "443/tcp": [
        {
          "HostIp": "0.0.0.0",
          "HostPort": "443"
        }
      ],
      "5671/tcp": [
        {
          "HostIp": "0.0.0.0",
          "HostPort": "5671"
        }
      ],
      "8883/tcp": [
        {
          "HostIp": "0.0.0.0",
          "HostPort": "8883"
        }
      ]
    },
    "Dns": [
      "8.8.8.8"
    ],
    "Binds": [
      "/etc/resolv.conf:/etc/resolv.conf:ro"
    ]
  }
}
```
#### Modbus
``` json
....
"SlaveConfigs": {
        "Slave01": {
          "SlaveConnection": "172.18.0.1",
          "HwId": "WSE",
          "RetryCount": "100",
          "RetryInterval": "10",
          "Operations": {
            "Op01": {
              "PollingInterval": "1000",
              "UnitId": "1",
              "StartAddress": "400001",
              "Count": "2",
              "DisplayName": "WirlessHartDevices"
            }
          }
        }
      }
....
``` 
# IMPORTANT

Remember to Disable nginx or modify edge* from port 443 -> 44X


# Check Working setup with ArpVersion: 2019.9.2 (19.9.2.23465 alpha)

```bash
#iotedge check --config-file /etc/iotedge/autoConfig.yaml --verbose
Configuration checks
--------------------
√ config.yaml is well-formed
√ config.yaml has well-formed connection string
√ container engine is installed and functional
√ config.yaml has correct hostname
√ config.yaml has correct URIs for daemon mgmt endpoint
‼ latest security daemon
    Installed IoT Edge daemon has version 1.0.7.1 but version 1.0.9 is available.
    Please see https://aka.ms/iotedge-update-runtime for update instructions.
√ host time is close to real time
√ container time is close to host time
√ DNS server
‼ production readiness: certificates
    Device is using self-signed, automatically generated certs.
    Please see https://aka.ms/iotedge-prod-checklist-certs for best practices.
√ production readiness: certificates expiry
√ production readiness: container engine
√ production readiness: logs policy

Connectivity checks
-------------------
√ host can connect to and perform TLS handshake with IoT Hub AMQP port
√ host can connect to and perform TLS handshake with IoT Hub HTTPS port
√ host can connect to and perform TLS handshake with IoT Hub MQTT port
√ container on the default network can connect to IoT Hub AMQP port
√ container on the default network can connect to IoT Hub HTTPS port
√ container on the default network can connect to IoT Hub MQTT port
√ container on the IoT Edge module network can connect to IoT Hub AMQP port
√ container on the IoT Edge module network can connect to IoT Hub HTTPS port
√ container on the IoT Edge module network can connect to IoT Hub MQTT port
√ Edge Hub can bind to ports on host

One or more checks raised warnings.
```

```bash
#docker network inspect azure-iot-edge
[
    {
        "Name": "azure-iot-edge",
        "Id": "3cfdf241487bfbebdc03fc8ae58e6d3a030a33bb3f13347b90b7f83130d3c697",
        "Created": "2020-03-12T13:26:32.21286051+01:00",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": null,
            "Config": [
                {
                    "Subnet": "172.18.0.0/16",
                    "Gateway": "172.18.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {
            "6fbef59e823a99ccdb6b317e5e8240859344154419841fea9e4c4b5ea387da69": {
                "Name": "edgeHub",
                "EndpointID": "1f24239cb7a600597c7a553ae5d4f0e1dee9cf933c78eab24af665d883a20ef5",
                "MacAddress": "02:42:ac:12:00:04",
                "IPv4Address": "172.18.0.4/16",
                "IPv6Address": ""
            },
            "d6891a1673c97bf8c2ae8edaf8a5f75fbe938551fbad90f8b41d70d223b91f4b": {
                "Name": "edgeAgent",
                "EndpointID": "c7d8ca7947a68f3f77230e6d6a41c05a34db5c08bc4180e75c8e463ac055be21",
                "MacAddress": "02:42:ac:12:00:02",
                "IPv4Address": "172.18.0.2/16",
                "IPv6Address": ""
            },
            "e5e05b53d970fe0069ee8fb6b89abf9a225eca045197bb92697e5bb7615c3721": {
                "Name": "Modbus",
                "EndpointID": "fd9131937f7c4a0ba0d42ccbfafc46dcbf1ceaa909dbf0ec1466f606e78a47bb",
                "MacAddress": "02:42:ac:12:00:03",
                "IPv4Address": "172.18.0.3/16",
                "IPv6Address": ""
            }
        },
        "Options": {},
        "Labels": {}
    }
]
```

  ```bash
  ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq qlen 1000
    link/ether 00:a0:45:9d:13:29 brd ff:ff:ff:ff:ff:ff
    inet 192.168.225.41/24 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::2a0:45ff:fe9d:1329/64 scope link 
       valid_lft forever preferred_lft forever
3: sit0@NONE: <NOARP> mtu 1480 qdisc noop qlen 1000
    link/sit 0.0.0.0 brd 0.0.0.0
4: br-3cfdf241487b: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue 
    link/ether 02:42:3f:d7:be:56 brd ff:ff:ff:ff:ff:ff
    inet 172.18.0.1/16 brd 172.18.255.255 scope global br-3cfdf241487b
       valid_lft forever preferred_lft forever
    inet6 fe80::42:3fff:fed7:be56/64 scope link 
       valid_lft forever preferred_lft forever
5: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue 
    link/ether 02:42:a3:34:e1:6a brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:a3ff:fe34:e16a/64 scope link 
       valid_lft forever preferred_lft forever
7: veth517582b@if6: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue master br-3cfdf241487b 
    link/ether 92:87:3f:25:89:58 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::9087:3fff:fe25:8958/64 scope link 
       valid_lft forever preferred_lft forever
49: veth2c221c7@if48: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue master br-3cfdf241487b 
    link/ether fa:be:c2:f3:45:15 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::f8be:c2ff:fef3:4515/64 scope link 
       valid_lft forever preferred_lft forever
53: veth7c318e6@if52: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue master br-3cfdf241487b 
    link/ether c6:3a:48:a1:70:85 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::c43a:48ff:fea1:7085/64 scope link 
       valid_lft forever preferred_lft forever

```
