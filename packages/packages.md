# packages

The base of Tiny Core Linux (TCL) is, as the name implies, kept small.

Instead, extra software is loaded through the use of TCE extensions.

## tce-load

Command `tce-load` can be used to load packages, see also `tce-ab`.

``` console
$ tce-load -h
Usage: tce-load [ -i -w -wi -wo -wil -ic -wic -wicl]{s} extensions
  -i   Loads local extension
  -w   Download extension only
  -wi  Download and install extension
  -wo  Download and create an ondemand item
  Adding -c to any -i option will force a one time copy to file system
  Adding -l to any -i option indicates load only - do not update onboot or ondemand
  Adding -s to any option will suppress OK message used by apps GUI
...
```

``` console
$ tce-ab
tce-ab - Tiny Core Extension: Application Browser

S)earch P)rovides K)eywords or Q)uit:
```

Both programs are shell scripts, so fairly simple and understandable.

## TCE directory

Besides `boot`, the other directory on a Tiny Core Linux disk is `tce`.

Applications are stored locally in a "tce" directory on a persistent store.

Typical contents are "onboot.lst", a list of extensions to load at boot.

And an "optional" directory, that contains TCZ extensions / packages.

## TCZ packages

The TCZ packages, with a `.tcz` suffix, are gzip-compressed squashfs images.

> If one had to put it in a single sentence, TCZ could be described as
> "a loop-mounted squashfs 4.x archive, with specified parameters,
> usually symlinked into the main file system".

They are created from a directory with the contents, using `mksquashfs` tool:.

``` sh
mksquashfs /tmp/myextension myextension.tcz
```

Note: on other distributions, the parameters `-b 4k -no-xattrs` are needed.

They are normally mounted, but can be unpacked with the `unsquashfs` tool:

``` sh
unsquashfs myextension.tcz
```

This will create a new `squashfs-root` directory, with the package contents.

## Meta-data files

Alongside a typical extension there are a set of meta-data files.

> Unlike the popular deb and rpm formats, the meta-data is not kept inside the
> archive itself. This allows meta-data updates without changing the main
> archive, which may be several hundred megabytes large.

The accompanying files are:

* `.md5.txt`: checksum (see: `md5sum -c`)
* `.dep`: direct dependencies
* `.info`: size, license, author, updates, and usage information
* `.list`: file list
* `.tree`: recursive list of dependencies
* `.zsync`: used for delta updates

## References

* "Into the Core - A look at Tiny Core Linux"
  <http://www.tinycorelinux.net/book.html>

* "Squashfs is a compressed read-only filesystem"
  <http://squashfs.sourceforge.net/>
