#!/bin/bash

# Генеруємо випадкове число від 1 до 100
secret_number=$(( RANDOM % 100 + 1 ))
max_attempts=5
attempts=0

echo "Я загадав число від 1 до 100."
echo "У вас є $max_attempts спроб, щоб його вгадати."

# Цикл для обмеженої кількості спроб
while [ $attempts -lt $max_attempts ]; do
    # Підраховуємо спроби
    attempts=$((attempts + 1))
    remaining=$((max_attempts - attempts))
    
    # Запитуємо число у користувача
    echo -n "Спроба $attempts з $max_attempts. Ваше число: "
    read guess
    
    # Перевіряємо, чи введено число
    if ! [[ "$guess" =~ ^[0-9]+$ ]]; then
        echo "Будь ласка, введіть ціле число."
        attempts=$((attempts - 1))  # Не рахуємо некоректне введення як спробу
        continue
    fi
    
    # Порівнюємо з загаданим числом
    if [ $guess -eq $secret_number ]; then
        echo "Вітаємо! Ви вгадали правильне число."
        exit 0
    elif [ $guess -lt $secret_number ]; then
        echo "Занадто низько. Залишилось спроб: $remaining"
    else
        echo "Занадто високо. Залишилось спроб: $remaining"
    fi
    
    # Якщо це була остання спроба, завершуємо гру
    if [ $attempts -eq $max_attempts ]; then
        echo "Вибачте, у вас закінчилися спроби. Правильним числом було $secret_number"
        exit 1
    fi
done