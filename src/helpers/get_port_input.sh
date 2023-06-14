#!/bin/bash
#Get and validate port from user
get_port_input(){
    while true; do
        read -p $'\nInput wanted port (recommended between 32768 - 61000): ' port
        if [[ $port =~ ^[0-9]+$ ]]; then
            if ss -ltn | awk '{print $4}' | grep -q ":$port$"; then
                echo "Port is in use! Choose another port." | tee /dev/tty
            else
                echo "Using port: $port" | tee /dev/tty
                break
            fi
        else
            echo "Invalid input. Please enter a numeric port number." | tee /dev/tty
        fi
    done

    echo $port
}