#!/bin/bash

is_gcc_devtools() {
    if command -v gcc &> /dev/null; then
        echo "GCC developer tools found."
    else
        echo "GCC developer tools are not installed. Trying to install..."

        # Try package managers (maybe update to a list file & loop for easier scalability?)
        if command -v apt &> /dev/null; then
            apt update
            apt install -y build-essential
        elif command -v yum &> /dev/null; then
            yum groupinstall -y "Development Tools"
        else
            echo "Unsupported package manager. Please install GCC developer tools manually."
        fi

        # Verify installation
        if command -v gcc &> /dev/null; then
            echo "GCC developer tools installed successfully!"
        else
            echo "GCC developer tools installation failed. Please install GCC developer tools manually."
            exit 1
        fi
    fi
}