FROM tinycore-compiletc:10.0-x86_64

RUN cd \
    && tce-load -wic perl5 ncursesw-dev bash coreutils glibc_apps \
    && wget http://www.tinycorelinux.net/10.x/x86_64/release/src/toolchain/glibc-2.28.tar.xz \
    && wget http://www.tinycorelinux.net/10.x/x86_64/release/src/toolchain/glibc-2.28-fhs-1.patch \
    && tar -xf glibc-2.28.tar.xz \
    && cd glibc-2.28 \
    && patch -Np1 -i ../glibc-2.28-fhs-1.patch \
    && sudo rm -f /usr/include/limits.h \
    && mkdir build \
    && cd build \
    && echo "CFLAGS += -mtune=generic -Os -pipe" > configparms \
    && CC="gcc -isystem /usr/lib/gcc/x86_64-pc-linux-gnu/8.2.0/include -isystem /usr/include" \
../configure --prefix=/usr --libexecdir=/usr/lib/glibc --enable-kernel=3.2 \
--enable-stack-protector=strong libc_cv_slibdir=/lib --disable-werror \
    && find . -name config.make -type f -exec sed -i 's/-g -O2//g' {} \; \
    && find . -name config.status -type f -exec sed -i 's/-g -O2//g' {} \; \
    && make \
    && sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile \
    && make install install_root=/tmp/pkg \
    && mkdir -p /tmp/pkg/etc \
    && cp ../nscd/nscd.conf /tmp/pkg/etc/nscd.conf \
    && mkdir -p /tmp/pkg/var/cache/nscd \
    && make localedata/install-locales install_root=/tmp/pkg \
    && sed -i 's@lib64/ld-linux-x86-64.so.2@lib/ld-linux-x86-64.so.2@' /tmp/pkg/usr/bin/ldd \
    && cd ../.. \
    && tar cf - -C /tmp/pkg . | gzip -c > /tmp/glibc.tar.gz \
    && rm -rf glibc-2.28

CMD ["/bin/true"]
