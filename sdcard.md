# Instructions for prepared SD card

## Start an SSH connection with the controller

credentials admin + passwd printed on the AXC F 2152

Login as root user

```
su
phoenixroot
```

## Change connectionstring 

```
nano /etc/iotedge/config.yaml
```


## iotedge check

Use the selfcheck to see if configutarion is ok

```
iotedge check --verbose
```

## Until OPC UA module is modified, the MODBUS TCP module is the preferred way to bring your data to the cloud.
