import nltk
from nltk.corpus import stopwords

class NLPService:
    def __init__(self):
        self.stemmer = nltk.PorterStemmer()

    def pos_tag(self, words):
        return nltk.pos_tag(words)

    def download_data(self):
        nltk.download('averaged_perceptron_tagger')

    def get_stop_words(self):
        return list(stopwords.words('english'))

    def stem(self, word):
        return self.stemmer.stem(word)
