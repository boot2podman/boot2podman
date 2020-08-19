FROM tinycore-compiletc:11.0-x86_64

RUN cd \
    && tce-load -wic perl5 python3.6 \
    && wget http://www.tinycorelinux.net/11.x/x86_64/release/src/toolchain/glibc-2.30.tar.xz \
    && wget http://www.tinycorelinux.net/11.x/x86_64/release/src/toolchain/glibc-2.30-fhs-1.patch \
    && wget http://www.tinycorelinux.net/11.x/x86_64/release/src/toolchain/glibc-uclibc-compat-ld-cache.patch \
    && tar -xf glibc-2.30.tar.xz \
    && cd glibc-2.30 \
    && patch -Np1 -i ../glibc-2.30-fhs-1.patch \
    && patch -Np1 -i ../glibc-uclibc-compat-ld-cache.patch \
    && sed -i '/asm.socket.h/a# include <linux/sockios.h>' sysdeps/unix/sysv/linux/bits/socket.h \
    && mkdir build \
    && cd build \
    && CFLAGS="-mtune=generic -Os -pipe" \
../configure --prefix=/usr --disable-werror --libexecdir=/usr/lib/glibc --enable-kernel=3.2 \
--enable-stack-protector=strong --with-headers=/usr/include libc_cv_slibdir=/lib --enable-obsolete-rpc \
    && find . -name config.make -type f -exec sed -i 's/-g -O2//g' {} \; \
    && find . -name config.status -type f -exec sed -i 's/-g -O2//g' {} \; \
    && make \
    && sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile \
    && make install install_root=/tmp/pkg \
    && cd ../.. \
    && tar cf - -C /tmp/pkg . | gzip -c > /tmp/glibc.tar.gz \
    && rm -rf glibc-2.30

CMD ["/bin/true"]
