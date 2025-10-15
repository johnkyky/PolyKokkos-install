rm -rf build
mkdir -p build
cmake -S . -B build -DCMAKE_CXX_COMPILER=/root/source/install/bin/clang++ -DCMAKE_BUILD_TYPE=Release
make -C build
