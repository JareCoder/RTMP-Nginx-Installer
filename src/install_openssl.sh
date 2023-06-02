#!/bin/bash
#Installer for OpenSSL
#Usage: install_openssl <sources dir> <working dir>

install_openssl() {

    local sources_dir="$1"
    local working_dir="$2"

    source $working_dir/configs/defaults/openssl-build/openssl_build.conf

    echo "OpenSSL path: $working_dir/$sources_dir/openssl"
    cd "$working_dir/$sources_dir/openssl"

    ./Configure --prefix="$prefix" --openssldir="$dir_path" "-Wl,-rpath,$lib_path"

    make
    make install
}