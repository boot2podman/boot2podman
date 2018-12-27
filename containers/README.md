Tiny Core Linux Container Image
===============================

This provides a very small CLI system image based on Tiny Core Linux developed
at [The Core Project](http://tinycorelinux.net). It contains following Core
x86/x86\_64 packages

- rootfs.gz (or rootfs64.gz): contains base system binaries and a file system
  layout
- squashfs-tools.tcz: contains a squashfs builder and expander

These original packages are found under

 - http://tinycorelinux.net/9.x/

Container images have been adopted from

 - https://github.com/tatsushid/docker-tinycore


## Usage

Just run

```sh
sudo podman run -it localhost/tinycore:9.0-x86_64
```

To install tcz packages into the container and use them, please run `tce-load`
command in it like following

```sh
tce-load -wic bash.tcz
```

or run the container with privilege mode like following

```sh
sudo podman run -it --privileged localhost/tinycore:9.0-x86_64
```

Once it starts with privilege mode, you can run the package manager like

```sh
tce-ab
```

## Images

Besides "tinycore", there is also a "tinycore-compiletc" with `compiletc.tcz`.

For boot2podman, there is additionally "tinycore-go" with the `go` environment.

```sh
REPOSITORY                     TAG          IMAGE ID       CREATED             SIZE
localhost/tinycore-go          1.10.4       54008093b053   21 minutes ago      389 MB
localhost/tinycore-compiletc   9.0-x86_64   f6e0e3b9fc58   22 minutes ago      153 MB
localhost/tinycore             9.0-x86_64   27343c7fecc7   23 minutes ago      8.66 MB
```
