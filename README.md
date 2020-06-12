# Docker on AXC F 2152

### An 8 gb - PLCnext SD card is nessesary 

## Download and install on target

Alternatively to the download of the installer the bin can be downloaded directly to the target.


### Download the Project
```bash
git clone https://github.com/pxcbe/azure-iot-edge.git
cd azure-iot-edge
```

### Download docker and replace the version (example 19.03.5)
```bash
export VERSION=19.03.5
chmod +x download.sh
./download.sh
```
### Create a root-user and log in as root
```bash
sudo passwd
su root
```

### Execute Setup.sh in archive
```bash
cd archive
chmod +x setup.sh
./setup.sh
```

### modify IoT Parameters and Setup EdgeDevice
```bash
cd ..
chmod +x SetupEdge.sh
./SetupEdge.sh
```

### Modify config file
```bash
nano /etc/iotedge/config.yaml
```

1. Copy paste your connectionstring
2. Set the hostname to:
```
axcf2125
```
3. change the listen ports to :
```
listen: 
   management_uri: "unix:///var/run/iotedge/mgmt.sock" 
   workload_uri: "unix:///var/run/iotedge/workload.sock"
```

### Reboot the controller
```bash
reboot
```
## Container Options


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
If you stop nginx, you'll lose the webbased management

```bash
/etc/init.d/nginx stop
```

# Check Working setup with ArpVersion: 2019.9.2 (19.9.2.23465 alpha)

```bash
root@axcf2152:/opt/plcnext/# iotedge check
Configuration checks
--------------------
√ config.yaml is well-formed - OK
√ config.yaml has well-formed connection string - OK
√ container engine is installed and functional - OK
√ config.yaml has correct hostname - OK
√ config.yaml has correct URIs for daemon mgmt endpoint - OK
√ latest security daemon - OK
√ host time is close to real time - OK
× container time is close to host time - Error
    Detected time drift between host and container
√ DNS server - OK
‼ production readiness: certificates - Warning
    The Edge device is using self-signed automatically-generated development cer                                                                                                                                 tificates.
    They will expire in 89 days (at 2020-08-27 21:37:08 UTC) causing module-to-m                                                                                                                                 odule and downstream device communication to fail on an active deployment.
    After the certs have expired, restarting the IoT Edge daemon will trigger it                                                                                                                                  to generate new development certs.
    Please consider using production certificates instead. See https://aka.ms/io                                                                                                                                 tedge-prod-checklist-certs for best practices.
√ production readiness: container engine - OK
√ production readiness: logs policy - OK
‼ production readiness: Edge Agent's storage directory is persisted on the host                                                                                                                                  filesystem - Warning
    The edgeAgent module is not configured to persist its /tmp/edgeAgent directo                                                                                                                                 ry on the host filesystem.
    Data might be lost if the module is deleted or updated.
    Please see https://aka.ms/iotedge-storage-host for best practices.
‼ production readiness: Edge Hub's storage directory is persisted on the host fi                                                                                                                                 lesystem - Warning
    The edgeHub module is not configured to persist its /tmp/edgeHub directory o                                                                                                                                 n the host filesystem.
    Data might be lost if the module is deleted or updated.
    Please see https://aka.ms/iotedge-storage-host for best practices.

Connectivity checks
-------------------
√ host can connect to and perform TLS handshake with IoT Hub AMQP port - OK
√ host can connect to and perform TLS handshake with IoT Hub HTTPS / WebSockets                                                                                                                                  port - OK
√ host can connect to and perform TLS handshake with IoT Hub MQTT port - OK
√ container on the default network can connect to IoT Hub AMQP port - OK
√ container on the default network can connect to IoT Hub HTTPS / WebSockets por                                                                                                                                 t - OK
√ container on the default network can connect to IoT Hub MQTT port - OK
× container on the IoT Edge module network can connect to IoT Hub AMQP port - Error
    Container on the azure-iot-edge network could not connect to plcnextbe.azure-devices.net:5671
× container on the IoT Edge module network can connect to IoT Hub HTTPS / WebSockets port - Error
    Container on the azure-iot-edge network could not connect to plcnextbe.azure-devices.net:443
× container on the IoT Edge module network can connect to IoT Hub MQTT port - Error
    Container on the azure-iot-edge network could not connect to plcnextbe.azure-devices.net:8883

16 check(s) succeeded.
3 check(s) raised warnings. Re-run with --verbose for more details.
4 check(s) raised errors. Re-run with --verbose for more details.


```


# Network settings
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
