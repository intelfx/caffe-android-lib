#!/usr/bin/env bash
set -e

. ./scripts/check_env.sh

pushd viennacl

rm -rf build
mkdir -p build
pushd build

"${CMAKE_NDK[@]}" \
	-DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" \
	-DBUILD_EXAMPLES=OFF \
	-DBUILD_TESTING=OFF \
	-DENABLE_OPENMP=ON \
	..

"${MAKE[@]}"
"${MAKE[@]}" install/strip

popd
#rm -rf build
