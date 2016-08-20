#!/usr/bin/env bash
set -e

. ./scripts/check_env.sh

pushd protobuf

rm -rf build-host
mkdir -p build-host
pushd build-host

"${CMAKE_HOST[@]}" \
	-Dprotobuf_BUILD_TESTS=OFF \
	-DCMAKE_INSTALL_PREFIX="$INSTALL_DIR_HOST" \
	../cmake

"${MAKE[@]}"
"${MAKE[@]}" install/strip

popd
#rm -rf build-host
