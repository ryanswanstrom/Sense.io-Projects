"""
Beating the benchmark 
Otto Group product classification challenge @ Kaggle

__author__ : Abhishek Thakur
"""

import pandas as pd
from sklearn import ensemble, feature_extraction, preprocessing
import zipfile
import random


def zip_it(outfile):
    print('writing zip')
    archive = zipfile.ZipFile(outfile + '.zip', 'w', zipfile.ZIP_DEFLATED)
    archive.write(outfile)
    archive.close()


def rf(outfile):

    random.seed(76002)
    # import data
    train = pd.read_csv('train.csv')
    test = pd.read_csv('test.csv')
    sample = pd.read_csv('sampleSubmission.csv')
    print 'sample file read'

    # drop ids and get labels
    labels = train.target.values
    train = train.drop('id', axis=1)
    train = train.drop('target', axis=1)
    test = test.drop('id', axis=1)

    # transform counts to TFIDF features
    tfidf = feature_extraction.text.TfidfTransformer()
    train = tfidf.fit_transform(train).toarray()
    test = tfidf.transform(test).toarray()

    # encode labels 
    lbl_enc = preprocessing.LabelEncoder()
    labels = lbl_enc.fit_transform(labels)

    print 'running random forest'
    # train a random forest classifier
    clf = ensemble.RandomForestClassifier(n_jobs=-1, n_estimators=800)
    clf.fit(train, labels)

    print 'predicting test data'
    # predict on test set
    preds = clf.predict_proba(test)

    print 'writing submission'
    # create submission file
    preds = pd.DataFrame(preds, index=sample.id.values, columns=sample.columns[1:])
    preds.to_csv(outfile, index_label='id')
    
    zip_it(outfile)
    

if __name__ == '__main__':
    outfile = 'rf_submission.csv'
    rf(outfile)
    
