import nltk

class MockNLPService:
    def pos_tag(self, words):
        return [(word, 'NN') for word in words]