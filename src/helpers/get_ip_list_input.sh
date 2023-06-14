#!/bin/bash
#Get path or raw input of IPs
get_ip_list_input.sh(){
        while true; do
        read -p $'\nChoose file path or manual input.\n1. File path\n2. Manual input' ip_list_input_type
        if [[ $ip_list_input_type == [1] ]]; then
            #Read file
            read -p "Input file path: " ip_list_path
                if [ -f "$ip_list_path" ]; then
                    echo "Reading file..." | tee /dev/tty
                    while IFS= read -r line; do
                        ip_lines+="$line"$'\n'
                    done < "$ip_list_path"
                    echo "Done!" | tee /dev/tty
                    break
                else
                    echo "File does not exist in given path. Try antoher path." | tee /dev/tty
                fi
        elif [[ $ip_list_input_type == [2] ]]; then
            #Read manual input
            read -p 'Insert IPs with a space in between: ' -ra ip_list
            ip_lines=$(print "%s\n" "${ip_list[@]}")
        else
            echo "Invalid input! Try again." | tee /dev/tty
            continue
        fi
    done

    return $ip_lines
}