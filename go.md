# go

Go is an open source programming language that makes it easy to build simple, reliable, and efficient software.

https://golang.org/doc/install/source

* **go-bootstrap** (temporary version, written in C)
* **go** (final version, written in go - needs bootstrap)

## Prerequisites

Compile time:

``` sh
tce-load -i gcc.tcz
tce-load -i bash.tcz
tce-load -i squashfs-tools.tcz
```

## Bootstrap

https://dl.google.com/go/go1.4-bootstrap-20171003.tar.gz

``` sh
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

https://dl.google.com/go/go1.10.4.src.tar.gz

``` sh
tar xzf go1.10.4.src.tar.gz
cd go/src
export GOROOT_FINAL=/usr/local/go
./make.bash
cd -
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
tce-load -i git.tcz
tce-load -i ca-certificates.tcz
```

There is yet no support for `/usr/local/etc/ssl/certs`:

``` sh
# TODO: patch this into the source code
sudo ln -s /usr/local/etc/ssl /etc/ssl
```

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

Included in the binary downloads, but not in the source ?

``` sh
go get -u golang.org/x/tools/cmd/godoc
```

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