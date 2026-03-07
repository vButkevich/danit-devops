#!/bin/bash

# Exercise 9: Error Handling
# Develop a script that attempts to read a file and handles errors gracefully.
#  If the file exists, it should print its contents; if not, it should display an error message.

enter-filename(){
    read -rp "Enter filename: " filename
}
check-filename(){
    if [[ ! -f "$filename" ]]; then
        echo "Error: file does not exist: $filename"
        exit 1
    fi
    if [[ ! -r "$filename" ]]; then
        echo "Error: File is not readable: $filename" >&2
        exit 1
    fi
}
show-file-content(){
    cat "$filename"
    exit 0
}

main(){ 
    enter-filename
    check-filename
    show-file-content
}
main