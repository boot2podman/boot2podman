#!/bin/sh

# Sadly, qemu-arm is not stable enough to build this package
# (it gets segmentation faults during compiling and linking)

# To build on a Raspberry Pi, you need to add a swapfile too
# (and make sure to build on second partition, not in tmpfs)

export GOOS=linux
export GOARCH=arm

sh -x < compile_go 2>&1 | tee compile.log
sh -x < package_go 2>&1 | tee package.log
