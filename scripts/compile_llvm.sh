#!/bin/bash

function show_usage() {
  cat << EOF
Usage: compile_llvm.sh [options]

Compile llvm with custom informations

Available options:
  -h|--help                         show help
  -C|--directory [directory]        indicate the correct directory to use.
                                    This directory should contain the llvm source
                                    By default, pwd
  --name [name]                     indicate the llvm directory name
                                    Mandatory
  --install [directory]             indicate the install path
  -B|--build-type [build type]      the build type to use
  -j [N]                            the number of compile threads to use
EOF
}

echo "Starting llvm compilation..."

directory=$(pwd)
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

build=$directory/build_$name
if [ "$install" == "" ]; then
  install=$directory/install
fi
src=$directory/$name/llvm

echo "Cleaning and setting directories"

rm -fr $build

mkdir -p $build
mkdir -p $install

echo "Generating CMake build directory"

cmake -S $src \
  -B $build \
  -DCMAKE_INSTALL_PREFIX=$install \
  -DCMAKE_BUILD_TYPE=$build_type \
  -DCMAKE_C_COMPILER=clang \
  -DCMAKE_CXX_COMPILER=clang++ \
  -DLLVM_INSTALL_UTILS=ON \
  -DLLVM_ENABLE_PROJECTS='lld;clang;openmp;polly' \
  -DBUILD_SHARED_LIBS=True \
  -DLLVM_TARGETS_TO_BUILD=X86
# -DNDEBUG=ON \
# -DLLVM_ENABLE_RTTI=ON \

echo "Building llvm"

make -j $compile_threads -C $build install

echo "llvm built"