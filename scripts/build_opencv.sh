#!/usr/bin/env bash
set -e

. ./scripts/check_env.sh

if [[ "$ANDROID_ABI" == "armeabi" ]]; then
	CMAKE_NDK+=( "-DANDROID_NATIVE_API_LEVEL=19" )
fi

pushd opencv

rm -rf build
mkdir -p build
pushd build

# OpenCV has a non-standard installation directory tree hierarchy...
# (we still use the shared install prefix to allow OpenCV to find its dependencies
#  without excessive manual guidance)
"${CMAKE_NDK[@]}" \
	-D WITH_CUDA=OFF \
	-D WITH_MATLAB=OFF \
	-D WITH_OPENMP=ON \
	-D BUILD_ANDROID_EXAMPLES=OFF \
	-D BUILD_DOCS=OFF \
	-D BUILD_PERF_TESTS=OFF \
	-D BUILD_TESTS=OFF \
	-DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" \
	..

"${MAKE[@]}"
"${MAKE[@]}" install/strip

popd
#rm -rf build
