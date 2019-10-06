def split_sentence(sen):
    import re
    out = re.split("[^a-zA-Z-']+",sen)
    
    if out[0] == '':
        if len(out) == 1:
            return []
        out = out[1:]
    if out[len(out) - 1] == '':
        if len(out) == 1:
            return []
        out = out[:-1]
    return out
