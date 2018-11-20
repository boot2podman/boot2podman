# Remastering TC

This guide assumes you are comfortable with the command line.

In the core there is a gzipped cpio archive. This can then be bundled along with the kernel for the boot method you like, for example an ISO image.

The remaster process can be done from inside TC (with advcomp.tcz loaded, and mkisofs-tools.tcz if you want to create an ISO image), or from any other Linux distribution that has the required tools (cpio, tar, gzip, advdef, mkisofs if making an ISO)

Note: advcomp is optional.  If not installed, skip all the advdef commands.

## Unpacking

First, get the kernel and `core.gz` from the iso:

``` sh
sudo mkdir /mnt/tmp
sudo mount tinycore.iso /mnt/tmp -o loop,ro
cp /mnt/tmp/boot/vmlinuz /mnt/tmp/boot/core.gz /tmp
sudo umount /mnt/tmp
```

If you are going to create an ISO image, instead of copying only two files, copy everything:

``` sh
sudo mkdir /mnt/tmp
sudo mount tinycore.iso /mnt/tmp -o loop,ro
cp -a /mnt/tmp/boot /tmp
mv /tmp/boot/tinycore.gz /tmp
sudo umount /mnt/tmp
```

Then, extract `core.gz` for adding/removing something:

``` sh
mkdir /tmp/extract
cd /tmp/extract
zcat /tmp/core.gz | sudo cpio -i -H newc -d
```

Now, the full filesystem is in `/tmp/extract`. Feel free to add, remove, or edit anything you like.

## Alternative approach to adding extensions. (Overlay using cat)

As per [Forum topic - Overlay using cat](http://forum.tinycorelinux.net/index.php?topic=8437.0) an interesting alternative to unpacking, editing and repacking files is simply to, using the cat command, concatenate multiple gzipped cpio archives together.

You should be aware that this way results in a slightly slower boot, and likely bigger initramfs size.

For example:

``` sh
 cat microcore.gz Xlibs.gz Xprogs.gz Xvesa.gz > my_xcore.gz
```

would add a graphical desktop to microcore less a windows manager and menu bar which are currently extensions: flwm_topside.tcz and wbar.tcz but if converted these extensions could be added as well.

Extension .tcz files can be unpacked using the unsquashfs tool and repacked using the gzip tool in order to make the process of adding ready-built extensions to your custom initramfs file system.

## Packing

For versions 2.x where x >= 2 and later (replace the kernel uname with the right one):

```  sh
sudo depmod -a -b /tmp/extract 2.6.29.1-tinycore
```

If you added shared libraries then execute

``` sh
sudo ldconfig -r /tmp/extract
```

Afterwards, pack it up:

``` sh
cd /tmp/extract
sudo find | sudo cpio -o -H newc | gzip -2 > ../tinycore.gz
cd /tmp
advdef -z4 tinycore.gz
```

It is packed at level 2 to save time. advdef -z4 is equivalent to about -11 on gzip.

You now have a modified `tinycore.gz`. If booting from other than a CD, copy tinycore.gz and the kernel to your boot device.

## Creating an iso

If you would like to create an ISO image:

``` sh
cd /tmp
mv tinycore.gz boot
mkdir newiso
mv boot newiso
mkisofs -l -J -R -V TC-custom -no-emul-boot -boot-load-size 4 \
 -boot-info-table -b boot/isolinux/isolinux.bin \
 -c boot/isolinux/boot.cat -o TC-remastered.iso newiso
rm -rf newiso
```

`Note 1:` the mkisofs command line example above spans three lines, but is actually entered as ONE line

`Note 2:` the -r option should be added to avoid permissions errors if the new iso is being built outside a TinyCore environment

`TC-remastered.iso` can now be burned or started in a virtual machine.

---

Adopted from the Tiny Core Linux wiki:
> [wiki/dynamic_root_filesystem_remastering.txt](http://wiki.tinycorelinux.net/wiki:dynamic_root_filesystem_remastering) · Last modified: 2013/01/04 13:57 by BobBagwill
>
> Except where otherwise noted, content on this wiki is licensed under the following license: [CC Attribution-Share Alike 3.0 Unported](http://creativecommons.org/licenses/by-sa/3.0/)
