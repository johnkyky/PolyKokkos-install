#!/bin/bash

function show_usage() {
  cat << EOF
Usage: compile_kokkos.sh [options]

Compile kokkos with custom informations

Available options:
  -h|--help                         show help
  -C|--directory [directory]        indicate the correct directory to use.
                                    This directory should contain the kokkos source
                                    By default, pwd
  --name [name]                     indicate the kokkos directory name
                                    Mandatory
  --install [directory]             indicate the install path
  --clang-path [clang++]            the clang++ compiler to use
  -B|--build-type [build type]      the build type to use
  -j [N]                            the number of compile threads to use
EOF
}

echo "Starting kokkos compilation..."

directory=$(pwd)
clang_compiler="clang++"
build_type="Release"
compile_threads="20"
name=""
install=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -C|--directory)
      shift
      directory="$1"
      shift
      ;;
    -h|--help)
      show_usage
      exit 0
      ;;
    --clang-path)
      shift
      clang_compiler="$1"
      shift
      ;;
    -B|--build-type)
      shift
      build_type="$1"
      shift
      ;;
    --name)
      shift
      name="$1"
      shift
      ;;
    --install)
      shift
      install="$1"
      shift
      ;;
    -j)
      shift
      compile_threads="$1"
      shift
      ;;
  esac
done

if [ "$name" == "" ]; then
  show_usage
  exit 1
fi

echo "Cleaning and setting directories"

build=$directory/build_$name
if [ "$install" == "" ]; then
  install=$directory/install
fi
src=$directory/$name

rm -fr $build

mkdir -p $build
mkdir -p $install

echo "Generating CMake build directory"

cmake -S $src \
  -B $build \
  -DCMAKE_INSTALL_PREFIX=$install \
  -DCMAKE_BUILD_TYPE=$build_type \
  -DKokkos_ENABLE_SERIAL=ON \
  -DCMAKE_CXX_COMPILER=$clang_compiler \
  -DKokkos_ENABLE_OPENMP=ON \
  -DKokkos_ENABLE_ATOMICS_BYPASS=OFF \
  -DCMAKE_CXX_STANDARD=20

echo "Building kokkos"

make -j $compile_threads -C $build install

echo "kokkos built"