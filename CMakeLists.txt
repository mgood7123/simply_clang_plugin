cmake_minimum_required(VERSION 3.4.3)
project(HWP)

#===============================================================================
# 1. LOAD LLVM CONFIGURATION
#===============================================================================

# Set this to a valid LLVM installation dir
set(CT_Clang_INSTALL_DIR "" CACHE PATH "LLVM installation directory")

#if (NOT DEFINED CT_CLANG_INSTALL_DIR)
#	message(FATAL_ERROR "the cmake variable CT_Clang_INSTALL_DIR (LLVM installation directory) must be defined or set")
#endif()

# message(WARNING "CT_Clang_INSTALL_DIR = ${CT_Clang_INSTALL_DIR}")

# Add the location of ClangConfig.cmake to CMake search paths (so that
# find_package can locate it)
# list(APPEND CMAKE_PREFIX_PATH "${CT_Clang_INSTALL_DIR}/lib/cmake/clang/")

message(STATUS "CLANG C VERSION:   ${CMAKE_C_COMPILER_VERSION}")
message(STATUS "CLANG CXX VERSION: ${CMAKE_CXX_COMPILER_VERSION}")

find_package(LLVM ${CMAKE_CXX_COMPILER_VERSION} REQUIRED CONFIG)

message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "CMAKE_ROOT ${CMAKE_ROOT}")
message(STATUS "CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH}")
message(STATUS "LLVM_FOUND ${LLVM_FOUND}")
message(STATUS "LLVM_DIR ${LLVM_DIR}")
message(STATUS "LLVM_INCLUDE_DIRS: ${LLVM_INCLUDE_DIRS}")
message(STATUS "CLANG_INCLUDE_DIRS: ${CLANG_INCLUDE_DIRS}")
message(STATUS "LLVM_DEFINITIONS: ${LLVM_DEFINITIONS}")

message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

# HelloWorld includes headers from LLVM and Clang - update the include paths
# accordingly
include_directories(SYSTEM "${LLVM_INCLUDE_DIRS};${CLANG_INCLUDE_DIRS}")

#===============================================================================
# 2. LLVM-TUTOR BUILD CONFIGURATION
#===============================================================================

# Use the same C++ standard as LLVM does
set(CMAKE_CXX_STANDARD 17 CACHE STRING "")

# LLVM is normally built without RTTI. Be consistent with that.
if(NOT LLVM_ENABLE_RTTI)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-rtti")
endif()

if(NOT COMMAND testBuilder_build)
    add_subdirectory(testBuilder)
    testBuilder_set_current_working_directory_to_default_binary_directory()
endif()

testBuilder_add_source(HWP_PLUGIN HWP.cpp)
testBuilder_build_shared_library(HWP_PLUGIN)

# library that libs should link to in order to automatically use plugin

testBuilder_add_source(HWP empty.cpp)
testBuilder_add_compile_option(HWP "SHELL:-Xclang -load -Xclang $<TARGET_FILE:HWP_PLUGIN> -Xclang -add-plugin -Xclang hello-world")
testBuilder_add_dependency(HWP HWP_PLUGIN)
testBuilder_build_shared_library(HWP)
