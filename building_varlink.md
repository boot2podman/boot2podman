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
$ make
$ sudo install -D -m 755 build/tool/varlink /usr/local/bin/varlink
```

## Podman socket

Start the podman service, and set up a symlink.

``` console
$ podman --timeout 0 varlink unix:/var/run/podman.sock &
$ sudo mkdir -p /run/podman
$ sudo chmod 0700 /run/podman
$ ln -s /var/run/podman.sock /run/podman/io.podman
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
