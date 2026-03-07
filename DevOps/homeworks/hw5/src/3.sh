#!/bin/bash

# Exercise 3: Conditional Statements
# Write a script that checks if a file exists in the current directory. If it does,
#  print a message saying it exists; otherwise, print a message saying it doesn't exist.

enter-filename(){
    read -rp "Enter filename: " filename
}
check-filename(){
    if [[ -f "$filename" ]]; then
        echo "File '$filename' exists."
    else
        echo "File '$filename' does not exist."
    fi
}

main(){ 
    enter-filename
    check-filename
}
main