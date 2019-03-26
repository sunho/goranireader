from ebooklib import epub
from bs4 import BeautifulSoup
from nltk import word_tokenize
from nltk.stem import WordNetLemmatizer
from miner.shared.job import Job

import pyspark.sql.functions as F

lemmatizer = WordNetLemmatizer() 

class EpubToData(Job):
    def __init__(self):
        Job.__init__(self, "Epub To Data")

    def convert_all(self):
        import re
        from os import listdir
        from os.path import isfile, join
        p = re.compile('.+?([0-9]+?)\.epub')
        files = [join('./in', f) for f in listdir('./in') if isfile(join('./in', f))]
        for file in files:
            if file.endswith('.epub'):
                match = p.match(file)
                self._convert(file, int(match.group(1)))
    
    def convert_one(self, file):
        pass

    def _convert(self, file, id):
        sc = self.spark.sparkContext 
        df = sc.parallelize(epub.read_epub(file).items)\
        .filter(lambda item: isinstance(item, epub.EpubHtml))\
        .map(lambda item: item.get_content())\
        .map(EpubToData._clean_html)\
        .flatMap(word_tokenize)\
        .map(lambda s: lemmatizer.lemmatize(s))\
        .map(lambda s: s.lower())\
        .toDF('string')

        self._convert_to_book_words(df, id)

    def _convert_to_book_words(self, df, id):
        words = self.context.words
        expr = df['value'] == self.context.words['word']
        df.groupBy('value')\
        .count()\
        .join(words, expr, 'inner')\
        .select('word', F.col('count').alias('n'))\
        .withColumn('book_id', F.lit(id))\
        .write\
        .format("org.apache.spark.sql.cassandra")\
        .mode('append')\
        .options(table='book_words', keyspace='gorani')\
        .save()

    @staticmethod
    def _clean_html(html):
        soup = BeautifulSoup(html)
        for script in soup(["script", "style"]):
            script.extract()

        text = soup.get_text()
        lines = (line.strip() for line in text.splitlines())
        chunks = (phrase.strip() for line in lines for phrase in line.split("  "))
        text = '\n'.join(chunk for chunk in chunks if chunk)
        return text
