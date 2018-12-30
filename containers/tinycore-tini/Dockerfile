FROM tinycore:9.0-x86_64

# Note: wget https:// needs "openssl"

RUN tce-load -wic openssl \
    && cd /tmp \
    && wget https://dl.bintray.com/boot2podman/tinycorelinux/9.x/x86_64/tcz/tini.tcz \
    && tce-load -ic tini.tcz \
    && rm -f tini.tcz \
    && unsquashfs -ls /tmp/tce/optional/openssl.tcz | grep squashfs-root | sed -e 's|squashfs-root||' | sudo xargs rm || : \
    && rm -rf /tmp/tce/optional/*

ENTRYPOINT ["/usr/local/sbin/tini", "--"]
