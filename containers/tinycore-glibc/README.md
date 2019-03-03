# tinycore-glibc

The new version of tinycore requires a newer kernel (4.8.17+) to run:

`FATAL: kernel too old`

But it is possible to replace the glibc, to run on older versions too:

`--enable-kernel=3.2`

Thus you can use `tinycore-glibc:10-x86_64` instead of `tinycore:10-x86_64`
as a base image, if you need to run on older kernel versions (e.g. 4.4.0)

Not all files from the `glibc` package are included in `rootfs64.tar.gz`,
so only add/replace those files that are actually part of the original...
