#!/bin/bash

# Exercise 8: Arrays
# Write a script that uses an array to store a list of fruits.
# Loop through the array and print each fruit on a separate line.

print_fruits() {
    local fruits=("apple" "banana" "orange" "grape" "strawberry")
    # echo ${fruits[@]}
    for fruit in "${fruits[@]}"; do
        echo "$fruit"
    done
}

main() {
    print_fruits
}
main

