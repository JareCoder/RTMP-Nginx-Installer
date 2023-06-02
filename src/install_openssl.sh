#!/bin/bash
#Installer for OpenSSL

install_openssl() {

    local sources_dir="$1"
    local working_dir="$2"

    source $working_dir/configs/defaults/openssl-build/openssl_build.conf

    cd "$working_dir/$sources_dir/openssl"

    ./configure --prefix="$prefix" --openssldir="$dir_path" "-Wl,-rpath,$lib_path"

    make
    make install
}