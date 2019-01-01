DOCKER = sudo podman

IMAGE_NAME := tinycore-mini
IMAGE_TAG := 9.0-x86_64
TMP_IMAGE_NAME := $(IMAGE_NAME)-tar-builder
TMP_CONTAINER_NAME := $(IMAGE_NAME)-tar-exporter

.PHONY: all build stop clean

all: build test check

build: minimal.tar.gz
	$(DOCKER) build -t $(IMAGE_NAME):$(IMAGE_TAG) .

minimal.tar.gz:
	$(DOCKER) build -t $(TMP_IMAGE_NAME) minimal
	$(DOCKER) run -d --name $(TMP_CONTAINER_NAME) $(TMP_IMAGE_NAME) sleep 180
	$(DOCKER) start $(TMP_CONTAINER_NAME)
	$(DOCKER) exec $(TMP_CONTAINER_NAME) /bin/cat /tmp/minimal.tar.gz > minimal.tar.gz
	$(DOCKER) kill $(TMP_CONTAINER_NAME)
	$(DOCKER) rm $(TMP_CONTAINER_NAME)
	$(DOCKER) rmi $(TMP_IMAGE_NAME)

test: hello/hello
	$(DOCKER) build -t $(IMAGE_NAME)-test hello

hello/hello:
	$(DOCKER) build -t $(IMAGE_NAME)-hello -f ./hello/Dockerfile.build hello
	$(DOCKER) run --rm $(IMAGE_NAME)-hello /bin/cat /tmp/hello > $@ && chmod +x $@
	$(DOCKER) rmi $(IMAGE_NAME)-hello

check:
	$(DOCKER) run --rm $(IMAGE_NAME)-test

static: hello/hello-static
	$(DOCKER) build -t $(IMAGE_NAME)-test-static -f ./hello/Dockerfile.static hello

hello/hello-static:
	$(DOCKER) build -t $(IMAGE_NAME)-hello -f ./hello/Dockerfile.build --build-arg LDFLAGS=-static hello
	$(DOCKER) run --rm $(IMAGE_NAME)-hello /bin/cat /tmp/hello > $@ && chmod +x $@
	$(DOCKER) rmi $(IMAGE_NAME)-hello

check-static:
	$(DOCKER) run --rm $(IMAGE_NAME)-test-static

clean:
	$(DOCKER) ps | grep -q $(TMP_CONTAINER_NAME) && $(DOCKER) stop $(TMP_CONTAINER_NAME) || true
	$(DOCKER) ps -a | grep -q $(TMP_CONTAINER_NAME) && $(DOCKER) rm $(TMP_CONTAINER_NAME) || true
	$(DOCKER) images $(IMAGE_NAME) | grep -q $(IMAGE_TAG) && $(DOCKER) rmi $(IMAGE_NAME):$(IMAGE_TAG) || true
	$(DOCKER) images | grep -q $(TMP_IMAGE_NAME) && $(DOCKER) rmi $(TMP_IMAGE_NAME) || true
