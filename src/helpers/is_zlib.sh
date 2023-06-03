#!/bin/bash
is_zlib(){
    if ! command -v ldconfig &> /dev/null; then
        echo "ldconfig not found. Cannot check zlib. Check PATH!"
        exit 1
    fi

    if ldconfig -p | grep zlib1g-dev &> /dev/null; then
        echo "zlib1g-dev found"
    else
        echo "zlib1g-dev not found. Attempting to install..."
        
        #Try package managers (maybe update to a list file & loop for easier scalability?)
        if command -v apt &> /dev/null; then
            apt update
            apt install -y zlib1g-dev
        elif command -v yum &> /dev/null; then
            yum install -y zlib-devel
        else
            echo "Unsupported package manager. Please install zlib1g-dev manually."
            exit 1
        fi

        if ldconfig -p | grep zlib1g-dev &> /dev/null; then
            echo "zlib1g-dev installed successfully!"
        else
            echo "zlib1g-dev installation failed. Please install zlib1g-dev manually."
            exit 1
        fi
    fi
}