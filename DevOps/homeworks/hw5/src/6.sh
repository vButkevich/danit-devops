#!/bin/bash

# Exercise 6: String Manipulation
# Build a script that takes a user's input as a sentence
# and then reverses the sentence word by word (e.g., "Hello World" becomes "World Hello").

set -euo pipefail

read_sentence() {
    read -rp "Enter a sentence: " sentence
    echo "$sentence"
}
# reverse_sentence() {
#     local sentence="$1"
#     local reversed=""    
#     for word in $sentence; do
#         reversed="$word $reversed"
#     done
#     echo "${reversed% }"
# }
reverse_sentence() {
    echo "$1" | tr ' ' '\n' | tac | tr '\n' ' '
}
show_reversed() {
    local reversed="$1"
    echo "Reversed sentence: $reversed"
}

main() {
    local sentence
    sentence="$(read_sentence)"

    local reversed
    reversed="$(reverse_sentence "$sentence")"

    show_reversed "$reversed"
}
main "$@"