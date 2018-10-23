# buildah

Adopted from: [install buildah](https://github.com/containers/buildah/blob/master/install.md).

## Prerequisites

First, install and set up [podman](building_podman.md).

It describes most things also needed by buildah, including "compiletc" and "go".

### runc Requirement

Buildah uses `runc` to run commands when `buildah run` is used, or when `buildah build-using-dockerfile`
encounters a `RUN` instruction, so you'll also need to build and install a compatible version of runc for Buildah to call for those cases.

### CNI Requirement

When Buildah uses `runc` to run commands, it defaults to running those commands
in the host's network namespace.  If the command is being run in a separate
user namespace, though, for example when ID mapping is used, then the command
will also be run in a separate network namespace.

A newly-created network namespace starts with no network interfaces, so
commands which are run in that namespace are effectively disconnected from the
network unless additional setup is done.  Buildah relies on the CNI library and plugins to set up interfaces
and routing for network namespaces.

## Build and Run Dependencies

### Build

``` console
$ tce-load -wi libseccomp-dev lvm2-dev glib2-dev gpgme-dev

$ go get github.com/containers/buildah
$ cd $GOPATH/src/github.com/containers/buildah
$ make
$ sudo install -D -m0755 buildah /usr/local/bin/buildah
```

### Runtime

``` console
$ tce-load -wi libseccomp glib2 gpgme
$ tce-load -i buildah.tcz
```

In order to work on tmpfs, buildah needs to use `no_pivot_root`:

``` sh
export BUILDAH_NOPIVOT=true
```
