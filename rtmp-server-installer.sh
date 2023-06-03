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

#Make sure git, GCC Dev Tools & pcre are installed
is_git
is_gcc_devtools
is_pcrelib

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

echo "Skipping functioning cloning and openssl installs"

echo -e "\nTrying to clone Nginx..."
try_clone "$nginx_stable_official" "$nginx_stable_fork" "$nginx_stable_official_branch" "$nginx_stable_fork_branch"

echo -e "\nTrying to clone RTMP Module..."
try_clone "$rtmp_module_official" "$rtmp_module_fork"

#echo -e "\nTrying to clone OpenSSL..."
#try_clone "$openssl_official" "$openssl_fork" "$openssl_official_branch" "$openssl_fork_branch"

#echo -e "\nTrying to install OpenSSL..."
#install_openssl "$sources_dir" "$working_dir" "$openssl_build_default"

echo -e "\nTrying to install Nginx with RTMP module..."
install_nginx_rtmp "$sources_dir" "$working_dir" "$nginx_rtmp_build_default"


echo "End of script"