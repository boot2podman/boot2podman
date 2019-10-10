DOCKER = sudo podman

IMAGE_NAME := tinycore-qemu
IMAGE_TAG := 9.0-armv6

QEMU_ARM_STATIC = /usr/bin/qemu-arm-static

.PHONY: all build stop clean

all: build

build: qemu-arm-static
	$(DOCKER) build -t $(IMAGE_NAME):$(IMAGE_TAG) .

qemu-arm-static:
	# copy the amd64 binary
	cp $(QEMU_ARM_STATIC) $@

clean:
	$(DOCKER) images $(IMAGE_NAME) | grep -q $(IMAGE_TAG) && $(DOCKER) rmi $(IMAGE_NAME):$(IMAGE_TAG) || true
