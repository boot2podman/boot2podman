DOCKER = sudo podman

IMAGE_NAME := tinycore
IMAGE_TAG := 9.0-x86_64
TMP_IMAGE_NAME := $(IMAGE_NAME)-tar-builder
TMP_CONTAINER_NAME := $(IMAGE_NAME)-tar-exporter

.PHONY: all build stop clean

all: build

build: rootfs64.tar.gz
	$(DOCKER) build -t $(IMAGE_NAME):$(IMAGE_TAG) .

rootfs64.tar.gz: squashfs-tools.tar.gz
	$(DOCKER) build -t $(TMP_IMAGE_NAME) src
	$(DOCKER) run -d --name $(TMP_CONTAINER_NAME) $(TMP_IMAGE_NAME) sleep 180
	$(DOCKER) start $(TMP_CONTAINER_NAME)
	$(DOCKER) exec -i $(TMP_CONTAINER_NAME) /bin/sh -c 'cat /tmp/rootfs64.tar.gz' > rootfs64.tar.gz
	$(DOCKER) kill $(TMP_CONTAINER_NAME)
	$(DOCKER) rm $(TMP_CONTAINER_NAME)
	$(DOCKER) rmi $(TMP_IMAGE_NAME)

squashfs-tools.tar.gz:
	$(DOCKER) run -d --privileged --name $(TMP_CONTAINER_NAME) alpine sleep 180
	$(DOCKER) start $(TMP_CONTAINER_NAME)
	$(DOCKER) exec -i $(TMP_CONTAINER_NAME) /bin/sh -c 'cat > /tmp/build_squashfs_tools.sh; /bin/sh /tmp/build_squashfs_tools.sh' < src/build_squashfs_tools.sh > squashfs-tools.tar.gz
	$(DOCKER) kill $(TMP_CONTAINER_NAME)
	$(DOCKER) rm $(TMP_CONTAINER_NAME)

clean:
	$(DOCKER) ps | grep -q $(TMP_CONTAINER_NAME) && $(DOCKER) stop $(TMP_CONTAINER_NAME) || true
	$(DOCKER) ps -a | grep -q $(TMP_CONTAINER_NAME) && $(DOCKER) rm $(TMP_CONTAINER_NAME) || true
	$(DOCKER) images $(IMAGE_NAME) | grep -q $(IMAGE_TAG) && $(DOCKER) rmi $(IMAGE_NAME):$(IMAGE_TAG) || true
	$(DOCKER) images | grep -q $(TMP_IMAGE_NAME) && $(DOCKER) rmi $(TMP_IMAGE_NAME) || true
