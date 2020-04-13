

def predict_vocab(simple_features, model):
    model.transform_input()
    model.predict(simple_features)