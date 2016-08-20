#!/usr/bin/env bash
set -e

. ./scripts/check_env.sh

pushd protobuf

rm -rf build
mkdir -p build
pushd build

"${CMAKE_NDK[@]}" \
	-Dprotobuf_BUILD_TESTS=OFF \
	-DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" \
	../cmake

"${MAKE[@]}"
"${MAKE[@]}" install/strip

popd
#rm -rf build
