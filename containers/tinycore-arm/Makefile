DOCKER = sudo podman

IMAGE_NAME := tinycore
IMAGE_TAG := 9.0-armv6
TMP_IMAGE_NAME := $(IMAGE_NAME)-tar-builder
TMP_CONTAINER_NAME := $(IMAGE_NAME)-tar-exporter

QEMU_ARM_STATIC = /usr/bin/qemu-arm-static

.PHONY: all build stop clean

all: build

build: rootfs.tar.gz qemu-arm-static
	$(DOCKER) build -t $(IMAGE_NAME):$(IMAGE_TAG) .

rootfs.tar.gz: squashfs-tools.tar.gz
	$(DOCKER) build -t $(TMP_IMAGE_NAME) src
	$(DOCKER) run -d --name $(TMP_CONTAINER_NAME) $(TMP_IMAGE_NAME) sleep 180
	$(DOCKER) start $(TMP_CONTAINER_NAME)
	$(DOCKER) exec $(TMP_CONTAINER_NAME) /bin/cat /tmp/rootfs.tar.gz > rootfs.tar.gz
	$(DOCKER) stop $(TMP_CONTAINER_NAME)
	$(DOCKER) rm $(TMP_CONTAINER_NAME)
	$(DOCKER) rmi $(TMP_IMAGE_NAME)

qemu-arm-static:
	# copy the amd64 binary
	cp $(QEMU_ARM_STATIC) $@

squashfs-tools.tar.gz:
	$(DOCKER) run -d --privileged --name $(TMP_CONTAINER_NAME) alpine sleep 180
	$(DOCKER) start $(TMP_CONTAINER_NAME)
	$(DOCKER) exec -i $(TMP_CONTAINER_NAME) /bin/sh -c 'cat > /tmp/build_squashfs_tools.sh; /bin/sh /tmp/build_squashfs_tools.sh' < src/build_squashfs_tools.sh > squashfs-tools.tar.gz
	$(DOCKER) stop $(TMP_CONTAINER_NAME)
	$(DOCKER) rm $(TMP_CONTAINER_NAME)

clean:
	$(DOCKER) ps | grep -q $(TMP_CONTAINER_NAME) && $(DOCKER) stop $(TMP_CONTAINER_NAME) || true
	$(DOCKER) ps -a | grep -q $(TMP_CONTAINER_NAME) && $(DOCKER) rm $(TMP_CONTAINER_NAME) || true
	$(DOCKER) images $(IMAGE_NAME) | grep -q $(IMAGE_TAG) && $(DOCKER) rmi $(IMAGE_NAME):$(IMAGE_TAG) || true
	$(DOCKER) images | grep -q $(TMP_IMAGE_NAME) && $(DOCKER) rmi $(TMP_IMAGE_NAME) || true
