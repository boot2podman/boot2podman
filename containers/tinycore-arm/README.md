Tiny Core Linux ARM Container Image Builder
===========================================

Dockerfile and helper scripts for building a very small CLI system image based
on Tiny Core Linux developed at [The Core Project](http://tinycorelinux.net).
It builds Core 9.0 armv6 image by using following packages which were
converted those archive type from The Core Project packages (piCore).

- rootfs.tar.gz: contains base system binaries and a file system layout
- squashfs-tools.tar.gz: contains a squashfs builder and expander
- qemu-arm-static: allows running the container image on a older system

Those original packages are found under http://tinycorelinux.net/9.x/armv6

Note: If you have problems running binaries, or running "sudo" binaries
      make sure that qemu-arm-static has been registered, with 'C' flag
      You can use the bundled register.sh script to do this, if you want.
      Preloading binaries requires Linux 4.8+, so we avoid the 'F' flag

## How to build the image

Just run

```bash
make
```

To clean up the directory, run

```bash
make clean
```

## License

rootfs.tar.gz, squashfs-tools.tar.gz and tce-load.patch are under
[GPLv2](http://www.gnu.org/licenses/gpl-2.0.html). The other build scripts are
under [MIT](LICENSE).
