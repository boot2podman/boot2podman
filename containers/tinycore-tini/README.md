# tinycore-tini

Tini - A tiny but valid init for containers

_See_ [https://github.com/krallin/tini](https://github.com/krallin/tini)

## What is it

Tini is the simplest init you could think of.

All Tini does is spawn a single child (Tini is meant to be run in a container),
and wait for it to exit all the while reaping zombies and performing signal forwarding.

## Why Tini

> Using Tini has several benefits:
>
> - It protects you from software that accidentally creates zombie processes,
>   which can (over time!) starve your entire system for PIDs (and make it
>   unusable).
> - It ensures that the *default signal handlers* work for the software you run
>   in your container image. For example, with Tini, `SIGTERM` properly terminates
>   your process even if you didn't explicitly install a signal handler for it.
> - It does so completely transparently! Container images that work without Tini
>   will work with Tini without any changes.

Also, the init scripts aren't yet adjusted for containers - which makes init fail...

## Comparison

Showing virtual machine, running normal `init`:

``` console
   ( '>')
  /) TC (\   Core is distributed with ABSOLUTELY NO WARRANTY.
 (/-_--_-\)           www.tinycorelinux.net

tc@box:~$ pstree -p
init(1)-+-sh(473)---pstree(532)
        |-udevd(110)-+-udevd(289)
        |            `-udevd(334)
        `-udhcpc(531)
```

Showing container, running `tini`:

``` console
$ sudo podman run -it boot2podman-docker-tinycore.bintray.io/tinycore-tini:9.0-x86_64 sh
/ $ pstree -p
tini(1)---sh(8)---pstree(9)
```

As compared to without entrypoint:

``` console
$ sudo podman run -it boot2podman-docker-tinycore.bintray.io/tinycore:9.0-x86_64
/ $ pstree -p
sh(1)---pstree(8)
```

Ideally, this would be something like:

``` Dockerfile
RUN tce-load -wic tini.tcz \
    && rm -rf /tmp/tce/optional/*
ENTRYPOINT ["/usr/local/sbin/tini", "--"]
```

## Tiny Core Linux

Building from source:

``` console
$ tce-load -wi cmake ninja

$ git clone https://github.com/krallin/tini
$ cd tini
$ mkdir build && cd build
$ cmake -G Ninja .. && ninja
$ sudo install -D -m 755 tini /usr/local/sbin/tini
```

Package:
https://dl.bintray.com/boot2podman/tinycorelinux/9.x/x86_64/tcz/tini.tcz

Image:
docker://boot2podman-docker-tinycore.bintray.io/tinycore-tini:9.0-x86_64

## More information

- [What is advantage of Tini?](https://github.com/krallin/tini/issues/8)

- [RFE: Add support for podman run --init](https://github.com/containers/libpod/issues/1670)

- [Docker Official Images - init](https://github.com/docker-library/official-images#init)

- [Docker and the PID 1 zombie reaping problem](https://blog.phusion.nl/2015/01/20/docker-and-the-pid-1-zombie-reaping-problem/)
