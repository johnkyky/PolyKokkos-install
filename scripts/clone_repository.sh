#!/bin/bash

function show_usage() {
  cat << EOF
Usage: clone_repository.sh [options]

Clone custom kokkos and llvm repositories

Available options:
  -h|--help                         show help
  -C|--directory [directory]        indicate the directory to clone to.
                                    By default, pwd
  --kokkos-branch [branch]          specify if needed the kokkos branch
                                    to clone
  --llvm-branch [branch]            specify if needed the llvm branch
                                    to clone
  --kokkos-name [name]              indicate the custom kokkos clone name
                                    Mandatory
  --llvm-name [name]                indicate the custom llvm clone name
                                    Mandatory
EOF
}

echo "Starting repository cloning..."

directory=$(pwd)
kokkos_branch="develop"
kokkos_name=""
llvm_branch="main"
llvm_name=""

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
    --kokkos-branch)
      shift
      kokkos_branch="$1"
      shift
      ;;
    --llvm-branch)
      shift
      llvm_branch="$1"
      shift
      ;;
    --kokkos-name)
      shift
      kokkos_name="$1"
      shift
      ;;
    --llvm-name)
      shift
      llvm_name="$1"
      shift
      ;;
  esac
done

if [ "$kokkos_name" == "" ] || [ "$llvm_name" == "" ]; then
  show_usage
  exit 1
fi

kokkos_directory=$directory/$kokkos_name
llvm_directory=$directory/$llvm_name

echo "Cloning the kokkos repository"
git clone --depth 1 -b $kokkos_branch https://github.com/johnkyky/Polykokkos.git $kokkos_directory

echo "Cloning the llvm repository"
git clone --depth 1 -b $llvm_branch https://github.com/johnkyky/llvm-project-for-PolyKokkos.git $llvm_directory

echo "Repositories cloned"