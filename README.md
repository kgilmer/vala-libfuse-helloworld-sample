# Vala libfuse helloworld sample

This is a simplified direct translation of the "hello world" [libfuse example in C](https://github.com/libfuse/libfuse/blob/master/example/hello.c).  It does not allow for the filename nor contents to be provided on the command-line at invocation time, otherwise it should be equivelent.  

# Build

## Prerequisites

* Meson
* Ninja
* libfuse
* valac

## Build

```bash
$ meson build
$ cd build
$ ninja
```
## Run

```bash
$ sudo mkdir /tmp/fuse-test
$ sudo chown <username> /mnt/fuse-test
$ ./src/fuse-example /mnt/fuse-test
```

## Test

```bash
$ ls /mnt/fuse-test/
hello
$ cat /mnt/fuse-test/hello
Hello World!
```

# Notes

Special thanks to Guillaume Poirier-Morency for help with setting C symbols via Meson.