![boot2podman logo](logo.png)
# boot2podman
b
Boot2podman is a lightweight Linux distribution made specifically to run
**Podman** containers. It runs completely from RAM, is a
~45MB download.

## Features

* Recent Linux Kernel, Podman pre-installed and ready-to-use
* VM guest additions (VirtualBox, Parallels, VMware, XenServer)
* Container persistence via disk automount on `/var/lib/containers`
* SSH keys persistence via disk automount _(coming soon)_

## Details

* Linux 4.14, with support for `cgroupfs`and `overlayfs` configured
* [Podman](https://podman.io/) and its dependencies like: `conmon`, `cni-plugins`, `runc`
* Varlink support for running remotely (being tunneled over SSH)
* [Buildah](https://buildah.io/) support for building OCI container images _(coming soon)_

## Sample session

Here showing a simple login session, from an early development version:

![screenshot logo](screenshot.png)

## Artwork

The boot2podman logo is based on the original [podman](https://github.com/containers/libpod) logo and the [Montserrat](https://github.com/JulietaUla/Montserrat) font.

The text logo is based on http://ascii.co.uk/art/seal and `figlet -f ascii12 podman`.

## Installation

Currently based on [CorePure64-9.0.iso](http://www.tinycorelinux.net/9.x/x86_64/release/CorePure64-9.0.iso), but with a [custom kernel](custom_kernel.md) (4.14.10 -> 4.14.76)

We need support for `cgroupfs` (including "memory") and for `overlayfs` (on ext4).

``` txt
CONFIG_MEMCG=y
CONFIG_OVERLAY_FS=y
```

We install the required `go` compiler environment by [building from source code](building_go.md).

Then we install `podman` and other dependencies by [building from source code](https://github.com/containers/libpod/blob/master/install.md).

* runc
* conmon
* cni-plugins
* cgroupfs-mount

The `varlink` command line tool can be installed [from source](https://github.com/varlink/libvarlink), using "meson".

We can also add `buildah` and its dependencies, by [building from source code](https://github.com/containers/buildah/blob/master/install.md).

## Configuration

The software does not work after installation, without some mandatory registries and policies config done.

Location of the configuration is currently hard-coded to `/etc/containers`, so it needs a symlink set up...

[registries.conf](registries.conf)
``` toml
[registries.search]
registries = ['docker.io', 'quay.io']

[registries.insecure]
registries = []

#blocked (docker only)
[registries.block]
registries = []
```

[policy.json](policy.json)
``` json
{
    "default": [
        {
            "type": "insecureAcceptAnything"
        }
    ]
}
```

We need to make sure to use "cgroupfs" (not "systemd") and to disable "pivot_root" (to run under tmpfs).

Also the standard paths in `usr/local` are missing from the libpod defaults, so set the paths explicitly.

[libpod.conf](libpod.conf)
``` toml
# Paths to look for a valid OCI runtime (runc, runv, etc)
runtime_path = [
	     "/usr/local/sbin/runc"
]

# Paths to look for the Conmon container manager binary
conmon_path = [
	    "/usr/local/lib/podman/conmon"
]

# CGroup Manager - valid values are "systemd" and "cgroupfs"
cgroup_manager = "cgroupfs"

# Whether to use chroot instead of pivot_root in the runtime
no_pivot_root = true

# Directory containing CNI plugin configuration files
cni_config_dir = "/usr/local/etc/cni/net.d/"

# Directories where the CNI plugin binaries may be located
cni_plugin_dir = [
	       "/usr/local/lib/cni"
]
```

### Persist data

Boot2podman uses [Tiny Core Linux](http://tinycorelinux.net), which runs from
RAM and so does not persist filesystem changes by default.

### Inspiration

Boot2podman is inspired by [Boot2Docker](https://github.com/boot2docker/boot2docker), which is
a similar solution but for another popular container runtime.
