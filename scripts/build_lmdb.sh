#!/usr/bin/env bash
set -e

. ./scripts/check_env.sh

pushd lmdb/libraries/liblmdb

git clean -fxd
git reset --hard
git apply "$WD/patches/lmdb/CMakeLists.patch" # FIXME upstream CMakeLists.txt

rm -rf build
mkdir -p build
pushd build

"${CMAKE_NDK[@]}" \
	-DCMAKE_C_FLAGS="-DMDB_DSYNC=O_SYNC -DMDB_USE_ROBUST=0" \
	-DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" \
	..

"${MAKE[@]}"
"${MAKE[@]}" install/strip

popd
#rm -rf build
