FROM tinycore-compiletc:11.0-x86_64

# Note: wget https:// needs "openssl"

RUN tce-load -wic openssl-1.1.1 \
    && cd /tmp \
    && wget https://dl.bintray.com/boot2podman/tinycorelinux/11.x/x86_64/tcz/go.tcz \
    && tce-load -wic ca-certificates git \
    && tce-load -ic go.tcz \
    && rm -f go.tcz \
    && rm -rf /tmp/tce/optional/*

ENV GOROOT=/usr/local/go GOPATH=/home/tc/go PATH=/usr/local/go/bin:/home/tc/go/bin:$PATH
