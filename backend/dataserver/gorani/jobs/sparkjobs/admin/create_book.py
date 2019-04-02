from gorani.shared import FinalSparkJob, SparkJobContext
import pyspark.sql.functions as F

class CreateBook(FinalSparkJob):
    def __init__(self, context: SparkJobcontext):
        FinalSparkJob.__init__(self, context, 'Create Book')

    def create_all(self):
        files = self.list_input_files()
        for file in files:
            if file.endswith('.epub'):
                self._create(file, self._get_id(file))

    def create_one(self, id):
        files = self.list_input_files()
        for file in files:
            if file.endswith('.epub'):
                if id == self._get_id(file):
                    self._create(file, id)
                    break

    def _get_id(self, file):
        import re
        p = re.compile('.+?([0-9]+?)\.epub')
        match = p.match(file)
        return int(match.group(1))

    def _create(self, file, id):
        self.log('Creating {}'.format(file))

        from ebooklib import epub
        from nltk.corpus import stopwords
        from nltk import word_tokenize
        from nltk.stem import WordNetLemmatizer

        lemmatizer = WordNetLemmatizer()
        engstopwords = set(stopwords.words('english'))
        sc = self.spark.sparkContext

        self.book = epub.read_epub(file)
        # get html text from epub > words array
        df = sc.parallelize(self.book.items)\
        .filter(lambda item: isinstance(item, epub.EpubHtml))\
        .map(lambda item: item.get_content())\
        .map(CreateBook._clean_html) \
        .flatMap(word_tokenize)\
        .map(lambda s: lemmatizer.lemmatize(s))\
        .map(lambda s: s.lower())\
        .filter(lambda s: s not in engstopwords)\
        .toDF('string')

        # filter out the words not in dictionary
        words = self.context.read_data_all('words', cache=True)
        sig_df = df.join(words, df['value'] == words['word'], 'inner')\
        .select('word').cache()

        self._convert_to_book_words(sig_df, id)
        self._covert_to_book(sig_df, id)

    @staticmethod
    def _clean_html(html):
        from bs4 import BeautifulSoup
        soup = BeautifulSoup(html)
        for script in soup(['script', 'style']):
            script.extract()

        text = soup.get_text()
        lines = (line.strip() for line in text.splitlines())
        chunks = (phrase.strip() for line in lines for phrase in line.split("  "))
        text = '\n'.join(chunk for chunk in chunks if chunk)
        return text

    def _convert_to_book_words(self, df, id):
        df = df.groupBy('word').count()\
        .select('word', F.col('count').alias('n'))\
        .withColumn('book_id', F.lit(id))
        self.write_data('book_words',df)

    def _covert_to_book(self, df, id):
        df = df.agg(F.collect_list('word').alias('content'))\
        .withColumn('id', F.lit(id))\
        .withColumn('name', F.lit(self.book.title))
        self.write_data('books',df)


