#!/bin/bash
#Script for changing the RTMP portion of the Nginx Config
#Usage: configure_rtmp <working dir> <rtmp default config> <nginx config>
#<port> <app_name> <ip_list>
source "../helpers/ip_list_hander.sh"

configure_rtmp(){
    local working_dir="$1"
    local default_config="$2"
    local nginx_config="$3"
    local port="$4"
    local app_name="$5"
    local ip_list="$6"

    #Get default config and update port, application name and list of publisher IPs
    local config_data=$(<"$working_dir/$default_config")
    #Write port
    config_data="${config_data//PORT/$port}"
    #Write application name
    config_data="${config_data//APPLICATION_NAME/$app_name}"
    #Make temporary file for IP writing
    temp_file=$(mktemp)
    echo "$config_data" > "$temp_file"
    #Write IPs
    ip_list_handler "$ip_list" "$temp_file"
    #TODO ip list update fail / success
    #Reread config_data
    local config_data=$(<"$temp_file")

    #Write new RTMP block to configs dir
    generated_path="$working_dir/configs/nginx_rtmp.conf"
    echo "$config_data"
    echo "$config_data" > "$generated_path"

    #Read RTMP block
    local rtmp_block=$(<"$generated_path")
    #TODO Make sure that this isn't empty!

    #Make a copy of current nginx.conf
    local backup_name="${nginx_config}.backup"
    cp $nginx_config $backup_name

    #Replace the current rtmp block with new block
    if sed -i -e '/^rtmp{/,/^}' -e "$(cat "$generated_path")" "$nginx_config"; then
        echo "Rewrote RTMP block in nginx.conf succesfully!"
    else
        echo "RTMP block in nginx.conf not found. Adding new block to the end of file."
        echo "$rtmp_block" >> "$nginx_config"
    fi
}