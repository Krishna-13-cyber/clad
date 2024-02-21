#!/usr/bin/env bash

uname -a

echo "Making build directory"
mkdir build

echo "Going into build directory"
cd build

echo "Generating cmake files"
cmake -DLLVM_DIR=/usr/lib/llvm-11/build/ -DCMAKE_BUILD_TYPE=DEBUG -DLLVM_EXTERNAL_LIT="$(which lit)" ../

echo "Running make"
make -j 8