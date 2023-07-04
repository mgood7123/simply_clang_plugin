make CXXCOMPILER=clang++ CMAKE_FLAGS="-DCT_Clang_INSTALL_DIR=$(llvm-config-13 --prefix)" build_debug $@
