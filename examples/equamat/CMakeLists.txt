cmake_minimum_required(VERSION 3.25)

project(main)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(
  Kokkos REQUIRED PATHS
  /root/source/install/lib/cmake/Kokkos
)


add_compile_options(
  "SHELL:-mllvm -polly"
  "SHELL:-mllvm -polly-manual-scop-detection"
  "SHELL:-mllvm -polly-parallel"
  "SHELL:-mllvm -polly-process-unprofitable"
  "SHELL:-mllvm -polly-stmt-granularity=store"
  "SHELL:-mllvm -polly-dot"
  "SHELL:-mllvm -polly-export"
  # "SHELL:-mllvm -polly-parallel-force"
  # "SHELL:-mllvm -polly-optimizer=pluto"
  # "SHELL:-mllvm -polly-opt-outer-coincidence=yes"
  # "SHELL:-mllvm -polly-loopfusion-greedy=1"
)

add_executable(main main.cpp)
target_link_libraries(main Kokkos::kokkos)