#!/bin/bash
#RTMP Nginx Installer script

#Import helpers
for helper in ./src/helpers/*.sh; do
    source "$helper"
done
for installer in ./src/*.sh; do
    source "$installer"
done

set -e

#Get working dir
working_dir=$(pwd)

echo $working_dir

#Make sure necessary tools are installed
is_git
is_gcc_devtools
is_pcrelib
is_zlib

#Get Installer configurations
source rtmp-server-installer.conf

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

echo -e "\nStarting the installation process. Go make a cup of coffee. This will take several minutes!"
#Build from source
echo "Trying to install OpenSSL. You can see the log in /logs/openssl_build.log..."
play_load_background
install_openssl "$sources_dir" "$working_dir" "$openssl_build_default" 2>&1 | tee -a "$working_dir/logs/openssl_build.log"
stop_load_background

play_load_background
echo -e "\nTrying to install Nginx with RTMP module. You can see the log in /logs/nginx_build.log..."
install_nginx_rtmp "$sources_dir" "$working_dir" "$nginx_rtmp_build_default" 2>&1 | tee -a "$working_dir/logs/rtmp_build.log"
stop_load_background

#Append Nginx config to include RTMP
rtmp_build_conf="$working_dir/configs/nginx_build.conf"
source $rtmp_build_conf
port=8099
app_name="TestiPetteri"
ip_list=[]

echo -e "\nTrying to configure RTMP module..."
configure_rtmp "$working_dir" "$nginx_rtmp_config_default" "$conf_path" "$port" "$app_name" "$ip_list"

echo "End of script"