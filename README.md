Caffe-Android-Lib
===============
## Goal
Porting [caffe](https://github.com/BVLC/caffe) to Android platform

### Support
* Up-to-date caffe fork with specific buildsystem changes ([intelfx/caffe](https://github.com/intelfx/caffe/tree/android))
* CPU only
* Without support for certain IO libraries (leveldb and hdf5)

## Building

* [Android CrystaX NDK](https://www.crystax.net/en) [10.4.0 build 900](https://dl.crystax.net/builds/900/) or newer
* CMake 3.2 or newer recommended

```shell
git clone --recursive https://github.com/intelfx/caffe-android-lib.git
cd caffe-android-lib
[VARIABLES...] ./build.sh [<path/to/ndk>] [<components:to:build>]
```

### Configuration

The build script is configured with environment variables:

Variable       | Default                      | Effect
-------------- | ---------------------------- | --------------------------------------------------------
`ANDROID_ABI`  | `armeabi-v7a-hard with NEON` | Selects the target ABI, matches `APP_ABI` from ndk-build
`N_JOBS`       | logical CPU count            | `make -jN`
`ANDROID_NDK`  | none                         | Path to the CrystaX NDK
`BUILD_ONLY`   | empty, i. e. build all       | Colon-separated list of components to build or to skip


### `ANDROID_ABI`

ABIs are explained in the `cmake/toolchain.cmake` file in the CrystaX NDK distribution. Possible ABIs are:

- `armeabi` --- ARMv5TE (software floating-point)
- `armeabi-v6+vfp` --- ARMv6 (VFP, softfp ABI)
- `armeabi-v7a` --- ARMv7-A (VFPv2, softfp ABI)
- `armeabi-v7a+vfpv3` --- ARMv7-A (VFPv3, softfp ABI)
- `armeabi-v7a+neon` --- ARMv7-A (NEON, softfp ABI)
- `armeabi-v7a-hard*` --- substitute instead of `armeabi-v7a` for hardfp ABI
- `arm64-v8a` --- ARMv8
- `x86`, `x86_64` --- self-explanatory

**Note: OpenBLAS supports only ARMv5 and ARMv7 with hardfp ABI.**

## TODO
- [ ] integrate using CMake's ExternalProject
- [ ] add IO dependency support (i.e., leveldb and hdf5)
- [ ] OpenCL support
- [ ] CUDA suuport
