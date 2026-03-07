#!/bin/bash

# Exercise 4: Looping
# Create a script that uses a loop to print numbers from 1 to 10.

print-numbers(){
    for i in {1..10}; do
        echo $i
    done
}

main(){ 
    print-numbers
}
main