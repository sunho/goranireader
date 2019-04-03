import re
import os

pos_pat = re.compile(r'\s([a-z-]+)\,')
actual_poss = ['aux', 'xint', 'cf', 'pred', 'vtn', 'conj', 'na', 'an', 'pref', 'suf', 'pron', 'prep', 'pl', 'int', 'v', 'ad', 'vi', 'vt', 'a', 'x', 'n']
sentences = dict()

for dirpath, dnames, fnames in os.walk('./raw'):
    for f in fnames:
      if f.endswith('.dic'):
        with open('./raw/' + f, 'r') as file:
          line = file.readline()
          while line:
            line = re.sub(r'^.*:','', line)
            part = line[:15]
            poss = pos_pat.findall(part)
            for pos in poss:
              if pos not in actual_poss:
                if pos not in sentences:
                  sentences[pos] = [line]
                else:
                  sentences[pos].append(line)
            line=file.readline()

with open('./result/abnormal_pos_sentences.txt', 'w') as out:
  for pos, sentence in sentences.items():
    print(pos, file=out)
    for sen in sentence:
      print(sen, file=out)
    print('-------------------',file=out)