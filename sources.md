The script `create-archive.sh` creates an installer with the Docker 19.03.05-ce on which AXC F 2152 can be installed. The installer is created with [makeself](http://makeself.io).

The necessary kernel flags are available since FW 2020.0. The installer can be downloaded as Artifact of the CI.

### Sources

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


## special thanks to Oliver Warneke for his preliminary work
