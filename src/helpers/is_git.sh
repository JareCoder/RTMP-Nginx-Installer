#!/bin/bash

is_git() {
    if command -v git &> /dev/null; then
        echo "Git found"
    else
        echo "Git is not installed. Trying to to install..."

        #Try package managers (maybe update to a list file & loop for easier scalability?)
        if command -v apt &> /dev/null; then
            apt update
            apt install -y git
        elif command -v yum &> /dev/null; then
            yum install -y git
        else
            echo "Unsupported package manager. Please install Git manually."
        fi

        #Verify git install (Make a logging system to include errors)
        if command -v git &> /dev/null; then
            echo "Git installed succesfully!"
        else
            echo "Git installation failed. Please install Git manually."
            exit 1
        fi
    fi
}