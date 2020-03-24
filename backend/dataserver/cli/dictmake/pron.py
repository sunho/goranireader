#
# Copyright © 2019 Sunho Kim. All rights reserved.
#

import json
import codecs

# https://stackoverflow.com/questions/33666557/get-phonemes-from-any-word-in-python-nltk-or-other-modules
import nltk
from functools import lru_cache
from itertools import product as iterprod

try:
    arpabet = nltk.corpus.cmudict.dict()
except LookupError:
    nltk.download('cmudict')
    arpabet = nltk.corpus.cmudict.dict()

@lru_cache()
def wordbreak(s):
    s = s.lower()
    if s in arpabet:
        return arpabet[s]
    middle = len(s)/2
    partition = sorted(list(range(len(s))), key=lambda x: (x-middle)**2-x)
    for i in partition:
        pre, suf = (s[:i], s[i:])
        if pre in arpabet and wordbreak(suf) is not None:
            return [x+y for x,y in iterprod(arpabet[pre], wordbreak(suf))]
    return None

missed = 0
missed_list = []
dictionary = []
with open('output.json', encoding='utf8') as file:
  line = file.readline()
  while line:
    word = json.loads(line)
    phones = wordbreak(word['word'])
    if phones is not None:
      word['pron'] = " ".join(phones[0])
    else:
      missed +=1
      missed_list.append(word)
    dictionary.append(word)
    line = file.readline()
    
  
print(missed)

with open('missed.txt', 'w') as file:
  print(missed_list, sep='\n', file=file)

with open('./proned_output.json', 'w', encoding='utf8') as file:
  json.dump(dictionary, file, ensure_ascii=False)
