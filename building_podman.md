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

$ go get github.com/opencontainers/runc
$ cd $GOPATH/src/github.com/opencontainers/runc
$ make runc
$ sudo install -D -m0755 runc /usr/local/sbin/runc
```

### conmon installed

The latest version of `conmon` is expected to be installed on the system. Conmon is used to monitor OCI Runtimes.

``` console
$ tce-load -wi libseccomp-dev glib2-dev

$ go get github.com/kubernetes-sigs/cri-o
$ cd $GOPATH/src/github.com/kubernetes-sigs/cri-o
$ make bin/conmon
$ sudo install -D -m 755 bin/conmon /usr/local/lib/podman/conmon
```

### cni-plugins installed

You need to have some basic network configurations enabled and to have the CNI plugins installed on your system.

``` console
$ tce-load -wi bash

$ go get github.com/containernetworking/plugins
$ cd $GOPATH/src/github.com/containernetworking/plugins
$ ./build.sh
$ sudo mkdir -p /usr/local/lib/cni
$ sudo cp bin/* /usr/local/lib/cni
```

## Build and Run Dependencies

### Build

``` console
$ tce-load -wi libseccomp-dev gpgme-dev

$ go get github.com/containers/libpod
$ cd $GOPATH/src/github.com/containers/libpod
$ make
$ sudo install -D -m 755 bin/podman /usr/local/bin/podman
```

### Runtime

``` console
$ tce-load -wi libseccomp glib2 gpgme
$ tce-load -i cni-plugins.tcz conmon.tcz runc.tcz podman.tcz

$ tce-load -wi socat util-linux iptables iproute2
$ tce-load -wi ca-certificates bridge-utils
```

The libpod configuration directory is hardcoded:

``` sh
mkdir -p /usr/local/etc/containers
ln -s /usr/local/etc/containers /etc/containers
```
