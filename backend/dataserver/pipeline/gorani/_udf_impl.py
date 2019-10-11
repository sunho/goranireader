
class _UdfImpl:
    def __init__(self, gorani):
       self.gorani = gorani

    def stem(self, s):
        import pandas as pd
        import nltk
        nltk.download('wordnet', download_dir='/tmp/nltk_data')
        nltk.download('stopwords', download_dir='/tmp/nltk_data')
        nltk.data.path.append("/tmp/nltk_data")
        from nltk.stem import PorterStemmer
        stemmer = PorterStemmer()
        return pd.Series([stemmer.stem(s) for s in s])

    def get_sentence(self, book, chap, s):
        import pandas as pd
        import six
        return pd.Series([self.gorani.get_sentence(book, chap, s) or "" for book, chap, s in six.moves.zip(book, chap, s)])

    def get_content(self, book, chap, s):
        import pandas as pd
        import six
        return pd.Series([self.gorani.get_content(book, chap, s) or "" for book, chap, s in six.moves.zip(book, chap, s)])

    def get_username(self, user_id):
        import pandas as pd
        import six
        return pd.Series([self.gorani.get_username(user_id) or "" for user_id in user_id])

    def get_questions_len(self, book, chap):
        import pandas as pd
        import six
        return pd.Series([len(self.gorani.get_questions(book, chap)) or 0 for book, chap in six.moves.zip(book, chap)])