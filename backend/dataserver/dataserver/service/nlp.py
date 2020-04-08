import nltk

class NLPService:
    def pos_tag(self, words):
        return nltk.pos_tag(words)