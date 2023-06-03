#!/bin/bash
is_pcrelib(){
    $package="libpcre3"
    $package_dev="libpcre3-dev"

    if ! command -v ldconfig &> /dev/null; then
        echo "ldconfig not found. Cannot check libpcre3. Check PATH!"
        exit 1
    fi

    if ldconfig -p | grep "$package" &> /dev/null; then
        echo "$package found"
    else
        echo "$package not found. Attempting to install..."
        
        if command -v apt &> /dev/null; then
            apt update
            apt install -y "$package"
        elif command -v yum &> /dev/null; then
            yum install -y pcre
        else
            echo "Unsupported package manager. Please install libpcre3-dev manually."
            exit 1
        fi

        if ldconfig -p | grep "$package" &> /dev/null; then
            echo "$package installed successfully!"
        fi
    fi

    if ldconfig -p | grep "$package_dev" &> /dev/null; then
        echo "$package_dev found"
    else
        echo "$package_dev not found. Attempting to install..."
        #Try package managers (maybe update to a list file & loop for easier scalability?)
        if command -v apt &> /dev/null; then
            apt update
            apt install -y "$package_dev"
        elif command -v yum &> /dev/null; then
            yum install -y pcre-devel
        else
            echo "Unsupported package manager. Please install libpcre3-dev manually."
            exit 1
        fi

        if ldconfig -p | grep "$package_dev" &> /dev/null; then
            echo "$package_dev installed successfully!"
        fi
    fi
}