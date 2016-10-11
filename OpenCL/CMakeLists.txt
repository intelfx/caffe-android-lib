project(OpenCL_stub)
cmake_minimum_required(VERSION 2.8)

add_library(OpenCL SHARED
	opencl_stubs.c
)
target_include_directories(
	OpenCL
	PUBLIC include
)
install(DIRECTORY
	include/
	DESTINATION include
)
install(TARGETS
	OpenCL
	DESTINATION lib
)
