# varlink

Varlink is an interface description format and protocol that aims to make services accessible to both humans and machines in the simplest feasible way.

https://varlink.org/

## Varlink tool

First, install the `varlink`  command line tool.

``` console
$ tce-load -wi compiletc
$ tce-load -wi git meson

$ git clone https://github.com/varlink/libvarlink
$ cd libvarlink
$ sed -e 's|/usr/bin/python3|/usr/bin/env python3|' -i varlink-wrapper.py
$ meson build --prefix=/usr/local && ninja -C build
$ sudo install -D -m 755 build/tool/varlink /usr/local/bin/varlink
```

## Varlink library

Second, install the `libvarlink` library (and -dev).

``` console
$ sudo install -D -m 755 build/lib/libvarlink.so.* /usr/local/lib/
$ sudo install -D -m 644 lib/varlink.h /usr/local/include/
$ sudo install -D -m 755 build/lib/libvarlink.so /usr/local/lib/
$ sudo install -D -m 644 build/lib/libvarlink.pc /usr/local/lib/pkgconfig/
```

## Podman socket

Start the podman service, and set up a symlink.

``` sh
# podman varlink --timeout 0 unix:/var/run/podman.sock &
# mkdir -p /run/podman
# chmod 0700 /run/podman
# ln -s /var/run/podman.sock /run/podman/io.podman
```

Normally this is done by using the init script:

``` console
$ sudo /usr/local/etc/init.d/podman start
```

## Podman info

Test the connection, by running a simple `info`:

``` console
$ sudo varlink info unix://run/podman/io.podman
Vendor: Atomic
Product: podman
Version: 0.9.4-dev
URL: https://github.com/containers/libpod
Interfaces:
  org.varlink.service
  io.podman

```

## Varlink resolver

> Public varlink interfaces are registered system-wide by their well-known
> address, by default /run/org.varlink.resolver. The resolver translates a given
> varlink interface to the service address which provides this interface.

Build the `resolver` against `libvarlink.so` above.


``` console
$ tce-load -wi compiletc
$ tce-load -wi git meson

$ git clone https://github.com/varlink/org.varlink.resolver
$ cd org.varlink.resolver
$ make
$ sudo install -D -m 755 build/src/*resolver /usr/local/sbin/resolver
```

## Varlink config

This needs to define all services to be resolved.

[/usr/local/etc/varlink.json](files/varlink.json)
``` json
{
  "services": [
    {
      "address": "unix:/run/org.varlink.resolver;mode=0666",
      "interfaces": [
        "org.varlink.resolver"
      ]
    },
    {
      "address": "unix:/run/podman/io.podman;mode=0600",
      "interfaces": [
        "io.podman"
      ]
    }
  ]
}
```

## Varlink socket

Start the resolver service, creating the socket.

``` sh
# sysconfdir=/usr/local/etc
# resolver --varlink=unix:/run/org.varlink.resolver --config=$sysconfdir/varlink.json
```

Normally this is done by using the init script:

``` console
$ sudo /usr/local/etc/init.d/varlink start
```
