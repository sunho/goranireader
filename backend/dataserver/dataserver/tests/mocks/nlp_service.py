import nltk

class MockNLPService:
    def pos_tag(self, words):
        return [(word, 'NN') for word in words]

    def get_stop_words(self):
        return ["hello"]

    def stem(self, word):
        return word