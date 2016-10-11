#!/usr/bin/env bash
set -e

#
# Determine working directory
#
WD="$(which "$0")"
WD="$(realpath -qe "$WD")"
WD="$(dirname "$WD")"
export WD
cd "$WD"

#
# Determine install prefix
#
export INSTALL_DIR="$WD/prefix"
export INSTALL_DIR_HOST="$WD/prefix-host"

#
# Determine common build variables
#
export ANDROID_ABI="${ANDROID_ABI:-"armeabi-v7a-hard with NEON"}"
export N_JOBS=${N_JOBS:-$(grep '^processor' /proc/cpuinfo | wc -l)}
export ANDROID_TOOLCHAIN_VERSION=gcc-5

if [[ ${1+x} ]]; then
	export ANDROID_NDK="$1"
fi

if [[ ${2+x} ]]; then
	export BUILD_ONLY="$2"
fi

#
# Determine build configuration:
#
case "$(uname)" in
Darwin)                 OS=darwin ;;
Linux*)                 OS=linux ;;
MINGW32_NT*|CYGWIN_NT*) OS=windows ;;
*)                      echo "Unknown OS"; exit 1 ;;
esac

export OS

case "$(uname -m)" in
x86_64)                 BIT=x86_64 ;;
*)                      BIT=x86 ;;
esac

export BIT

case "$ANDROID_ABI" in
"armeabi"*)
	TOOLCHAIN_NAME=arm-linux-androideabi-5
	TOOLCHAIN_TUPLE=arm-linux-androideabi
	PLATFORM_NAME=arch-arm
	;;

"arm64-v8a")
	TOOLCHAIN_NAME=aarch64-linux-androideabi-5
	TOOLCHAIN_TUPLE=aarch64-linux-androideabi
	PLATFORM_NAME=arch-arm64
	;;

"x86")
	TOOLCHAIN_NAME=x86-5
	TOOLCHAIN_TUPLE=i686-linux-android
	PLATFORM_NAME=arch-x86
	;;

"x86_64")
	TOOLCHAIN_NAME=x86_64-5
	TOOLCHAIN_TUPLE=x86_64-linux-android
	PLATFORM_NAME=arch-x86_64
	;;

*)
	echo "Unsupported ABI: $ANDROID_ABI"
	exit 1
	;;
esac

export CROSS_SUFFIX="$ANDROID_NDK/toolchains/$TOOLCHAIN_NAME/prebuilt/$OS-$BIT/bin/$TOOLCHAIN_TUPLE-"
export SYSROOT="$ANDROID_NDK/platforms/android-21/$PLATFORM_NAME"

#
# Verify environment (also defines CMAKE_NDK and MAKE arrays because we cannot pass them via environment)
#
. ./scripts/check_env.sh

#
# Recreate the prefix
#
#rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR"

#rm -rf "$INSTALL_DIR_HOST"
mkdir -p "$INSTALL_DIR_HOST/bin"
export PATH="$INSTALL_DIR_HOST/bin:$PATH"

#
# Determine what do we want to build
#

function build_if() {
	local tag="$1" cmd="${@:2}" do_build

	# default to build if there are no positive elements in $BUILD_ONLY
	if [[ ":${BUILD_ONLY}:" =~ :[^-:][^:]*: ]]; then
		if [[ ":${BUILD_ONLY}:" == *:${tag}:* ]]; then
			echo ":: Compiling '$tag' per positive selection"
			do_build=1
		else
			echo ":: Skipping '$tag'"
			do_build=0
		fi
	else
		if [[ ":${BUILD_ONLY}:" == *:-${tag}:* ]]; then
			echo ":: Not compiling '$tag' per negative selection"
			do_build=0
		else
			echo ":: Compiling '$tag'"
			do_build=1
		fi
	fi

	if (( do_build )); then
		"${cmd[@]}"
	fi
}

build_if blas      ./scripts/build_openblas.sh
build_if opencl    ./scripts/build_opencl.sh
build_if gflags    ./scripts/build_gflags.sh
build_if glog      ./scripts/build_glog.sh
build_if lmdb      ./scripts/build_lmdb.sh
build_if opencv    ./scripts/build_opencv.sh
build_if protobuf  ./scripts/build_protobuf_host.sh
build_if protobuf  ./scripts/build_protobuf.sh

build_if viennacl  ./scripts/build_viennacl.sh
build_if clblast   ./scripts/build_clblast.sh

build_if caffe     ./scripts/build_caffe.sh
build_if caffe_jni ./scripts/build_caffe_jni.sh
