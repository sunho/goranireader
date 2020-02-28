class SimpleModel:
    def __init__(self, pi, ps, pg, th):
        self.prob = dict()
        self.pi = pi
        self.ps = ps
        self.pg = pg
        self.th = th

    def fit(self, words, signals):
        for word, signal in zip(words,signals):
            if word not in self.prob:
                self.prob[word] = self.pi
            if signal == 1:
                self.prob[word] = self.prob[word]*(1-self.ps) / (self.prob[word]*(1-self.ps)+(1-self.prob[word])*self.pg)
            else:
                self.prob[word] = self.prob[word]*self.ps / (self.prob[word]*self.ps+(1-self.prob[word])*(1-self.pg))
    def predict(self, word):
        if word not in self.prob:
            return 0
        elif self.prob[word] > self.th:
            return 1
        else:
            return 0
