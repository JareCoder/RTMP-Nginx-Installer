#!/bin/bash
#A basic loading animation.

spinner(){
    local spin='-\|/'

    i=0
    while true; do
       i=$(( (i+1) %4 ))
       printf "\rInstalling... ${spin:$i:1}"
       sleep .1
    done
}