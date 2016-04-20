## Setup

library(stringr)
library(twitteR)
library(ggplot2)

## Use Twitter API

api_key <- Sys.getenv("TWITTER_API_KEY")
api_secret <- Sys.getenv("TWITTER_API_SECRET")
access_token <- Sys.getenv("TWITTER_TOKEN")
access_token_secret <- Sys.getenv("TWITTER_TOKEN_SECRET")
setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)

## Get data
timeline <- userTimeline('swgoof', n=10000)

## Reshape
words <- unlist(sapply(timeline, function(x) { str_split(x$text, " ")}))
counts <- as.data.frame(aggregate(words, by=list(words), FUN=length))
colnames(counts) <- c("word", "count")

## Very basic summary
qplot(counts$count) + xlab("Count") + ggtitle("Twitter Word Counts")
sorted <- counts[with(counts, order(-count)), ]
sorted[1:50,]
