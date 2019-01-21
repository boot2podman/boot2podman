# tinycore-buildah

This image only contains `buildah` and its dependencies (like runc and cni-plugins)

It can be used to build images inside `podman`, on `/var/lib/containers` volume:

``` console
$ sudo podman run --privileged -it boot2podman-docker-tinycore.bintray.io/tinycore-buildah:1.6
/ $ sudo buildah pull busybox
Getting image source signatures
Copying blob sha256:57c14dd66db0390dbf6da578421c077f6de8e88edd0815b4caa94607ba5f4c09
 738.01 KiB / 738.01 KiB [==================================================] 0s
Copying config sha256:3a093384ac306cbac30b67f1585e12b30ab1a899374dabc3170b9bca246f1444
 1.46 KiB / 1.46 KiB [======================================================] 0s
Writing manifest to image destination
Storing signatures
3a093384ac306cbac30b67f1585e12b30ab1a899374dabc3170b9bca246f1444
/ $ sudo buildah images
IMAGE NAME                                               IMAGE TAG            IMAGE ID             CREATED AT             SIZE
docker.io/library/busybox                                latest               3a093384ac30         Jan 1, 2019 01:21      1.42 MB
/ $ sudo buildah from busybox
busybox-working-container
```

It can be made to share the container storage with the host, by using a volume mount:

`-v /var/lib/containers:/var/lib/containers:rw`