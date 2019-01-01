# tinycore-mini

This is a minimal container, consisting only of the standard C library and linker:

``` txt
/lib/libc.so.6
/lib/ld-linux-x86-64.so.2
```

Unlike the normal 8M container, there's **no** shell included (not even `/bin/sh`)

``` txt
starting container process caused "exec: \"sh\": executable file not found in $PATH"
```

Allows for really small (10k) containers, when based on the 2M parent image:

``` txt
ID             CREATED             CREATED BY                               SIZE      COMMENT
62a66b04e762   25 minutes ago      /bin/sh -c #(nop) CMD ["/bin/hello"]     1.024kB   
a92252aa9346   25 minutes ago      /bin/sh -c #(nop) ADD hello /bin/hello   10.24kB   
a9e530ddf4e1   About an hour ago   /bin/sh -c #(nop) ADD minimal.tar.gz /   1.73MB    
```

Static linking (rather than dynamic) also works, but then each binary is bigger

``` txt
8.0K	hello
616.0K	hello-static
```

## License

minimal.tar.gz is under [GPLv2](http://www.gnu.org/licenses/gpl-2.0.html).
The other build scripts are under [MIT](LICENSE).
