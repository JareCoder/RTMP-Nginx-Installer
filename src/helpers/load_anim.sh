#!/bin/bash
#A basic loading animation.

load_anim(){
    local chars="/-\|"
    local delay=0.1

    while true; do
        for char in ${chars}; do
            printf '\r%s' "${char}"
            sleep "${delay}"
        done
    done
}

play_load_background(){
    load_anim &
    local loading_pid=$!
}

stop_load_background(){
    kill -9 "${loading_pid}"
}