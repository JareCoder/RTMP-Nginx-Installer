#!/bin/bash
#Get application name from user
#TODO Validate name. Not empty & no spaces
get_application_input(){
    echo -e '\nThe final from will be "rtmp:<ip>/<your input>/live(/<stream key>)". You can see the full address in the Information tab.'
    while true; do
        read -p $'\nInput application name (no spaces): ' app_name
        echo "Using $app_name."
        read -p 'Confirm application name (Y/n): ' confirm_app
        if [[ $confirm_app == [Yy] ]]; then
            break
        elif [[ $confirm_app == [Nn] ]]; then
            echo "Re-input the name!"
        else
            echo "Invalid confirm input! Try again."
        fi
    done

    return $app_name
}