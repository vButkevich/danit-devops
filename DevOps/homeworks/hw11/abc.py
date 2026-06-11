from EngAlphabet import EngAlphabet

def main():
    eng_alphabet = EngAlphabet()

    print("Літери англійського алфавіту:")
    eng_alphabet.print()

    print("Кількість літер:")
    print(eng_alphabet.letters_num())

    print("Чи належить літера 'F' англійському алфавіту?")
    print(eng_alphabet.is_en_letter("F"))

    print("Чи належить літера 'Щ' англійському алфавіту?")
    print(eng_alphabet.is_en_letter("Щ"))

    print("Приклад тексту англійською мовою:")
    print(EngAlphabet.example())

main()