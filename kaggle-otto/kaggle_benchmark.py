"""Script for the benchmark submission of the Otto Group Competition
hosted by Kaggle:

    https://www.kaggle.com/c/otto-group-product-classification-challenge

Use this script in the following way:

    python benchmark.py <path-to-train> <path-to-test> <name-of-submission>

Each argument is optional, the script will guess the right names.

"""

from __future__ import division
import sys

import numpy as np
import pandas as pd
from sklearn.cross_validation import train_test_split
from sklearn.ensemble import RandomForestClassifier, AdaBoostClassifier, GradientBoostingClassifier, ExtraTreesClassifier 
from sklearn.preprocessing import LabelEncoder


#np.random.seed(17411)


def logloss_mc(y_true, y_prob, epsilon=1e-15):
    """ Multiclass logloss

    This function is not officially provided by Kaggle, so there is no
    guarantee for its correctness.
    """
    # normalize
    y_prob = y_prob / y_prob.sum(axis=1).reshape(-1, 1)
    y_prob = np.maximum(epsilon, y_prob)
    y_prob = np.minimum(1 - epsilon, y_prob)
    # get probabilities
    y = [y_prob[i, j] for (i, j) in enumerate(y_true)]
    ll = - np.mean(np.log(y))
    return ll


def load_train_data(path=None, train_size=0.8):
    print 'in load_train_data'
    df = pd.read_csv('train.csv')
    X = df.values.copy()
    np.random.shuffle(X)
    print 'in load_train_data 2'
    X_train, X_valid, y_train, y_valid = train_test_split(
        X[:, 1:-1], X[:, -1], train_size=train_size,
    )
    print(" -- Loaded data.")
    return (X_train.astype(float), X_valid.astype(float),
            y_train.astype(str), y_valid.astype(str))


def load_test_data(path=None):
    df = pd.read_csv('test.csv')
    X = df.values
    X_test, ids = X[:, 1:], X[:, 0]
    return X_test.astype(float), ids.astype(str)


def train_rf():
    X_train, X_valid, y_train, y_valid = load_train_data()
    # Number of trees, increase this to beat the benchmark ;)
    n_estimators = 100
    clf = RandomForestClassifier(n_estimators=n_estimators)
    print(" -- Start training Random Forest Classifier.")
    clf.fit(X_train, y_train)
    y_prob = clf.predict_proba(X_valid)
    print(" -- Finished training.")

    encoder = LabelEncoder()
    y_true = encoder.fit_transform(y_valid)
    assert (encoder.classes_ == clf.classes_).all()

    score = logloss_mc(y_true, y_prob)
    print(" -- RF Multiclass logloss on validation set: {:.4f}.".format(score))

    return clf, encoder
  
def train_ada():
    X_train, X_valid, y_train, y_valid = load_train_data()
    # Number of trees, increase this to beat the benchmark ;)
    n_estimators = 100
    clf = AdaBoostClassifier(n_estimators=n_estimators)
    print(" -- Start training AdaBoost Classifier.")
    clf.fit(X_train, y_train)
    y_prob = clf.predict_proba(X_valid)
    print(" -- Finished training.")

    encoder = LabelEncoder()
    y_true = encoder.fit_transform(y_valid)
    assert (encoder.classes_ == clf.classes_).all()

    score = logloss_mc(y_true, y_prob)
    print(" -- Ada Multiclass logloss on validation set: {:.4f}.".format(score))

    return clf, encoder

def train_grad():
    X_train, X_valid, y_train, y_valid = load_train_data()
    # Number of trees, increase this to beat the benchmark ;)
    n_estimators = 100
    clf = GradientBoostingClassifier(n_estimators=n_estimators)
    print(" -- Start training GradientBoosting Classifier.")
    clf.fit(X_train, y_train)
    y_prob = clf.predict_proba(X_valid)
    print(" -- Finished training.")

    encoder = LabelEncoder()
    y_true = encoder.fit_transform(y_valid)
    assert (encoder.classes_ == clf.classes_).all()

    score = logloss_mc(y_true, y_prob)
    print(" -- GB Multiclass logloss on validation set: {:.4f}.".format(score))

    return clf, encoder

def train_ex():
    X_train, X_valid, y_train, y_valid = load_train_data()
    # Number of trees, increase this to beat the benchmark ;)
    n_estimators = 100
    clf = ExtraTreesClassifier(n_estimators=n_estimators)
    print(" -- Start training ExtraTrees Classifier.")
    clf.fit(X_train, y_train)
    y_prob = clf.predict_proba(X_valid)
    print(" -- Finished training.")

    encoder = LabelEncoder()
    y_true = encoder.fit_transform(y_valid)
    assert (encoder.classes_ == clf.classes_).all()

    score = logloss_mc(y_true, y_prob)
    print(" -- EX Multiclass logloss on validation set: {:.4f}.".format(score))

    return clf, encoder


def make_submission(clf, encoder, path='my_submission.csv'):
    X_test, ids = load_test_data()
    y_prob = clf.predict_proba(X_test)
    with open(path, 'w') as f:
        f.write('id,')
        f.write(','.join(encoder.classes_))
        f.write('\n')
        for id, probs in zip(ids, y_prob):
            probas = ','.join([id] + map(str, probs.tolist()))
            f.write(probas)
            f.write('\n')
    print(" -- Wrote submission to file {}.".format(path))


def main():
    print(" - Start.")
    rf, encoder = train_rf()
    rf, encoder = train_ada()
    rf, encoder = train_grad()
    rf, encoder = train_ex()
    #make_submission(rf, encoder)
    print(" - Finished.")


if __name__ == '__main__':
    main()

