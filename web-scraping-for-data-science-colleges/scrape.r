install.packages('rvest')
library('rvest')

url = 'http://101.datascience.community/2012/04/09/colleges-with-data-science-degrees/'

## First, grab the page source
webpage = html(url)

##  Grab the table
tbl = html_node(webpage, "table")

## Simply put the table in a dataframe
df = as.data.frame(html_table(tbl))
str(df)

## OK, that is great, but we want the URL for each school
## The text in the second column is wrapped in an <a> tag

### Read in the table rows
tr = html_nodes(tbl, 'tr')

### loop through the rows and pull out the 'href'
tds = html_nodes(tr, 'td a')
links = html_attr(tds, 'href')

## Append
# Append to the original data frame
# leave out links[1] because it 
# is null for the header row of the table
df$URL = links
summary(df)
str(df)

## Challenge
# Scrape the site and build a data frame with all the
# colleges available at Masters in Data Science
new_url = 'http://www.mastersindatascience.org/schools/'
