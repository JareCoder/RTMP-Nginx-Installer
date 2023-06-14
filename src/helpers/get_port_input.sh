#!/bin/bash
#Get and validate port from user
get_port_input(){
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

    return $port
}