#!/usr/bin/env bash
set -e

. ./scripts/check_env.sh

case "$ANDROID_ABI" in
"armeabi-v7a-hard"*)
	TARGET=ARMV7
	BINARY=32
	;;

"arm64-v8a")
	TARGET=ARMV8
	BINARY=64
	;;

"armeabi")
	TARGET=ARMV5
	BINARY=32
	NO_LAPACK=1
	;;

"x86")
	TARGET=ATOM
	BINARY=32
	NO_LAPACK=1
	;;

"x86_64")
	TARGET=ATOM
	BINARY=64
	NO_LAPACK=1
	;;

*)
	echo "Unsupported ABI for OpenBLAS: $ANDROID_ABI"
	exit 1
	;;
esac

pushd OpenBLAS

git clean -fxd

# OpenBLAS' buildsystem only builds a static library, so it is usable as-is with CrystaX NDK.
# OpenBLAS can generate a CMake config from its Makefiles, but it is broken.
# FIXME ideally/eventually, we should use/move to OpenBLAS' CMake buildsystem (fixing it in the process).

"${MAKE[@]}" \
     CC="'${CROSS_SUFFIX}gcc' --sysroot='$SYSROOT'" \
     CROSS_SUFFIX="$CROSS_SUFFIX" \
     HOSTCC=gcc USE_THREAD=1 NUM_THREADS=8 USE_OPENMP=1 \
     NO_LAPACK="${NO_LAPACK:-1}" TARGET="$TARGET" BINARY="$BINARY" \
     PREFIX="$INSTALL_DIR" \
     all install

#git clean -fxd
