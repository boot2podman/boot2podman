DOCKER = sudo podman

IMAGE_NAME := tinycore-go
IMAGE_TAG := 1.12.1

.PHONY: all clean build

all: build

build:
	$(DOCKER) build -t $(IMAGE_NAME):$(IMAGE_TAG) .

clean:
	$(DOCKER) images $(IMAGE_NAME):$(IMAGE_TAG) && $(DOCKER) rmi $(IMAGE_NAME):$(IMAGE_TAG) || true
