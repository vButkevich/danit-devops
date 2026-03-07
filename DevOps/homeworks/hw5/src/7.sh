#!/bin/bash

# Exercise 7: Command Line Arguments
# Develop a script that accepts a filename as a command line argument
# and prints the number of lines in that file.

set -o nounset   # Помилка при використанні неоголошених змінних
set -o pipefail  # Помилка, якщо будь-яка команда в пайпі провалиться

count-lines(){
    
    local _FILE="$1"
    
    if [[ ! -f "$_FILE" ]]; then
        echo "Error: file does not exist: $_FILE"
        exit 1
    fi

    if [[ ! -r "$_FILE" ]]; then
        echo "Error: File is not readable: $_FILE" >&2
        return 1
    fi

    # local line_count=$(wc -l < "$1") ##повертає меншу кількість рядків, ніж є насправді, якщо файл не закінчується новим рядком
    local _LINE_COUNT=$(awk 'END {print NR}' "$_FILE" 2>/dev/null)
    echo "The file '$_FILE' has [$_LINE_COUNT] lines."
    exit 0
}
check-arguments(){
    if [[ $# -ne 1 ]]; then
       echo "Error: Invalid number of arguments" >&2
        show_usage
        exit 1
    fi
}
show_usage() {
    echo "Usage: $0 <filename>"
    echo "  <filename> - path to the file to count lines"
}

main(){ 
    check-arguments "$@"
    count-lines "$1"
}
main "$@"