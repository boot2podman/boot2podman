# containers

The standard way of running is using the ISO on a physical server or virtual machine:

``` sh
wget http://www.tinycorelinux.net/10.x/x86_64/release/CorePure64-10.0.iso
qemu-system-x86_64 -cdrom CorePure64-10.0.iso
```

This will start the normal "isolinux" boot process, including starting another kernel.

       ( '>')
      /) TC (\   Core is distributed with ABSOLUTELY NO WARRANTY.
     (/-_--_-\)           www.tinycorelinux.net

    Press <Enter> to begin or F2, F3, or F4 to view boot options.
    boot:

And that works fine, the virtualization can be hardware-accelerated with KVM (or similar)

``` console
$ kvm-ok
INFO: /dev/kvm exists
KVM acceleration can be used
$ qemu-system-x86_64 -enable-kvm -cdrom CorePure64-10.0.iso
```

The number of processors and memory can be increased (default is 1 CPU and 128 MB):

``` sh
qemu-system-x86_64 -enable-kvm -smp 4 -m 512 CorePure64-10.0.iso
```

But when building packages and cross-compiling, it can be useful to run in a container...

## Container Images

The [Tiny Core Linux](http://tinycorelinux.net) distribution is also available as a standard OCI container image:

``` console
$ sudo podman run -it boot2podman-docker-tinycore.bintray.io/tinycore:10.0-x86_64
/ $ grep -i pretty /etc/os-release
PRETTY_NAME="TinyCoreLinux 10.0"
```

For older kernels (< 4.8) you might want to run a variant with a more compatible glibc:

``` console
$ sudo podman run -it boot2podman-docker-tinycore.bintray.io/tinycore:10.0-x86_64
FATAL: kernel too old
$ sudo podman run -it boot2podman-docker-tinycore.bintray.io/tinycore-glibc:10.0-x86_64
/ $
```

## cc

A container build image is available, that feature tinycore with `compiletc` package:

``` console
$ sudo podman run -it boot2podman-docker-tinycore.bintray.io/tinycore-compiletc:10.0-x86_64
/ $ cc --version
cc (GCC) 8.2.0
```

This includes a basic set of packages, such as `gcc` and `make`, and all their dependencies.

Additional development `.tcz` packages can be installed, using the `tce-load` command.

An overview of the available packages is at: <http://www.tinycorelinux.net/10.x/x86_64/tcz/>

``` sh
tce-load -wic bash.tcz
```

## go

Another add-on image to it is also available, that includes the `go` compiler environment:

``` console
$ sudo podman run -it boot2podman-docker-tinycore.bintray.io/tinycore-go:1.12
/ $ go version
go version go1.12 linux/amd64
```

This sets up the needed variables (such as $PATH/$GOPATH), and includes `git` command:

``` console
/ $ go get github.com/golang/example/hello
/ $ hello
Hello, Go examples!
```
