# PolyKokkos

Kokkos Polyhedral Model Extension

## Install

```sh
$ ./install.sh
```

The script will clone the custom Kokkos and LLVM repositories, build
and install them.

Help is also available with the `-h` option.

You can indicate the install path with the `--install` option.

## Docker

A Dockerfile is also provided, which can be built with

```sh
$ docker build -f docker/debian12/Dockerfile .
```
