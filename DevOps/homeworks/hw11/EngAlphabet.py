from Alfabet import Alphabet

class EngAlphabet(Alphabet):
    _letters_num = 26

    def __init__(self):
        super().__init__(
            "En",
            "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        )

    def is_en_letter(self, letter):
        return letter.upper() in self.letters

    def letters_num(self):
        return EngAlphabet._letters_num

    @staticmethod
    def example():
        return "This is an example of English text."