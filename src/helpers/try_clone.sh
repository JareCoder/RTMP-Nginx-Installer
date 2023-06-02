#!/bin/bash
#Usage: try_clone <source repo> (<source 2 repo>) (<branch of source repo>) (<branch of source 2 repo>) 

try_clone() {

    local official_source="$1"
    local fork_source="$2"
    local official_branch="$3"
    local fork_branch="$4"

    if [ -n "$3" ]; then
        echo "Trying to clone from $official_source using branch $official_branch..."
        git clone --single-branch --branch $official_branch $official_source
    else
        echo "Trying to clone from $official_source..."
        git clone --single-branch $official_source
    fi

    if [ $? -eq 0 ]; then
        echo "Official source cloned successfully."
    else
        if [ -n "$4" ]; then
            echo "Clone from official failed. Trying $fork_source using branch $fork_branch..."
            git clone --single-branch --branch $fork_branch $fork_source
        else
            echo "Trying to clone from $fork_source..."
            git clone --single-branch $fork_source
        fi

        if [ $? -eq 0 ]; then
            echo "Fork source cloned successfully."
        else
            echo "Clone from fork failed. Check configuration file."
            exit 1
        fi
    fi

}

