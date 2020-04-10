import nltk
from nltk.corpus import stopwords

class NLPService:
    def pos_tag(self, words):
        return nltk.pos_tag(words)

    def download_data(self):
        nltk.download('averaged_perceptron_tagger')

    def get_stop_words(self):
        return list(stopwords.words('english'))
