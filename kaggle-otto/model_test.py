"""
Beating the benchmark 
Otto Group product classification challenge @ Kaggle

__author__ : Abhishek Thakur
"""

import pandas as pd
import numpy as np
from sklearn import ensemble, feature_extraction, preprocessing
from sklearn.cross_validation import train_test_split
import zipfile
import random
  
# read in the file
# split into training and validation sets  
def read_file(train_size=.8):
    print 'loading training data'
    train = pd.read_csv('train.csv')
    train = train.drop('id', axis=1) 
    
    X = train.values.copy()
    
    random.shuffle(X) 
    x_train, x_valid, y_train, y_valid = train_test_split(
        X[:, 0:-1], X[:, -1], train_size=train_size)
        
    tfidf = feature_extraction.text.TfidfTransformer()
    x_train = tfidf.fit_transform(x_train).toarray()
    x_valid = tfidf.transform(x_valid).toarray()
    
    lbl_enc = preprocessing.LabelEncoder()
    y_train = lbl_enc.fit_transform(y_train)
    y_valid = lbl_enc.transform(y_valid)
    
    return (x_train, y_train, x_valid, y_valid, tfidf)
    
    
# train a random forest classifier
def train_rf(x, y, n_estimators=10):
    print 'training a random forest'
    rf_model = ensemble.RandomForestClassifier(n_jobs=-1, n_estimators=n_estimators)
    rf_model.fit(x, y)
    return rf_model
    
# train a Extra Trees Boost classifier
def train_extree(x, y, n_estimators=10):
    print 'training an extra tree'
    rf_model = ensemble.ExtraTreesClassifier(n_jobs=-1, n_estimators=n_estimators)
    rf_model.fit(x, y)
    return rf_model
    
# train a ADA Boost classifier
def train_adaboost(x, y, n_estimators=10):
    print 'training an Ada Boost'
    rf_model = ensemble.AdaBoostClassifier(n_estimators=n_estimators)
    rf_model.fit(x, y)
    return rf_model
    
# train a Gradient Boost classifier
def train_gradboost(x, y, n_estimators=10):
    print 'training a gradient boost'
    rf_model = ensemble.GradientBoostingClassifier(n_estimators=n_estimators)
    rf_model.fit(x, y)
    return rf_model
    
    
def validate_model(model, x_valid, y_valid):
    print 'validating model'
    y_prob = model.predict_proba(x_valid)

    score = logloss_mc(y_valid, y_prob)
    print("Multiclass logloss on validation set: {:.4f}.".format(score))
    
    
def logloss_mc(y_true, y_prob, epsilon=10e-15):
    """ Multiclass logloss

    This function is not officially provided by Kaggle, so there is no
    guarantee for its correctness.
    """
    # normalize
    y_prob = y_prob / y_prob.sum(axis=1).reshape(-1, 1)
    print 'y_prob: ' + str(y_prob[1])
    print 'y_true: ' + str(y_true[1])
    y_prob = np.maximum(epsilon, y_prob)
    y_prob = np.minimum(1 - epsilon, y_prob)
    print 'y_prob: ' + str(y_prob[1])
    print 'y_true: ' + str(y_true[1])
    # get probabilities
    y = [y_prob[i, j] for (i, j) in enumerate(y_true)]
    print 'y: ' + str(y[1])
    print 'y_true: ' + str(y_true[1])
    ll = - np.mean(np.log(y))
    return ll

def score_test(model, tfidf, outfile='submission.csv'):
    print 'scoring test file'
    test = pd.read_csv('test.csv')
    
    test = test.drop('id', axis=1)
    test = tfidf.transform(test).toarray()
    
    # predict on test set
    predicted = model.predict_proba(test)

    print 'writing submission'
    # create submission file
    sample = pd.read_csv('sampleSubmission.csv')
    predicted = pd.DataFrame(predicted, index=sample.id.values, columns=sample.columns[1:])
    predicted.to_csv(outfile, index_label='id')
    zip_it(outfile)
    
    
def zip_it(outfile):
    print('writing zip')
    archive = zipfile.ZipFile(outfile + '.zip', 'w', zipfile.ZIP_DEFLATED)
    archive.write(outfile)
    archive.close()
    

if __name__ == '__main__':
    print 'running model.test.py'
    # read in file, break out 80% for training, 20% for validation
    x_train, y_train, x_valid, y_valid, tfidf = read_file(.9)
    # train with random forest or Extra Trees Classifier or AdaBoost Classifier or GradientBoostClassifier
    model = train_rf(x_train, y_train, 830)
    
    # calculate logloss on validation set
    validate_model(model, x_valid, y_valid)
    # score the test file, write outputfile
    outfile = 'model_rf_submission.csv'
    score_test(model, tfidf, outfile)
    
