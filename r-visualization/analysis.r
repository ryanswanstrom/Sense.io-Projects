# Setup
# -----
#
# The [sense library](https://github.com/SensePlatform/sense-r-module) includes
# a number of helper functions you can use from within R dashboards.

library('sense')

## [ggplot2](http://ggplot2.org/) is a great way to make pretty graphs.

library('ggplot2')

# Load Data
# ---------
#
# Download and load Boston housing price data.

system('wget -nc https://raw.github.com/vincentarelbundock/Rdatasets/master/csv/MASS/Boston.csv')
boston <- read.csv('Boston.csv')
head(boston)
summary(boston$price)

# Explore
# -------

qplot(boston$medv, main="Boston Median Housing Price")
qplot(boston$crim, boston$medv,
  main="Median Housing Prices vs. Crime",
  xlab="Crime", ylab="Median Housing Price (thousands)")
qplot(boston$age, boston$medv,
    main="Median Housing Prices vs. Building Age",
    xlab="Building Age", ylab="Median Housing Price (thousands)") +
  geom_smooth(method = "loess")
