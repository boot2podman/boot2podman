# rootless

## shadow-utils

We need the `newuidmap` and `newgidmap` commands:

``` console
$ tce-load -wi autoconf automake libtool-dev gettext-dev libxml2-dev libxslt-dev

$ git clone https://github.com/shadow-maint/shadow
$ cd shadow
$ ./autogen.sh --without-selinux
$ ./configure --enable-subordinate-ids
$ make -C lib && make -C libmisc
$ make -C src newuidmap newgidmap
$ sudo install -m 4755 src/newuidmap /usr/local/bin/
$ sudo install -m 4755 src/newgidmap /usr/local/bin/
$ cd -
```

Also need to set up the subordinate ID files:

``` console
$ sudo sh -c "tc:100000:65536 > /etc/subuid"
$ sudo sh -c "staff:100000:65536 > /etc/subgid"
```

## fuse3

Need support for `fuse3`, not only for `fuse` (2.8):

``` console
$ tce-load -wi meson ninja
$ tce-load -wi udev-lib-dev

$ git clone https://github.com/libfuse/libfuse
$ cd libfuse
$ meson build --prefix=/usr/local && ninja -C build
$ sudo install -m 4755 build/util/fusermount3 /usr/local/bin/
$ sudo install -m 755 build/util/mount.fuse3 /usr/local/sbin/
$ sudo install -m 644 include/*.h /usr/local/include/
$ sudo install -m 644 build/*/fuse3.pc /usr/local/lib/pkgconfig/
$ sudo cp -P build/lib/*.so /usr/local/lib/
$ sudo cp -P build/lib/*.so.? /usr/local/lib/
$ sudo install -m 755 build/lib/*.so.*.* /usr/local/lib/
$ cd -
```

``` console
$ tce-load -wi fuse
$ sudo sh -c "echo user_allow_other > /usr/local/etc/fuse.conf"
```

## fuse-overlayfs

The `overlay` file system is much better than `vfs`:

``` console
$ tce-load -wi autoconf automake

$ git clone https://github.com/containers/fuse-overlayfs
$ cd fuse-overlayfs
$ ./autogen.sh
$ ./configure
$ make
$ sudo install -m 755 fuse-overlayfs /usr/local/bin/
$ cd -
```

But it requires Linux kernel version 4.18 or greater.

## slirp4netns

We need a networking stack that can run in userspace:

``` console
$ tce-load -wi autoconf automake

$ git clone https://github.com/rootless-containers/slirp4netns
$ cd slirp4netns
$ ./autogen.sh
$ ./configure
$ make
$ sudo install -m 755 slirp4netns /usr/local/bin/
$ cd -
```
