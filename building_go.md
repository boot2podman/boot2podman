# go

Go is an open source programming language that makes it easy to build simple, reliable, and efficient software.

https://golang.org/

## Installation

https://golang.org/doc/install/source

* **go-bootstrap** (temporary version, written in C)
* **go** (final version, written in go - needs bootstrap)

Some secret undocumented cleanup tricks, can be found inside the go source code of the `release` command:

https://godoc.org/golang.org/x/build/cmd/release

## Prerequisites

Compile time:

``` sh
tce-load -wi compiletc
tce-load -wi openssl
tce-load -wi bash
tce-load -wi squashfs-tools
```

## Bootstrap

``` sh
wget https://dl.google.com/go/go1.4-bootstrap-20171003.tar.gz

tar xzf go1.4-bootstrap-20171003.tar.gz
cd go/src
export GOROOT_FINAL=/usr/local/go-bootstrap
CGO_ENABLED=0 ./make.bash
cd -
mkdir -p /tmp/go-bootstrap/usr/local
mv go /tmp/go-bootstrap/usr/local/go-bootstrap
mksquashfs /tmp/go-bootstrap go-bootstrap.tcz
```

Load and configure:

``` sh
$ tce-load -i go-bootstrap.tcz
$ export GOROOT=/usr/local/go-bootstrap
$ export PATH=$GOROOT/bin:$PATH
$ go version
go version go1.4-bootstrap-20170531 linux/amd64
```

## Final

``` sh
wget https://dl.google.com/go/go1.10.4.src.tar.gz
wget https://raw.githubusercontent.com/boot2podman/boot2podman/master/go-1.10.4-ca-certificates.patch

tar xzf go1.10.4.src.tar.gz
cd go/src
patch -Np2 -i ../../go-1.10.4-ca-certificates.patch
export GOROOT_FINAL=/usr/local/go
./make.bash
cd -
rm -rf go/pkg/bootstrap
rm -rf go/pkg/tool/linux_amd64/api
rm -rf go/pkg/linux_amd64/cmd
rm -rf go/pkg/obj
mkdir -p /tmp/go/usr/local
mv go /tmp/go/usr/local/go
mksquashfs /tmp/go go.tcz
```

Load and configure:

``` console
$ tce-load -i go.tcz
$ export GOROOT=/usr/local/go
$ export PATH=$GOROOT/bin:$PATH
$ go version
go version go1.10.4 linux/amd64
```

## Pre-requisites

Runtime:

``` sh
tce-load -wi git
```

There is yet no support for `/usr/local/etc/ssl/certs`:

``` sh
export SSL_CERT_FILE=/usr/local/etc/ssl/certs/ca-certificates.crt
export SSL_CERT_DIR=/usr/local/share/ca-certificates
```

Support for TinyCore ssl has been patched into go, above.

Issue tracker: https://github.com/golang/go/issues/28199

## Environment Variables

[How To Write Go Code](https://golang.org/doc/code.html)

``` sh
export GOROOT=/usr/local/go
export PATH=$GOROOT/bin:$PATH
export GOPATH=~/go
export PATH=$GOPATH/bin:$PATH
```

## Install godoc

Included in the binary downloads, but not with the source ?

``` sh
go get golang.org/x/tools/cmd/godoc
```

Available online, as: https://godoc.org/-/go

## Install tour

Install the go tour, if wanted. It was still included, in 1.10.

``` sh
go get golang.org/x/tour
```

Available online, as: https://tour.golang.org/

## Hello World

``` console
$ cat >hello.go <<EOF
package main

import "fmt"

func main() {
	fmt.Printf("hello, world\n")
}
EOF
$ go run hello.go
hello, world
```
