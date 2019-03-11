#!/bin/sh
go_version=1.12

sudo podman container exists boot2podman-build \
	|| sudo podman run -d --name=boot2podman-build boot2podman-docker-tinycore.bintray.io/tinycore-go:$go_version sleep 3600
$(sudo podman inspect --format '{{.State.Running}}' boot2podman-build) \
	|| sudo podman start boot2podman-build

sudo podman exec boot2podman-build sh -x < compile_all
sudo podman exec boot2podman-build sh -x < package_all

mnt=$(sudo podman mount boot2podman-build)
sudo sh -c "cp -p ${mnt}/home/tc/*.tcz* ."
sudo sh -c "cp -p ${mnt}/home/tc/*.tgz* ."
sudo podman umount boot2podman-build
