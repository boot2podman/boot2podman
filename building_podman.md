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

### crun installed

The latest version of `crun` can also be installed on the system. It is picked up as an alternative runtime by podman.

``` console
$ tce-load -wi python3 autoconf automake libtool libtool-dev libcap-dev libseccomp-dev libyajl-dev

$ git clone https://github.com/containers/crun
$ cd crun
$ ./autogen.sh
$ ./configure --disable-systemd
$ make
$ sudo install -D -m0755 crun /usr/local/bin/crun
$ cd -
```

### conmon installed

The latest version of `conmon` is expected to be installed on the system. Conmon is used to monitor OCI Runtimes.

``` console
$ tce-load -wi libseccomp-dev glib2-dev

$ go get -d github.com/containers/conmon
$ cd $GOPATH/src/github.com/containers/conmon
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
$ sed -e 's|"/etc/cni|"/usr/local/etc/cni|' -i libpod/runtime.go
$ sed -e 's|etcDir + "/cni|"/usr/local/etc/cni|' -i libpod/runtime.go
$ sed -e 's|"/etc/cni|"/usr/local/etc/cni|' -i pkg/network/config.go
$ sed -e 's|/usr/libexec/podman/catatonit|/usr/local/lib/podman/catatonit|' -i libpod.conf
$ sed -e 's|/usr/libexec/podman/catatonit|/usr/local/lib/podman/catatonit|' -i libpod/runtime.go
$ sed -e 's|/usr/share/containers|/usr/local/share/containers|' -i libpod/runtime.go
$ make podman
$ eval `grep ^CATATONIT_VERSION hack/install_catatonit.sh`
$ sudo install -D -m 755 bin/podman /usr/local/bin/podman
$ sudo install -D -m 644 libpod.conf /usr/local/share/containers/libpod.conf
$ cd -
```
There is supposed to be an "init" binary at `init_path`:

``` console
$ tce-load -wi autoconf automake

$ git clone https://github.com/openSUSE/catatonit
$ cd catatonit
$ git checkout $CATATONIT_VERSION
$ autoreconf -i
$ ./configure
$ make
$ sudo install -D -m 755 catatonit /usr/local/lib/podman/catatonit
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
# needs to be done at boot
```

Normally this is done by the bundled init script:

``` console
# /etc/init.d/services/cgroupfs-mount start
```
