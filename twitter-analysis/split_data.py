# ## Training and Validation Data
#The data file was split into 2 datasets.  One for training the
#model and another for validating the model.  The split was
#60% for training and 40% for validation. 


import pandas as pd

twitter_data = pd.io.parsers.read_csv('twitter_data.csv')

# set the random number generator seed
random.seed(32835)

nrows = twitter_data.shape[0]
rows = range(nrows)

random.shuffle(rows)

split_point = int(nrows * .60)

train_rows = rows[:split_point]
test_rows  = rows[split_point:]

train_index = twitter_data.index[train_rows]
test_index  = twitter_data.index[test_rows]

training_data = twitter_data.ix[train_index, :]
test_data  = twitter_data.ix[test_index, :]

training_data.to_csv('twitter_data_training.csv', index=False)
test_data.to_csv('twitter_data_test.csv', index=False)