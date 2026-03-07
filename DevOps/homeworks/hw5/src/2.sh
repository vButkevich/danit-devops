#!/bin/bash
# Exercise 2: User Input
# Create a script that asks the user for their name and then greets them using that name.

enter-name(){
    # read -rp "Enter your name: " name
    echo "Please enter your name:"
    read name
}
show-name(){
    echo "Your name is: ${name}"
    echo "Hello, ${name}!"
}

main(){ 
    enter-name
    show-name
}
main