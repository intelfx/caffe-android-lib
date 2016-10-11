#!/usr/bin/env bash
set -e

function check_env() {
	declare -n VAR="$1"
	local MSG="${2:-"\$$1 is not set"}"

	if [[ -z ${VAR:+x} ]]; then
		echo "$MSG"
		exit 1
	fi
}

check_env ANDROID_NDK '$ANDROID_NDK is not set nor given as first argument'
check_env WD
check_env ANDROID_ABI
check_env N_JOBS

check_env OS
check_env BIT
check_env CROSS_SUFFIX
check_env SYSROOT

#
# Avoid shared runtime as much as possible,
# pending resolution of https://github.com/crystax/android-platform-ndk/issues/13
#
# FIXME get rid of this ASAP
#

CMAKE_NDK=(
	${CMAKE:-cmake}
	-DCMAKE_TOOLCHAIN_FILE="$ANDROID_NDK/cmake/toolchain.cmake"
	-DCMAKE_BUILD_TYPE=Release
	-DANDROID_NDK="$ANDROID_NDK"
	-DANDROID_ABI="$ANDROID_ABI"
	-DANDROID_NATIVE_API_LEVEL=21
	-DANDROID_TOOLCHAIN_VERSION="$ANDROID_TOOLCHAIN_VERSION"
	-DANDROID_STL=gnustl_static
	-DBoost_USE_STATIC_LIBS=ON
)

CMAKE_HOST=(
	${CMAKE:-cmake}
	-DCMAKE_BUILD_TYPE=Release
)

MAKE=(
	${MAKE:-make}
	-j${N_JOBS}
)

