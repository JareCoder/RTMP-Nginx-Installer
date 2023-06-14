#!/bin/bash
#Get path or raw input of IPs
get_ip_list_input(){
        while true; do
        read -p $'\nChoose file path or manual input.\n1. File path\n2. Manual input' ip_list_input_type >&3
        if [[ $ip_list_input_type == [1] ]]; then
            #Read file
            read -p "Input file path: " ip_list_path >&3
                if [ -f "$ip_list_path" ]; then
                    printf "Reading file...\n" >&3
                    while IFS= read -r line; do
                        ip_lines+="$line"$'\n'
                    done < "$ip_list_path"
                    printf "Done!\n" >&3
                    break
                else
                    printf "File does not exist in given path. Try antoher path.\n" >&3
                fi
        elif [[ $ip_list_input_type == [2] ]]; then
            #Read manual input
            read -p 'Insert IPs with a space in between: ' -ra ip_list >&3
            ip_lines=$(print "%s\n" "${ip_list[@]}")
        else
            printf "Invalid input! Try again.\n" >&3
            continue
        fi
    done

    echo $ip_lines
}