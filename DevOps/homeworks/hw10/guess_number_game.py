import random

def guess_number_game():
    secret_number = random.randint(1, 100)
    max_attempts = 5

    print("Я загадав число від 1 до 100.")
    print(f"У вас є {max_attempts} спроб, щоб його вгадати.")

    for attempt in range(1, max_attempts + 1):
        try:
            user_guess = int(input(f"Спроба {attempt}. Введіть ваше число: "))
        except ValueError:
            print("Будь ласка, введіть ціле число.")
            continue

        if user_guess == secret_number:
            print("Вітаємо! Ви вгадали правильне число.")
            return
        elif user_guess > secret_number:
            print("Занадто високо")
        else:
            print("Занадто низько")

    print(f"Вибачте, у вас закінчилися спроби. Правильний номер був {secret_number}")

guess_number_game()