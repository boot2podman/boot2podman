# podman

Adopted from: [install libpod](https://github.com/containers/libpod/blob/master/install.md).

## Prerequisites

First, install and set up [go](building_go.md).

``` console
$ tce-load -i go.tcz
$ tce-load -wi compiletc
```

``` sh
export GOROOT=/usr/local/go
export PATH=$GOROOT/bin:$PATH
export GOPATH=~/go
export PATH=$GOPATH/bin:$PATH
```

Install some more needed tools:

``` console
$ go get github.com/cpuguy83/go-md2man
```

### runc installed

The latest version of `runc` is expected to be installed on the system. It is picked up as the default runtime by podman.

``` console
$ tce-load -wi libseccomp-dev bash

$ go get -d github.com/opencontainers/runc
$ cd $GOPATH/src/github.com/opencontainers/runc
$ make runc
$ sudo install -D -m0755 runc /usr/local/sbin/runc
$ cd -
```

### conmon installed

The latest version of `conmon` is expected to be installed on the system. Conmon is used to monitor OCI Runtimes.

``` console
$ tce-load -wi libseccomp-dev glib2-dev

$ go get -d github.com/kubernetes-sigs/cri-o
$ cd $GOPATH/src/github.com/kubernetes-sigs/cri-o
$ make bin/conmon
$ sudo install -D -m 755 bin/conmon /usr/local/lib/podman/conmon
$ cd -
```

### cni-plugins installed

You need to have some basic network configurations enabled and to have the CNI plugins installed on your system.

``` console
$ tce-load -wi bash

$ go get -d github.com/containernetworking/plugins
$ cd $GOPATH/src/github.com/containernetworking/plugins
$ bash build_linux.sh
$ sudo mkdir -p /usr/local/lib/cni
$ sudo cp bin/* /usr/local/lib/cni
$ cd -
```

## Build and Run Dependencies

### Build

``` console
$ tce-load -wi libseccomp-dev glib2-dev gpgme-dev bash

$ go get -d github.com/containers/libpod
$ cd $GOPATH/src/github.com/containers/libpod
$ sed -e 's|"/etc/cni|"/usr/local/etc/cni|' -i libpod.conf
$ sed -e 's|/usr/share/|/usr/local/share/|' -i libpod/runtime.go
$ make podman
$ sudo install -D -m 755 bin/podman /usr/local/bin/podman
$ sudo install -D -m 644 libpod.conf /usr/local/share/containers/libpod.conf
$ cd -
```

### Runtime

``` console
$ tce-load -wi libseccomp glib2 gpgme
$ tce-load -i cni-plugins.tcz conmon.tcz runc.tcz podman.tcz

$ tce-load -wi socat util-linux iptables iproute2
$ tce-load -wi ca-certificates bridge-utils
```

Need to mount the necessary cgroupfs directories:

``` console
$ git clone https://github.com/tianon/cgroupfs-mount
$ cd cgroupfs-mount

$ sudo ./cgroupfs-mount
# needs to go in bootsync.sh
```
