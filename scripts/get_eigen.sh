#!/usr/bin/env bash
set -e

. ./scripts/check_env.sh

EIGEN_VER1=3
EIGEN_VER2=2
EIGEN_VER3=9

EIGEN_DOWNLOAD_LINK="http://bitbucket.org/eigen/eigen/get/${EIGEN_VER1}.${EIGEN_VER2}.${EIGEN_VER3}.tar.bz2"
EIGEN_TAR="eigen_${EIGEN_VER1}.${EIGEN_VER2}.${EIGEN_VER3}.tar.bz2"

mkdir -p eigen
pushd eigen

if [[ ! -e "$EIGEN_TAR" ]]; then
	wget -O "$EIGEN_TAR" "$EIGEN_DOWNLOAD_LINK"
fi

rm -rf eigen-eigen-*
tar -xaf "$EIGEN_TAR"

rm -rf build
mkdir -p build
pushd build

"${CMAKE_NDK[@]}" \
	-DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" \
	../eigen-eigen-*
"${MAKE[@]}" install

popd
rm -rf build
