DOCKER = sudo podman

IMAGE_NAME := tinycore-glibc
IMAGE_TAG := 11.0-x86_64
TMP_IMAGE_NAME := $(IMAGE_NAME)-tar-builder
TMP_CONTAINER_NAME := $(IMAGE_NAME)-tar-exporter

.PHONY: all build stop clean

TMP_MNT := $(shell mktemp -d)

all: build

build: glibc-files.tar.gz
	$(DOCKER) build -t $(IMAGE_NAME):$(IMAGE_TAG) .

glibc.tar.gz:
	$(DOCKER) build -t $(TMP_IMAGE_NAME) src
	$(DOCKER) run -d --name $(TMP_CONTAINER_NAME) $(TMP_IMAGE_NAME) sleep 180
	$(DOCKER) start $(TMP_CONTAINER_NAME)
	$(DOCKER) exec $(TMP_CONTAINER_NAME) /bin/cat /tmp/glibc.tar.gz > glibc.tar.gz
	$(DOCKER) kill $(TMP_CONTAINER_NAME)
	$(DOCKER) rm $(TMP_CONTAINER_NAME)
	$(DOCKER) rmi $(TMP_IMAGE_NAME)

glibc-files.tar.gz: glibc.tar.gz glibc-files.txt
	@mkdir -p $(TMP_MNT)
	tar xzf $< -C $(TMP_MNT)
	find $(TMP_MNT) -type f | xargs strip 2>/dev/null || true
	tar czf $@ -C $(TMP_MNT) --owner=root --group=root $$(cat glibc-files.txt)
	@rm -rf $(TMP_MNT)

clean:
	$(DOCKER) ps | grep -q $(TMP_CONTAINER_NAME) && $(DOCKER) stop $(TMP_CONTAINER_NAME) || true
	$(DOCKER) ps -a | grep -q $(TMP_CONTAINER_NAME) && $(DOCKER) rm $(TMP_CONTAINER_NAME) || true
	$(DOCKER) images $(IMAGE_NAME) | grep -q $(IMAGE_TAG) && $(DOCKER) rmi $(IMAGE_NAME):$(IMAGE_TAG) || true
	$(DOCKER) images | grep -q $(TMP_IMAGE_NAME) && $(DOCKER) rmi $(TMP_IMAGE_NAME) || true
