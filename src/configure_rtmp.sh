#!/bin/bash
#Script for changing the RTMP portion of the Nginx Config
#Usage: configure_rtmp <working dir> <rtmp default config> <nginx config>
#<port> <app_name> <ip_list>

configure_rtmp(){
    local working_dir="$1"
    local default_config="$2"
    local nginx_config="$3"
    local port="$4"
    local app_name="$5"
    local ip_list="$6"

    #Get default config and update port, application name and list of publisher IPs
    local config_data=$(<"$working_dir/$default_config")
    #Set port
    config_data="${config_data//PORT/$port}"
    #Set application name
    config_data="${config_data//APPLICATION_NAME/$app_name}"
    #Set publisher IPs
    #config_data= *Loop that goes thru given list / file and inserts them under comment?

    #Write new config file to configs dir
    generated_path="$working_dir/configs/nginx_rtmp.conf"
    echo "$config_data"
    echo "$config_data" > "$generated_path"

    #Read RTMP block
    local rtmp_block=$(<"$generated_path")

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