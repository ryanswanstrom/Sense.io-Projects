#Twitter User Analysis

According to [Alexa.com](http://www.alexa.com/siteinfo/twitter.com),
Twitter.com is the 10th most popular site in the world.  Twitter
is a social network that allows users to share information as a string 
of 140 or less characters.  This information is called a status update or tweet.
Twitter also allows a user _A_ to follow another user _B_.  Then user
_A_ will be able to easily view all of user _B_'s status updates. This 
interaction makes user _A_ a follower of user _B_.  The number of
followers for a user can be seen as a status symbol or it can indicate
a user's social media influence.  This study attempts to predict the number
of followers based upon the various characteristics of a twitter user.
To be more exact, this study aims to predict the number of twitter followers for the _top_ 1000 twitter accounts associated with the search term **data**.

## About the data

Twitter has an [API(Application Programming Interface)](https://dev.twitter.com/docs/api/1.1) which provides access
to information about the _top_ 1000 users for any search term. Unfortunately,
Twitter does not specify how these _top_ users are determined, but the users
can likely be identified as the most influential on twitter for a given search
term. On October 10, 2013, the Twitter API was used to pull information about the
 _top_ 1000 users associated with the term "data".  The final data is
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
