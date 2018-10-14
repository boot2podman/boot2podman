# Creating a Custom Kernel

Some users of TC will for various reasons need to use their own custom built kernel together with the rest of TC. As an example my main use of TC is in music production and in that domain a lot of the applications are performing optimal only with the support of a kernel that provides real-time characteristics. Since the standard TC kernel does not provide these characteristics I need to build a kernel that does. Luckily, there is a set of patches available, that once applied (and built) will provide you with a suitable kernel for these music production tasks. I do not intend to go into the details of "my" specific kernel but rather provide some info on building a custom kernel in general.

In general the standard TC kernel is a fairly standard Linux kernel, meaning that is has just a few set of patches applied. In general I think that TC will work with a kernel without patches, i.e. a "pure" standard Linux kernel. However some of the patches applied in the standard TC kernel are required for some TC specific functions to work, so if you depend on such functions you need to make sure that you apply the corresponding patch(es) before building your own kernel.

Standard Linux kernel sources are available at

https://www.kernel.org/

- https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.4.10.tar.xz

The TC patches and other related files for the standard TC kernel are available at

http://www.tinycorelinux.net/9.x/x86_64/release/src/kernel/

- http://www.tinycorelinux.net/9.x/x86_64/release/src/kernel/410-patches/
- http://www.tinycorelinux.net/9.x/x86_64/release/src/kernel/config-4.14.10-tinycore64

In the future, substitute a newer version number for 9.x in the url.

The process to create a custom kernel could in short be described as:

- Get the sources for the version of the standard Linux kernel that you are going to base your kernel on
- Get the patches you intend to apply - both TC kernel patches and possibly others (in my case the RT-patches)
- Unpack the linux sources and cd into the top level directory of the source package
- Apply the patches using (in most cases) `patch -p1 < patchfile` for each patch file
- Move the kernel config file from the standard TC kernel into the same directory and rename it to ".config"
- Do `make oldconfig` and answer all questions, in case you have no clue on the answer just provide the default ones (i.e. just hit Return)
- Do `make menuconfig` and make any changes you need to the configuration
- Do `make bzImage` to build the kernel itself
- Do `make modules` to build the loadable modules
- Do `make INSTALL_MOD_PATH=/path modules_install firmware_install` where /path is a path to a directory where you expect to find the modules.

At this point you will find the kernel file as "arch/x86/boot/bzImage" (relative to the directory from where you issues all the make commands).
Further you will find all loadable modules and firmware files under "/path/lib/modules/kernel_version" and "/path/lib/firmware"

The bzImage file need to be moved to a location where your boot loader can access it and the boot loader needs also to be configured to boot using the new kernel.

When it comes to the modules and firmware files, you basically have two options, either let them be part of your initrd (a file named "tinycore.gz" in TC) or let them be part of extension files (*.tcem). In most cases it is probably best to have some of them built into the initrd and some available as loadable extensions. If you are unsure, build all of your files into the initrd. This will give you a tinycore.gz which is significantly larger than the one provided by standard TC, but in most cases you could probably live with that until you have the time to sort out the details of what modules should be put where. When you build your initrd you need to place the modules found under "/path/lib/modules" under "lib/modules" relative to the root of the initrd. Similarly the files under "/path/lib/firmware" should be put under "lib/firmware" relative to the initrd root.

IMPORTANT. If you are using a custom kernel you should never use any *.tcem files from standard TC. You could probably load them and they will likely not produce any harm, but taking up memory space, but they will not provide the function you expected. As you can notice above the modules are placed under a directory that contains the current kernel version and the modprobe program will only load modules from the directory that matches the version of the current kernel.

The standard TC initrd and the standard *.tcem packages are structured as follows to allow dynamic loading of module extensions:

   The module files in the *.tcem, when installed, are found as

          /usr/local/lib/modules/......

   In order for them to be visible under

          /lib/modules/...

   the initrd contains a link called "lib/modules/<<kernel_version>>/kernel.tclocal" which points to "/usr/local/lib/modules/<<kernel_version>>/kernel

As you probably could imagine, the standard initrd has no knowledge of your kernel version, so you have to create this link in your initrd explicitly.

Remember that the standard TC *.tcem files could only be used with the standard TC kernel so this "contract" between the TC *.tcem file structure and the link in initrd is not something you need to follow. You could make up your own way to solve this or use the same method, it is totally up to you.

---

Adopted from the Tiny Core Linux wiki:
> [wiki/custom_kernel.txt](http://wiki.tinycorelinux.net/wiki:custom_kernel) · Last modified: 2013/03/04 17:46 by aus9
>
> Except where otherwise noted, content on this wiki is licensed under the following license: [CC Attribution-Share Alike 3.0 Unported](http://creativecommons.org/licenses/by-sa/3.0/)