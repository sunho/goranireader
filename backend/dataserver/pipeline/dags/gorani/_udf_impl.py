class _UdfImpl:
    def __init__(self, gorani):
       self.gorani = gorani

    def stem(self, s):
        import nltk
        nltk.download('wordnet', download_dir='/tmp/nltk_data')
        nltk.download('stopwords', download_dir='/tmp/nltk_data')
        nltk.data.path.append("/tmp/nltk_data")
        from nltk.corpus import stopwords
        stop_words = stopwords.words('english')
        if s in stop_words:
            return 'STOPSTOP'
        from nltk.stem import PorterStemmer
        stemmer = PorterStemmer()
        return stemmer.stem(s)

    def get_sentence(self, book, chap, s):
        return self.gorani.get_sentence(book, chap, s) or ""

    def get_content(self, book, chap, s):
        return self.gorani.get_content(book, chap, s) or ""

    def get_username(self, user_id):
        return self.gorani.get_username(user_id) or ""