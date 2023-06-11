#!/bin/bash
#Seems to be useless. Confirm and remove?
#Installer for OpenSSL
#Usage: install_openssl <sources dir> <working dir> <default config dir>

install_openssl() {

    local sources_dir="$1"
    local working_dir="$2"
    local default_config="$3"

    #Get default config
    source "$working_dir/$default_config"

    cd "$working_dir/$sources_dir/openssl"

    config_and_build > "$working_dir/logs/openssl_build.log"

    if [ $? -eq 0 ]; then
        echo "OpenSSL successfully installed."
        export PATH="$prefix/bin:$PATH"
        echo "OpenSSL added to path. This is not a permanent change."
    else
        echo "Error while building OpenSSL. Have you changed the main configuration file?"
        exit 1
    fi
}


config_and_build(){
    ./Configure --prefix="$prefix" --openssldir="$dir_path" --libdir="$lib_path" shared zlib
    make
    make install
}