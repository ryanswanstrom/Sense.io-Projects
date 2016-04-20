# # Run Your Analysis in the Cloud
# The Sense Platform allows you to run your data 
# analysis R code in the cloud.  All you need is a
# modern web browser.  Sense Platform also has 
# support for Python, Javascript, and a few other languages.
# 

# ## A Quick Example of running your R code in the Cloud

numbers = c(5, 8, 9, 2, -1, 4, 12, 6);  # make up some numbers
mean(numbers);  # find the average


# ## Display Some Nice Plots
# Create factors with value labels and then create
# Kernel density plots for mpg
# grouped by number of gears (indicated by color). 
# This example comes from [Quick-R ggplot2](http://www.statmethods.net/advgraphs/ggplot2.html)

library('sense')
library('ggplot2')
mtcars$gear <- factor(mtcars$gear,levels=c(3,4,5),
  	 labels=c("3gears","4gears","5gears")) 
mtcars$am <- factor(mtcars$am,levels=c(0,1),
  	 labels=c("Automatic","Manual")) 
mtcars$cyl <- factor(mtcars$cyl,levels=c(4,6,8),
   labels=c("4cyl","6cyl","8cyl")) 
qplot(mpg, data=mtcars, geom="density", fill=gear, alpha=I(.5), 
   main="Distribution of Gas Milage", xlab="Miles Per Gallon", 
   ylab="Density")


# #Adding Text and Markdown
# ##Text
# Adding text in the Sense Platform is simple. 
# Just start a line with the # sign. 
# 
# `# This is just a line of text.`  will produce:

# This is just a line of text.

# ## Markdown
# The Sense Platform supports Markdown mixed right in with the text.

#    # #A Markdown Title
#    # Followed by some **bold** and _italic_ text and a list
#    # 1. First Item in list
#    # 1. Another Item in the list
#    # 1. The final list item
#    # Followed by a table
#    #
#    # Column Header 1  | Column Header 2
#    # ---------------- | ---------------
#    # Content 1        | Content 2
#    # Content 3        | Content 4

# will produce: 

# #A Markdown Title
# Followed by some **bold** and _italic_ text and a list
# 1. First Item in list
# 1. Another Item in the list
# 1. The final list item
# Followed by a table
#
# Column Header 1  | Column Header 2 
# ---------------- | --------------- 
# Content 1        | Content 2 
# Content 3        | Content 4 

# #Latex is Supported
# $\LaTeX$ can be added in 2 ways

# 1. Inline - Surround your LATEX code with single $ signs. For example, `$y=mx+b$` will produce $y=mx+b$
# 1. Equation Mode - Surround your LATEX code with double $$ signs. For example, `$$y=mx+b$$` will produce
#   $$y=mx+b$$

# #Install a Missing Package
# In some instances, the R package you desire will not
# be included by default. No worries, it is easy to install a missing package.

install.packages('leaps')

# ##Much More
# There are many more features as well. An [API](http://help.senseplatform.com/api/rest/) is available
# and so is parallel programming, private corporate installs, support for Amazon S3, and much more.  
# However, all that is saved for another day.
