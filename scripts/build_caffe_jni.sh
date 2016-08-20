#!/usr/bin/env bash
set -e

. ./scripts/check_env.sh

pushd caffe_jni

rm -rf build
mkdir -p build
cd build

"${CMAKE_NDK[@]}" \
      -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" \
      ..

"${MAKE[@]}"
"${MAKE[@]}" install/strip

popd
#rm -rf build
