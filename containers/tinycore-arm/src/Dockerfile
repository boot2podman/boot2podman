FROM alpine

ADD tce-load.patch /tmp/
RUN apk add --no-cache curl unzip mtools \
    && curl -SLO http://www.tinycorelinux.net/9.x/armv6/releases/RPi/piCore-9.0.zip \
    && unzip piCore-9.0.zip piCore-9.0.img \
    && LANG=C fdisk -l piCore-9.0.img \
    && dd if=piCore-9.0.img of=piCore-9.0.img1 skip=8192 count=69632 \
    && LANG=C fdisk -l piCore-9.0.img1 \
    && mdir -i piCore-9.0.img1 \
    && mcopy -i piCore-9.0.img1 ::/9.0.gz rootfs.gz \
    && mkdir rootfs \
    && cd rootfs \
    && gzip -dc ../rootfs.gz | cpio -id \
    && rm -f ../rootfs.gz \
    && rm -r lib/modules \
    && cd usr/bin \
    && patch < /tmp/tce-load.patch \
    && cd ../.. \
    && rm -f /tmp/tce-load.patch \
    && chmod u+s ./usr/bin/sudo \
    && tar cf - . | gzip -c > /tmp/rootfs.tar.gz \
    && cd .. \
    && rm -rf rootfs

CMD ["/bin/true"]
