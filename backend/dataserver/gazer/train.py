from glob import glob
import pickle

def loadall(filenames):
    out = []
    for filename in filenames:
        with open(filename, "rb") as f:
            while True:
                try:
                    out.extend(pickle.load(f))
                except EOFError:
                    break
    return out

ndata = loadall(glob('n/*'))
cdata = loadall(glob('c/*'))
icdata = loadall(glob('ic/*'))

x = ndata + cdata + icdata
# n 0 c 1 ic 2
y = [0] * len(ndata) + [1] * len(cdata) + [2] * len(icdata)

