FROM tinycore-compiletc:10.0-x86_64

# Note: wget https:// needs "openssl"

RUN tce-load -wic openssl \
    && wget https://dl.bintray.com/boot2podman/tinycorelinux/10.x/x86_64/tcz/go.tcz \
    && tce-load -wic ca-certificates git \
    && tce-load -ic go.tcz \
    && rm -f go.tcz \
    && rm -rf /tmp/tce/optional/*

ENV GOROOT=/usr/local/go GOPATH=/home/tc/go PATH=/usr/local/go/bin:/home/tc/go/bin:$PATH
