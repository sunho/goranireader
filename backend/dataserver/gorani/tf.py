import pickle
import numpy as np

PUNC_LIST = ['.', '(', ')', ',', ';', ':', '-', '—']
POS_TAG_LIST = ['FW', 'CC', 'CD', 'EX', 'IN', 'JJ', 'JJR', 'JJS', 'LS', 'MD', 'NN', 'NNS','NNP', 'NNPS', 'PDT', 'POS', 'PRP', 'PRP$', 'RB', 'RBR', 'RBS', 'RP', 'TO', 'UH', 'VB', 'VBD', 'VBG', 'VBN', 'VBP', 'VBZ', 'WDT', 'WP', 'WP$', 'WRB'] + PUNC_LIST
FEATURE_LEN = len(POS_TAG_LIST) + 2
UWORD_INDEX = FEATURE_LEN - 2
SIZE_INDEX = FEATURE_LEN - 1
tag_to_num = {tag:i for i, tag in enumerate(sorted(POS_TAG_LIST))}

def _transform_paragraph(paragraph):
    pos = list()
    uword = list()
    size = list()
    for word in paragraph:
        if word['word'] not in PUNC_LIST and not word['word'].isalpha():
            continue
        if word['pos'] not in tag_to_num:
            continue
        pos.append(tag_to_num[word['pos']])
        uword.append(1 if word['uword'] == True else 0)
        size.append(len(word['word']))
    pos = np.array(pos)
    uword = np.array(uword)
    size = np.array(size)
    out = np.zeros((len(pos), FEATURE_LEN), dtype = 'float32')
    out[np.arange(len(pos)), pos] = 1
    out[:, UWORD_INDEX] = uword
    out[:, SIZE_INDEX] = size
    return out

def transform_paragraphs(paragraphs):
    ps2 = [_transform_paragraph(p['paragraph']) for p in paragraphs if len(p['paragraph']) != 0]
    max_len = max([p.shape[0] for p in ps2])
    x = np.zeros((len(ps2), max_len, FEATURE_LEN), dtype='float32')
    for i, p in enumerate(ps2):
        x[i, :p.shape[0], :] += p
    y = np.zeros((len(ps2), 1), dtype='float32')
    interval = np.array([p['interval'] for p in paragraphs if len(p['paragraph']) != 0], dtype = 'float32')
    y[:, 0] = interval
    return x,y


