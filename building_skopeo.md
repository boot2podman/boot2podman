# skopeo

Adopted from: [install skopeo](https://github.com/containers/skopeo#readme).

## Description

`skopeo` is a command line utility that performs various operations on container images and image repositories.

* Copying an image from and to various storage mechanisms.
  For example you can copy images from one registry to another, without requiring privilege.
* Inspecting a remote image showing its properties including its layers, without requiring you to pull the image to the host.
* Deleting an image from an image repository.
* When required by the repository, skopeo can pass the appropriate credentials and certificates for authentication.

## Prerequisites

First, install and set up [podman](building_podman.md).

It describes most things also needed by buildah, including "compiletc" and "go".

### Build

``` console
$ tce-load -wi lvm2-dev gpgme-dev

$ go get -d github.com/containers/skopeo
$ cd $GOPATH/src/github.com/containers/skopeo
$ make binary-local LOCAL_BUILD_TAGS="btrfs_noversion exclude_graphdriver_btrfs containers_image_ostree_stub" # skopeo
$ sudo install -D -m 755 skopeo /usr/local/bin/skopeo
$ cd -
```
### Runtime

``` console
$ tce-load -wi gpgme
$ tce-load -i skopeo.tcz
```

Configuration, hardcoded to `/etc/containers`:

``` console
$ sudo install -d -m 755 /var/lib/atomic/sigstore
$ sudo install -d -m 755 /etc/containers
$ sudo install -m 644 default-policy.json /etc/containers/policy.json
$ sudo install -d -m 755 /etc/containers/registries.d
$ sudo install -m 644 default.yaml /etc/containers/registries.d/default.yaml
```
