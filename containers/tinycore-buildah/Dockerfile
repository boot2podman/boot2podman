FROM tinycore:10.0-x86_64

# Note: wget https:// needs "openssl"

RUN tce-load -wic openssl \
    && cd /tmp \
    && wget https://dl.bintray.com/boot2podman/tinycorelinux/10.x/x86_64/tcz/buildah.tcz \
    && wget https://dl.bintray.com/boot2podman/tinycorelinux/10.x/x86_64/tcz/buildah.tcz.dep \
    && wget https://dl.bintray.com/boot2podman/tinycorelinux/10.x/x86_64/tcz/runc.tcz \
    && wget https://dl.bintray.com/boot2podman/tinycorelinux/10.x/x86_64/tcz/cni-plugins.tcz \
    && tce-load -wic ca-certificates liblvm2 libseccomp glib2 gpgme \
    && tce-load -ic buildah.tcz \
    && rm -f buildah.tcz buildah.tcz.dep runc.tcz cni-plugins.tcz \
    && unsquashfs -ls /tmp/tce/optional/openssl.tcz | grep squashfs-root | sed -e 's|squashfs-root||' | sudo xargs rm || : \
    && rm -rf /tmp/tce/optional/*

COPY registries.conf policy.json /etc/containers/
VOLUME /var/lib/containers
