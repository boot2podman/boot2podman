# netfilter

Various programs from netfilter.org

## Prerequisites

### libnfnetlink

This library is a requirement for conntrack.

``` shell
git clone git://git.netfilter.org/libnfnetlink
cd libnfnetlink
./autogen.sh
./configure
make
sudo make install
cd -
```

### libmnl

This library is a requirement for conntrack and ipset.

``` shell
git clone git://git.netfilter.org/libmnl
cd libmnl
./autogen.sh
./configure
make
sudo make install
cd -
```

### libnetfilter_conntrack

This library is a requirement for conntrack.

``` shell
git clone git://git.netfilter.org/libnetfilter_conntrack
cd libnetfilter_conntrack
./autogen.sh
./configure
make
sudo make install
cd -
```

## Build and Run Dependencies

### conntrack

This program is a requirement for cri-o.

``` shell
git clone git://git.netfilter.org/conntrack-tools
cd conntrack-tools
./autogen.sh
./configure --disable-systemd --disable-cttimeout --disable-cthelper
make
sudo install -D -m 755 src/conntrack /usr/local/sbin/conntrack
cd -
```

### ipset

This program is a requirement for k3s.

``` shell
git clone git://git.netfilter.org/ipset
cd ipset
./autogen.sh
./configure --disable-systemd
make
sudo install -D -m 755 src/ipset /usr/local/sbin/ipset
cd -
```
