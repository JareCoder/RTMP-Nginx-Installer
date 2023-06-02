#!/bin/bash
#Installer for OpenSSL
#Usage: install_openssl <sources dir> <working dir> <default config dir>

install_openssl() {

    local sources_dir="$1"
    local working_dir="$2"
    local default_config="$3"

    source $working_dir/$default_config

    cd "$working_dir/$sources_dir/openssl"

    ./Configure --prefix="$prefix" --openssldir="$dir_path" "-Wl,-rpath,$lib_path"

    make
    make install

    if [ $? -eq 0 ]; then
        echo "OpenSSL successfully installed."
        export PATH="$prefix/bin:$PATH"
        echo "OpenSSL added to path."
    else
        echo "Error while building OpenSSL. Try another version."
        exit 1
    fi
}