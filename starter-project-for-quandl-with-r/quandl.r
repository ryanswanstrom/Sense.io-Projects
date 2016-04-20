## Install and Load the Quandl Package for R
install.packages('Quandl') 
library('Quandl')

# Load the [sense library](https://github.com/SensePlatform/sense-r-module) includes
# a number of helper functions you can use from within R dashboards.
library('sense')

## Load the Quandl Data
### [United States Unemployment Data](https://www.quandl.com/data/ODA/USA_LUR-United-States-Unemployment-Rate-of-Total-Labor-Force)
### The dataset identifier can be found on Qunadl.com
dataset = Quandl('ODA/USA_LUR')

### Once the data is loaded, it can be explored and analyzed
str(dataset)
summary(dataset)

plot(dataset$Date, dataset$Value, 
    main='US Unemployment Over The Years', 
    xlab='Year',
    ylab='Unemployment Rate', 
    ylim=c(3,11),
    type='l',
    lwd=4,
    col='steelblue')

# It is clear to see the unemployment goes
# in cycles.  It rises quickly, then slowly falls,
# and then repeats.

