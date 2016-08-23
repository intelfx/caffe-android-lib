#!/usr/bin/env bash
set -e

. ./scripts/check_env.sh

pushd OpenCL

rm -rf build
mkdir -p build
pushd build

"${CMAKE_NDK[@]}" \
      -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" \
      ..

"${MAKE[@]}"
"${MAKE[@]}" install/strip

popd
rm -rf build
