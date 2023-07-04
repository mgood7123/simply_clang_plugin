cmake_minimum_required(VERSION 3.4.3)
project(clang-tutor-hello-world)

#===============================================================================
# 1. LOAD LLVM CONFIGURATION
#===============================================================================
# Set this to a valid LLVM installation dir
set(CT_Clang_INSTALL_DIR "" CACHE PATH "LLVM installation directory")

# Add the location of ClangConfig.cmake to CMake search paths (so that
# find_package can locate it)
list(APPEND CMAKE_PREFIX_PATH "${CT_Clang_INSTALL_DIR}/lib/cmake/clang/")

find_package(Clang REQUIRED CONFIG)

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

testBuilder_add_source(HelloWorld HelloWorld.cpp)
testBuilder_build_shared_library(HelloWorld)

testBuilder_add_source(HWP empty.cpp)
testBuilder_add_library(HWP HelloWorld)
testBuilder_add_compile_option(HWP "SHELL:-Xclang -load -Xclang ${CMAKE_CURRENT_BINARY_DIR}/libHelloWorld.so -Xclang -add-plugin -Xclang hello-world")
testBuilder_build_shared_library(HWP)

testBuilder_add_source(HWP2 empty.cpp)
testBuilder_add_library(HWP2 HWP)
testBuilder_build_shared_library(HWP2)
