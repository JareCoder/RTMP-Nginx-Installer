#!/bin/bash
#Installer for  Nginx with RTMP Module.
#Usage: install_nginx_rtmp <sources dir> <working dir> <default config dir>

install_nginx_rtmp() {
    local sources_dir="$1"
    local working_dir="$2"
    local default_config="$3"

    #Get default config and update source dir
    config_data=$(<"$working_dir/$default_config")
    rtmp_path="$working_dir/$sources_dir"
    config_data="${config_data//SOURCES_DIR/$rtmp_path}"

    #Write new config file to configs dir
    generated_path="$working_dir/configs/nginx_build.conf"
    echo "$config_data"
    echo "$config_data" > "$generated_path"

    if [ $? -eq 0 ]; then
        echo "Nginx build config updated successfully."
    else
        echo "Error while updating Nginx config. Have you changed the main configuration file?"
        exit 1
    fi

    #Get generated build config file
    echo $generated_path
    source $generated_path

    cd "$working_dir/$sources_dir/nginx/auto"

    ./configure --add-module="$rtmp_module" --sbin-path="$sbin_path" --conf-path="$conf_path" --pid-path="$pid_path" --with-https_ssl_module --with-stream

    make
    make install

        if [ $? -eq 0 ]; then
        echo "Nginx with RTMP Module successfully installed."
    else
        echo "Error while building Nginx with RTMP Module. Have you changed the main configuration file?"
        exit 1
    fi
}