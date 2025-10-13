#!/bin/bash

function show_usage() {
  cat << EOF
Usage: install.sh [options]

Install PolyKokkos

Available options:
  -h|--help                         show help
  -C|--directory [directory]        indicate the correct directory to use.
                                    This directory should contain the llvm source
                                    By default, pwd
  --install [directory]             indicate the install path
                                    By default, pwd/install
  -j [N]                            the number of compile threads to use
  --no-clone                        prevent repository cloning
  --llvm-only                       prevent repository cloning and only compile llvm
  --kokkos-only                     prevent repository cloning and only compile kokkos
  --clone-args [args]
  --compile-kokkos-args [args]
  --compile-llvm-args [args]
EOF
}

directory=$(pwd)
compile_threads="20"
install=$directory/install

clone=1
llvm_compile=1
kokkos_compile=1

clone_args=""
compile_kokkos_args=""
compile_llvm_args=""

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
    --no-clone)
      shift
      clone=0
      ;;
    --llvm-only)
      shift
      kokkos_compile=0
      clone=0
      ;;
    --kokkos-only)
      shift
      llvm_compile=0
      clone=0
      ;;
    --clone-args)
      shift
      clone_args="$1"
      shift
      ;;
    --compile-kokkos-args)
      shift
      compile_kokkos_args="$1"
      shift
      ;;
    --compile-llvm-args)
      shift
      compile_llvm_args="$1"
      shift
      ;;
  esac
done

echo "Starting installation..."

kokkos_name=polykokkos
llvm_name=llvm-for-polykokkos

if [ $clone -eq 1 ]; then
  echo "Cloning repositories"
  ./scripts/clone_repository.sh --kokkos-name ${kokkos_name} --llvm-name ${llvm_name} ${clone_args}
fi

if [ $llvm_compile -eq 1 ]; then
  echo "Building llvm"
  ./scripts/compile_llvm.sh --name ${llvm_name} -j ${compile_threads} --install ${install} ${compile_llvm_args}
  export LD_LIBRARY_PATH=${install}/lib/x86_64-unknown-linux-gnu:/usr/local/lib:$LD_LIBRARY_PATH
fi

if [ $kokkos_compile -eq 1 ]; then
  echo "Building kokkos"
  ./scripts/compile_kokkos.sh --name ${kokkos_name} -j ${compile_threads} --install ${install} --clang-path ${install}/bin/clang++ ${compile_kokkos_args}
fi

echo "Installation completed"
