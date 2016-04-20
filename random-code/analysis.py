#!pip install --upgrade pip
!pip install listparser

import listparser as lp

url = 'https://raw.githubusercontent.com/rushter/data-science-blogs/master/data-science.opml'
d = lp.parse(url)

len(d.feeds)
d.feeds[24].url
d.feeds[24].title

!pip install feedparser
import feedparser
import time

feed = feedparser.parse(d.feeds[24].url)
feed['feed']['title']
len(feed['entries'])


feed = feedparser.parse('http://dsguide.biz/reader/feeds/posts')
feed['feed']['title']
feed['entries'][1]
feed['entries'][1].title
feed['entries'][1].link
feed['entries'][1].summary
feed['entries'][3].published

dt = time.strptime(feed['entries'][3].published, '%a, %d %b %Y %H:%M:%S +0000')




