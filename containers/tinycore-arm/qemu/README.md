# tinycore-qemu

Preloading qemu binaries needs a newer kernel (4.8.0+), to work properly:

`standard_init_linux.go:211: exec user process caused "no such file or directory"`

But it is possible to bundle qemu-user-static, to run older versions too:

`/usr/bin/qemu-arm-static`

Thus you can use `tinycore-qemu:9.0-armv6` instead of `tinycore:9.0-armv6`
as a base image, if you need to run on older kernel versions (e.g. 4.4.0)

Note: If you have problems running binaries, or running "sudo" binaries
      make sure that qemu-arm-static has been registered, with 'C' flag
      You can use the bundled register.sh script to do this, if you want.
      Preloading binaries requires Linux 4.8+, so we avoid the 'F' flag
