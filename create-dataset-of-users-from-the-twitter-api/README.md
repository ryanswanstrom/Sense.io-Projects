# Create User Dataset From the Twitter API

This project provides an example of using python to pull user
data from Twitter. 

This project will create a dataset of the top 1000
twitter users for any given search topic.


## About the data

Twitter has an [API(Application Programming Interface)](https://dev.twitter.com/docs/api/1.1) which provides access
to information about the _top_ 1000 users for any search term 
(See [Twitter User Search API](https://dev.twitter.com/docs/api/1.1/get/users/search)
). Unfortunately,
Twitter does not specify how these _top_ users are determined, but the users
can likely be identified as the most influential on twitter for a given search
term. 

The file [twitterstream.py](https://senseplatform.com/ryanswanstrom/create-dataset-of-users-from-the-twitter-api/files/twitterstream.py)
produces a final data file (or 3) with the name **twitterusers_<your search term>.csv** and
formatted as a CSV(Comma Separated Values) file with each row indicating
a separate user and the columns as follows:

1. **handle** - twitter username | string
1. **name** - full name of the twitter user | string
1. **age** - number of days the user has existed on twitter | number
1. **numOfTweets** - number of tweets this user has created (includes retweets) | number
1. **hasProfile** - 1 if the user has created a profile description, 0 otherwise | boolean
1. **hasPic** - 1 if the user has setup a profile pic, 0 otherwise | boolean
1. **numFollowing** - number of other twitter users, this user is following | number
1. **numOfFavorites** - number of tweets the user has favorited | number
1. **numOfLists** - number of public lists this user has been added to | number
1. **numOfFollowers** - number of other users following this user | number