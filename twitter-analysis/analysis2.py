# ##Analy_sis_ 2
# 

import sense
import pandas.io.data as web
import matplotlib.pyplot as plt

# Basic Data Manipulation
# -----------------------
#
# Read data from Yahoo stock API using [pandas](http://bit.ly/HHNQqn).

start = datetime.datetime(2012, 1, 1)
end = datetime.datetime(2013, 11, 1)
stocks = web.DataReader(['GOOG','AAPL','TSLA'], 'yahoo', start, end)
stocks['Open']['GOOG'].plot(title="The Rise of Google")
