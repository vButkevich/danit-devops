#!/bin/bash

# Exercise 5: File Operations
# Write a script that copies a file from one location to another.
# Both locations should be passed as arguments

copy-file(){
    if [[ $# -ne 2 ]]; then
        echo "Usage: $0 <source> <destination>"
        exit 1
    fi

    local src="$1"
    local dst="$2"

    if [[ ! -f "$src" ]]; then
        echo "Error: Source file '$src' does not exist."
        exit 1
    fi

    cp "$src" "$dst"
    echo "File copied from '$src' to '$dst'."
    exit 0
}

main(){ 
    copy-file "$@"
}
main "$@"