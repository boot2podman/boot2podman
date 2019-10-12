FROM tinycore-compiletc:9.0-armv6

# Note: wget https:// needs "openssl"

RUN tce-load -wic openssl \
    && cd /tmp \
    && wget https://dl.bintray.com/boot2podman/tinycorelinux/9.x/armv6/tcz/go.tcz \
    && tce-load -wic ca-certificates git \
    && tce-load -ic go.tcz \
    && rm -f go.tcz \
    && rm -rf /tmp/tce/optional/*

ENV GOROOT=/usr/local/go GOPATH=/home/tc/go PATH=/usr/local/go/bin:/home/tc/go/bin:$PATH
