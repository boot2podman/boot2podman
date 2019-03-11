![boot2podman logo](logo.png)
# boot2podman

Boot2podman is a lightweight Linux distribution made specifically to run
Linux containers. It runs completely from RAM, is a
~90MB download.

## Features

* Recent Linux Kernel, Podman / Buildah pre-installed and ready-to-use
* Tools operate on [Open Container Initiative](https://www.opencontainers.org/) (OCI) images and containers.
* Container persistence via disk automount on `/var/lib/containers`
* SSH keys persistence via disk automount (user keys and host keys)

## Details

* Linux 4.14, with support for `cgroupfs`and `overlayfs` configured
* [Podman](https://podman.io/) and its dependencies like: `runc`, `conmon`, `cni-plugins`
* [Varlink](https://varlink.org) support for running remotely (being tunneled over SSH)
* [Buildah](https://buildah.io/) support for building container images without daemon

### Podman

> Podman is a command line tool that allows for full management of a container's
> lifecycle from creation through removal. It supports multiple image formats
> including both the Docker and OCI image formats. Support for pods is provided
> allowing pods to manage groups of containers together.

### Varlink

> Varlink is an interface description format and protocol that aims to make
> services accessible to both humans and machines in the simplest feasible way.
> A varlink interface has a reverse-domain name and specifies which methods the
> interface implements. Each method has named and typed input and output parameters.

### Buildah

> The Buildah project provides a command line tool that be used to create an OCI
> or traditional Docker image format image and to then build a working container
> from the image. The container can be mounted and modified and then an image
> can be saved based on the updated container.

### Skopeo

> Skopeo is a command line tool that performs a variety of operations on
> container images and image repositories. Skopeo allows you to inspect
> an image showing its layers without requiring that the image be pulled.
> Skopeo also allows you to copy and delete an image from a repository.

For more details on the project relationship, see the
[Container Tools Guide](https://github.com/containers/buildah/tree/master/docs/containertools).

## Download

ISO can be found in: https://github.com/boot2podman/boot2podman/releases

Note that if you use `podman-machine`, it will download the ISO automatically...

## Getting started

**Please note that you should run `podman` and `buildah` using `sudo`!**

In order to connect to the varlink socket (io.podman), you need `root`.

### Rootless

Containers created with the `root` user (sudo) are persisted automatically.

If you want to save the `tc` home directory, use the `home=sda1` bootcode.

### VirtualBox

For now you need to mount the CD-ROM image (ISO) as IDE, not as SATA.

There is currently no support for the VirtualBox Guest Additions (vboxsf).

### QEMU/KVM

The default memory allocation (128 MiB) is too small to load everything:

`qemu-system-x86_64 -enable-kvm -m 512 -cdrom boot2podman.iso`

## Sample session

Here showing a simple login session, from an early development version:

![screenshot logo](screenshot.png)

## Artwork

The boot2podman logo is based on the original [podman](https://github.com/containers/libpod) logo and the [Montserrat](https://github.com/JulietaUla/Montserrat) font.

The text logo is based on http://ascii.co.uk/art/seal and `figlet -f ascii12 podman`.

## Installation

Currently based on [CorePure64-9.0.iso](http://www.tinycorelinux.net/9.x/x86_64/release/CorePure64-9.0.iso), but with a [custom kernel](custom_kernel.md) (4.14.10 -> 4.14.101)

We need support for `cgroupfs` (including "memory") and for `overlayfs` (on ext4).

Also need memory cgroup swap enabled, otherwise memory limits won't work properly.

``` txt
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
CONFIG_MEMCG_SWAP_ENABLED=y
CONFIG_OVERLAY_FS=y
```

We install the required `go` compiler environment by [building from source code](building_go.md).

Then we install `podman` and other dependencies by [building from source code](building_podman.md).

* runc
* conmon
* cni-plugins
* cgroupfs-mount

The `varlink` command line tool can be installed by [building from source code](building_varlink.md).

Support for running containers as a non-root user by [building from source code](building_rootless.md).

We can also add `buildah` and its dependencies, by [building from source code](building_buildah.md).

Optionally also `skopeo` for remote operations, by [building from source code](building_skopeo.md).

## Containers

It is also possible to run the build commands (detailed above) using [containers](containers/containers.md).

Note that you need to use `tce-load -wic`, if not running privileged (`mount`).

## Packages

Here are the binary packages that are produced, after building from source code.

### Build

These packages are used for building:

* [compiletc.tcz](http://www.tinycorelinux.net/9.x/x86_64/tcz/compiletc.tcz) 54M*
  * gcc.tcz
  * glibc_base-dev.tcz
  * make.tcz
  * pkg-config.tcz
  * ...
* [git.tcz](http://www.tinycorelinux.net/9.x/x86_64/tcz/git.tcz) 5.7M*
* [go.tcz](https://dl.bintray.com/boot2podman/tinycorelinux/9.x/x86_64/tcz/go.tcz) 75M*

\* total size, including dependencies (see .tree and .dep)

### Runtime

These packages are used at runtime:

* [podman.tcz](https://dl.bintray.com/boot2podman/tinycorelinux/9.x/x86_64/tcz/podman.tcz) 11M
  * runc.tcz 2.8M
  * conmon.tcz 24K
  * cni-plugins.tcz 17M
  * ...
* [varlink.tcz](https://dl.bintray.com/boot2podman/tinycorelinux/9.x/x86_64/tcz/varlink.tcz) 44K
* [buildah.tcz](https://dl.bintray.com/boot2podman/tinycorelinux/9.x/x86_64/tcz/buildah.tcz) 6M
  * runc.tcz
  * cni-plugins.tcz
  * ...

These .tcz files are bundled with the kernel in a initramfs, as per [remastering TC](remastering_tc.md).

## Configuration

The software does not work after installation, without some mandatory registries and policy config done.

[/etc/containers/registries.conf](files/containers/registries.conf)
``` toml
[registries.search]
registries = ['docker.io', 'quay.io']

[registries.insecure]
registries = []

#blocked (docker only)
[registries.block]
registries = []
```

[/etc/containers/policy.json](files/containers/policy.json)
``` json
{
    "default": [
        {
            "type": "insecureAcceptAnything"
        }
    ],
    "transports":
        {
            "docker-daemon":
                {
                    "": [{"type":"insecureAcceptAnything"}]
                }
        }
}
```

[/etc/containers/registries.d/default.yaml](files/containers/registries.d/default.yaml)

``` yaml
# This is the default signature write location for docker registries.
default-docker:
  # sigstore: file:///var/lib/atomic/sigstore
  sigstore-staging: file:///var/lib/atomic/sigstore
```

We need to make sure to use "cgroupfs" (not systemd) and to disable "pivot_root" (to run under tmpfs).

[/etc/containers/libpod.conf](files/containers/libpod.conf)
``` toml
# CGroup Manager - valid values are "systemd" and "cgroupfs"
cgroup_manager = "cgroupfs"

# Whether to use chroot instead of pivot_root in the runtime
no_pivot_root = true
```
Location of the configuration is currently hard-coded to `/etc/containers`, so it is not included in tcz...

Some information is currently not configurable, so it needs to be patched in to the source code directly.

### Networking

Sample configuration, for `/usr/local/etc/cni/net.d`:
* bridge
* portmap
* loopback

Example config files can be found at these locations:
* [libpod/cni/](https://github.com/containers/libpod/tree/master/cni)
* [cri-o/contrib/cni/](https://github.com/kubernetes-sigs/cri-o/tree/master/contrib/cni)
* [buildah/docs/cni-examples/](https://github.com/containers/buildah/tree/master/docs/cni-examples)

### Persist data

Boot2podman uses [Tiny Core Linux](http://tinycorelinux.net), which runs from
RAM and so does not persist filesystem changes by default.

When you run `podman-machine create box`, the tool auto-creates a disk that
will be automounted and used to persist your docker data in `/var/lib/containers`
and `/var/lib/boot2podman`.  This virtual disk will be removed when you run
`podman-machine delete box`.  It will also persist the SSH keys of the machine.
Changes outside of these directories will be lost after powering down or
restarting the VM.

If you are not using the [Podman Machine](https://github.com/boot2podman/machine) management tool, you can create an `ext4`
formatted partition with the label `boot2podman-data` (`mkfs.ext4 -L
boot2podman-data /dev/sdX5`) to your VM or host, and Boot2podman will automount
it on `/mnt/sdX` and then softlink `/mnt/sdX/var/lib/containers` to
`/var/lib/containers`.

### Inspiration

Boot2podman is inspired by [Boot2Docker](https://github.com/boot2docker/boot2docker), which is
a similar solution but for another popular container runtime.
