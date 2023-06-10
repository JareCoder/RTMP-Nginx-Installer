#!/bin/bash
#A basic loading animation. Needs pid.

load_anim(){
    local pid="$1"

    spin='-\|/'

    i=0
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) %4 ))
        printf "\r${spin:$i:1}"
        sleep .1
    done
}

#load_anim "$!" &