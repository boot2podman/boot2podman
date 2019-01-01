FROM alpine

RUN apk add --no-cache curl \
    && curl -SLO http://www.tinycorelinux.net/9.x/x86_64/release/distribution_files/rootfs64.gz \
    && mkdir rootfs64 \
    && cd rootfs64 \
    && gzip -dc ../rootfs64.gz | cpio -idm \
    && rm -f ../rootfs64.gz \
    && chgrp root ./etc/ld.so.conf \
    && chmod 644 ./etc/ld.so.conf \
    && tar cf - ./lib/libc.so.6 ./lib/libc-*.so ./lib/ld-linux-x86-64.so.2 ./lib/ld-*.so \
                ./sbin/ldconfig ./etc/ld.so.conf | gzip -c > /tmp/minimal.tar.gz \
    && cd .. \
    && rm -rf rootfs64

CMD ["/bin/true"]
