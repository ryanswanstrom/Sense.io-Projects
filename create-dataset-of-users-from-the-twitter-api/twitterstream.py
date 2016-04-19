!pip install oauth2 --user
import oauth2 as oauth
import urllib2 as urllib
import sys
import simplejson as json
import csv
import time
import re
from datetime import datetime

# See Twitter API, https://dev.twitter.com/ for these credentials
# these are Sense environment variables
access_token_key = os.environ["ACCESS_TOKEN_KEY"]
access_token_secret = os.environ["ACCESS_TOKEN_SECRET"]

consumer_key = os.environ["CONSUMER_KEY"]
consumer_secret = os.environ["CONSUMER_SECRET"]

_debug = 0

oauth_token    = oauth.Token(key=access_token_key, secret=access_token_secret)
oauth_consumer = oauth.Consumer(key=consumer_key, secret=consumer_secret)

signature_method_hmac_sha1 = oauth.SignatureMethod_HMAC_SHA1()

http_method = "GET"


http_handler  = urllib.HTTPHandler(debuglevel=_debug)
https_handler = urllib.HTTPSHandler(debuglevel=_debug)

# Construct, sign, and open a twitter request
# using the credentials above.
def twitterreq(url, method, parameters):
  req = oauth.Request.from_consumer_and_token(oauth_consumer,
                                             token=oauth_token,
                                             http_method=http_method,
                                             http_url=url, 
                                             parameters=parameters)

  req.sign_request(signature_method_hmac_sha1, oauth_consumer, oauth_token)

  headers = req.to_header()

  if http_method == "POST":
    encoded_post_data = req.to_postdata()
  else:
    encoded_post_data = None
    url = req.to_url()

  opener = urllib.OpenerDirector()
  opener.add_handler(http_handler)
  opener.add_handler(https_handler)

  response = opener.open(url, encoded_post_data)

  return response

# function to fetch up to 1000 users based upon some search query
def fetchsamples(query):
    url = "https://api.twitter.com/1.1/users/search.json?page={0}&q=" + str(query) + "&count=20"
    parameters = [] 
    twitter_users = []
    current_day = datetime.utcnow()
    num_pages = 50 #run it enough times to get all 1000 users

    for i in range(0,num_pages):
        print 'getting set ' + str(i+1) + ' of twitter users for ' + query
        response = twitterreq(url.format(str(i+1)), "GET", parameters)
        for line in response:
            #print line.strip()
            js = json.loads(line)
            for user in js:
                account = []
                try:
                    account.append(user.get('screen_name').encode('utf-8')) # twitter handle
                    account.append(user.get('name').encode('utf-8'))        # full name
                    account.append((current_day - datetime.strptime(user.get('created_at'), '%a %b %d %H:%M:%S +0000 %Y')).days)  # age in days
                    account.append(user.get('statuses_count')) # number of tweets
                    account.append(0 if user.get('default_profile') else 1) # has a profile been specified
                    account.append(0 if user.get('default_profile_image') else 1) # has a profile pic been specified
                    account.append(user.get('friends_count'))  # number of twitter accounts this user is following
                    account.append(user.get('favourites_count')) # number of tweets this user has favorited
                    account.append(user.get('listed_count'))     # number of lists this user is in
                    account.append(user.get('followers_count')) #followers
                    twitter_users.append(account)
                except AttributeError:
                    print str(js)
                    break
                    

    filename = "twitterusers_" + re.sub("\W+","-", query) + ".csv"
    with open(filename, 'wb') as f:
        writer = csv.writer(f, dialect='excel')
        writer.writerow(['handle','name','age','num_of_tweets','has_profile','has_pic','num_following',
            'num_of_favorites','num_of_lists','num_of_followers'])
        writer.writerows(twitter_users)

# each call to fetchsamples will make 50 Twitter API calls
# the limit is 180 API calls every 15 minutes
# this is where you specify your search terms
fetchsamples("data science")
fetchsamples("analytics")
fetchsamples("hadoop")

#fetchsamples("statistics")
#fetchsamples("big data")
#fetchsamples("machine learning")
