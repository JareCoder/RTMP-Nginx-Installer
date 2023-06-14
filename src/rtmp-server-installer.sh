#!/bin/bash
#RTMP Nginx Installer script

#Import helpers & modules
for helper in ./helpers/*.sh; do
    source "$helper"
done
for module in ./modules/*.sh; do
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
#TODO Check if input file exists
port=$(get_port_input >&2)
echo "Output: $port"
app_name=$(get_application_input >&2)
echo "Output: $app_name"
ip_list=$(get_ip_list_input >&2)
echo "Output: $ip_list"

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

echo -e "\nTrying to configure RTMP module..."
configure_rtmp "$working_dir" "$nginx_rtmp_config_default" "$conf_path" "$port" "$app_name" "$ip_list"

echo "End of script"