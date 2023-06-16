#!/bin/bash
#Get application name from user
#TODO Validate name. Not empty & no spaces
get_application_input(){
    printf '\nThe final from will be "rtmp:<ip>/<your input>/live(/<stream key>)". You can see the full address in the Information tab.\n' >&2
    while true; do
        read -p $'\nInput application name (no spaces): ' app_name
        printf "Using $app_name." >&2
        read -p $'\nConfirm application name (Y/n): ' confirm_app
        if [[ $confirm_app == [Yy] ]]; then
            break
        elif [[ $confirm_app == [Nn] ]]; then
            printf "Re-input the name!\n" >&2
        else
            printf "Invalid confirm input! Try again.\n" >&2
        fi
    done

    echo $app_name
}