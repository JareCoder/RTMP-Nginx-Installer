#!/bin/bash
is_pcrelib(){
    if ! command -v ldconfig &> /dev/null; then
        echo "ldconfig not found. Cannot check zlib. Check PATH!"
        exit 1
    fi

    if ldconfig -p | grep zlib1g &> /dev/null; then
        echo "zlib1g found"
    else
        echo "zlib1g not found. Attempting to install..."
        
        #Try package managers (maybe update to a list file & loop for easier scalability?)
        if command -v apt &> /dev/null; then
            apt update
            apt install -y zlib1g-dev
        elif command -v yum &> /dev/null; then
            yum install -y zlib-devel
        else
            echo "Unsupported package manager. Please install libpcre3-dev manually."
            exit 1
        fi

        if ldconfig -p | grep zlib1g &> /dev/null; then
            echo "zlib1g installed successfully!"
        fi
    fi
}