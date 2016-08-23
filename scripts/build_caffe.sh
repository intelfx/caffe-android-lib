#!/usr/bin/env bash
set -e

. ./scripts/check_env.sh

OPENCV_DIR="$INSTALL_DIR/sdk/native/jni"
BLAS=open

pushd caffe

rm -rf build
mkdir -p build
cd build

"${CMAKE_NDK[@]}" \
      -DBUILD_python=OFF \
      -DBUILD_docs=OFF \
      -DCPU_ONLY=ON \
      -DUSE_LMDB=ON \
      -DUSE_LEVELDB=OFF \
      -DUSE_HDF5=OFF \
      -DUSE_OPENMP=ON \
      -DBUILD_SHARED_LIBS=OFF \
      -DBLAS="$BLAS" \
      -DOpenCV_DIR="$OPENCV_DIR" \
      -DPROTOBUF_PROTOC_EXECUTABLE="$(which protoc)" \
      -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" \
      ..

"${MAKE[@]}"
"${MAKE[@]}" install/strip

popd
#rm -rf build
