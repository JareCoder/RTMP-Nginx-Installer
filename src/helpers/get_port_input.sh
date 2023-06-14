#!/bin/bash
#Get and validate port from user
get_port_input(){
    while true; do
        read -p $'\nInput wanted port (recommended between 32768 - 61000): ' port
        if [[ $port =~ ^[0-9]+$ ]]; then
            if ss -ltn | awk '{print $4}' | grep -q ":$port$"; then
                printf "Port is in use! Choose another port.\n" >&2
            else
                printf "Using port: $port\n" >&2
                break
            fi
        else
            printf "Invalid input. Please enter a numeric port number.\n" >&2
        fi
    done

    echo $port
}