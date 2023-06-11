#!/bin/bash
#RTMP Nginx Installer script

#Import helpers & modules
for helper in ./src/helpers/*.sh; do
    source "$helper"
done
for module in ./src/modules/*.sh; do
    source "$module"
done

set -e

#Get path to root dir
working_dir="$(dirname "$(pwd)")"

echo $working_dir

#Make sure necessary tools are installed
is_git
is_gcc_devtools
is_pcrelib
is_zlib

#Get Installer configurations
source "$working_dir/configs/rtmp-server-installer.conf"

#Get user info
install_input


#Make sources directory and clone necessary libraries there
mkdir "$sources_dir"

if [ $? -eq 0 ]; then
    echo "$sources_dir dir created for git repos."
else
    echo "Error creating directory. Make sure the script is run with proper permissions."
    exit 1
fi

cd "$sources_dir"

#Clone repos
echo -e "\nTrying to clone Nginx..."
try_clone "$nginx_stable_official" "$nginx_stable_fork" "$nginx_stable_official_branch" "$nginx_stable_fork_branch"

echo -e "\nTrying to clone RTMP Module..."
try_clone "$rtmp_module_official" "$rtmp_module_fork"

echo -e "\nTrying to clone OpenSSL..."
try_clone "$openssl_official" "$openssl_fork" "$openssl_official_branch" "$openssl_fork_branch"

#Build from source
echo -e "\nStarting the installation process. Go make a cup of coffee. This will take several minutes!"

#TODO Deal fail and success of install_openssl & install_nginx_rtmp to user (prints)
echo "Trying to install OpenSSL. You can see the log in /logs/openssl_build.log..."
install_openssl "$sources_dir" "$working_dir" "$openssl_build_default"

echo -e "\nTrying to install Nginx with RTMP module. You can see the log in /logs/nginx_build.log..."
install_nginx_rtmp "$sources_dir" "$working_dir" "$nginx_rtmp_build_default"

#Append Nginx config to include RTMP
rtmp_build_conf="$working_dir/configs/nginx_build.conf"
source $rtmp_build_conf
ip_list=[]

echo -e "\nTrying to configure RTMP module..."
configure_rtmp "$working_dir" "$nginx_rtmp_config_default" "$conf_path" "$port" "$app_name" "$ip_list"

echo "End of script"

install_input() {
    #TODO Check if input file exists
    #Get and validate port input
    while true; do
        read -p $'\nInput wanted port (recommended between 32768 - 61000): ' port
        if [[ $port =~ ^[0-9]+$ ]]; then
            if netstat -tuln | grep -q "$port"; then
                echo "Port is in use! Choose another port."
            else
                echo "Using port: $port"
                break
            fi
        else
            echo "Invalid input. Please enter a numeric port number."
        fi
    done

    #Get application input
    echo -e '\nThe final from will be "rtmp:<ip>/<your input>/live(/<stream key>)". You can see the full address in the Information tab.'
    while true; do
        read -p $'\nInput application name (no spaces): ' app_name
        echo "Using $app_name."
        read -p 'Confirm application name (Y/n): ' confirm_app
        if [[ $confirm_app == [Yy]]]; then
            break
        elif [[ $confirm_app == [Nn]]]; then
            echo "Re-input the name!"
        else
            echo "Invalid confirm input! Try again."
        fi
    done

    #Get a list of publisher IP's
    #TODO Make work yes. Ask if it's raw input or file path!
}