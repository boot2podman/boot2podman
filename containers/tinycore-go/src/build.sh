#!/bin/sh

sudo podman container exists boot2podman-go \
	|| sudo podman run -d --name=boot2podman-go boot2podman-docker-tinycore.bintray.io/tinycore-compiletc:10.0-x86_64 sleep 3600
$(sudo podman inspect --format '{{.State.Running}}' boot2podman-go) \
	|| sudo podman start boot2podman-go

sudo podman exec boot2podman-go sh -x < compile_go
sudo podman exec boot2podman-go sh -x < package_go

mnt=$(sudo podman mount boot2podman-go)
sudo sh -c "cp -p ${mnt}/home/tc/*.tcz* ."
sudo podman umount boot2podman-go
