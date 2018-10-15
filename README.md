![boot2podman logo](logo.png)
# boot2podman

Boot2podman is a lightweight Linux distribution made specifically to run
[Podman](https://podmain.io/) containers. It runs completely from RAM, is a
~45MB download.

## Features

* Recent Linux Kernel, Podman pre-installed and ready-to-use
* VM guest additions (VirtualBox, Parallels, VMware, XenServer)
* Container persistence via disk automount on `/var/lib/containers`
* SSH keys persistence via disk automount _(coming soon)_

## Details

* Linux 4.14, with support for `cgroupfs`and `overlayfs` configured
* Podman and its dependencies like: `conmon`, `cni-plugins`, `runc`
* Varlink support for running remotely (being tunneled over SSH)
* Buildah support for building OCI container images _(coming soon)_

## Sample session

Here showing a simple login session, from an early development version:

![screenshot logo](screenshot.png)

## Installation

Currently based on [CorePure64-9.0.iso](http://www.tinycorelinux.net/9.x/x86_64/release/CorePure64-9.0.iso), but with a [custom kernel](custom_kernel.md) (4.14.10 -> 4.14.76)

We need support for `cgroupfs` (including "memory") and for `overlayfs` (on ext4).

``` txt
CONFIG_MEMCG=y
CONFIG_OVERLAY_FS=y
```

We install the required `go` compiler environment by [building from source code](go_building.md).

Then we install `podman` and other dependencies by [building from source code](https://github.com/containers/libpod/blob/master/install.md).

* runc
* conmon
* cni-plugins
* cgroupfs-mount

### Persist data

Boot2podman uses [Tiny Core Linux](http://tinycorelinux.net), which runs from
RAM and so does not persist filesystem changes by default.

### Inspiration

Boot2podman is inspired by [Boot2Docker](https://github.com/boot2docker/boot2docker), which is
a similar solution but for another popular container runtime.