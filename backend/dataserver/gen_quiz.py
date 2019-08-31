import numpy as np
import pandas as pd
import nltk
nltk.download('punkt') # one time execution
import re

text = """
It took me a long time to learn where he came from. The little prince, who asked
me so many questions, never seemed to hear the ones I asked him. It was from
words dropped by chance that, little by little, everything was revealed to me.
The first time he saw my airplane, for instance (I shall not draw my airplane; that
would be much too complicated for me), he asked me:
"What is that object?"
"That is not an object. It flies. It is an airplane. It is my airplane."
And I was proud to have him learn that I could fly.
He cried out, then:
"What! You dropped down from the sky?"
"Yes," I answered, modestly.
"Oh! That is funny!"
And the little prince broke into a lovely peal of laughter, which irritated me very
much. I like my misfortunes to be taken seriously.
Then he added:
"So you, too, come from the sky! Which is your planet?"
At that moment I caught a gleam of light in the impenetrable mystery of his
presence; and I demanded, abruptly:
"Do you come from another planet?"
But he did not reply. He tossed his head gently, without taking his eyes from my
plane:
"It is true that on that you can't have come from very far away..."
And he sank into a reverie, which lasted a long time. Then, taking my sheep out of
his pocket, he buried himself in the contemplation of his treasure. 
You can imagine how my curiosity was aroused by this half−confidence about the
"other planets." I made a great effort, therefore, to find out more on this subject.
"My little man, where do you come from? What is this 'where I live,' of which you
speak? Where do you want to take your sheep?"
After a reflective silence he answered:
"The thing that is so good about the box you have given me is that at night he can
use it as his house."
"That is so. And if you are good I will give you a string, too, so that you can tie
him during the day, and a post to tie him to." 
But the little prince seemed shocked by this offer:
"Tie him! What a queer idea!"
"But if you don't tie him," I said, "he will wander off somewhere, and get lost."
My friend broke into another peal of laughter:
"But where do you think he would go?"
"Anywhere. Straight ahead of him." 
Then the little prince said, earnestly:
"That doesn't matter. Where I live, everything is so small!"
And, with perhaps a hint of sadness, he added:
"Straight ahead of him, nobody can go very far..."
"""
word_embeddings = {}
f = open('glove.6B.100d.txt', encoding='utf-8')
for line in f:
    values = line.split()
    word = values[0]
    coefs = np.asarray(values[1:], dtype='float32')
    word_embeddings[word] = coefs
f.close()
from nltk.corpus import stopwords
stop_words = stopwords.words('english')
def remove_stopwords(sen):
  sen_new = " ".join([i for i in sen if i not in stop_words])
  return sen_new
def summarize_sentences(sens, n):
  from nltk.tokenize import sent_tokenize
  sentences = sent_tokenize(text)

  clean_sentences = pd.Series(sentences).str.replace("[^a-zA-Z]", " ")
  clean_sentences = [s.lower() for s in clean_sentences]
  clean_sentences = [remove_stopwords(r.split()) for r in clean_sentences]
  sentence_vectors = []
  for i in clean_sentences:
    if len(i) != 0:
      v = sum([word_embeddings.get(w, np.zeros((100,))) for w in i.split()])/(len(i.split())+0.001)
    else:
      v = np.zeros((100,))
    sentence_vectors.append(v)

  sim_mat = np.zeros([len(sentences), len(sentences)])
  from sklearn.metrics.pairwise import cosine_similarity
  for i in range(len(sentences)):
    for j in range(len(sentences)):
      if i != j:
        sim_mat[i][j] = cosine_similarity(sentence_vectors[i].reshape(1,100), sentence_vectors[j].reshape(1,100))[0,0]
  import networkx as nx

  nx_graph = nx.from_numpy_array(sim_mat)
  scores = nx.pagerank(nx_graph)
  ranked_sentences = sorted(((scores[i],s) for i,s in enumerate(sentences)), reverse=True)
  for i in range(10):
    ranked_sentences[i][1])


from nltk.corpus import wordnet
from nltk.probability import FreqDist
from nltk.tokenize import word_tokenize
import simplejson
book = None
with open('out.book', 'rb') as f:
  book = simplejson.load(f)
fdist = FreqDist()
for chap in book['chapters']:
  for item in chap['items']:
    for word in word_tokenize(item['content']):
      fdist[word.lower()] += 1
  if chap['id'] == '2c1d5e56-c074-11e9-8a54-48bf6beb4102':
    for item in chap['items']:
      for word in word_tokenize(item['content']):
        fdist[word.lower()] += 1