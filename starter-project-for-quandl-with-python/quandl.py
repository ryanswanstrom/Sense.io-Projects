# Install the Quandl module
!pip install Quandl

# Import libraries
import sense
import numpy as np
import pandas as pd
import pandas.io.data as web
import matplotlib.pyplot as plt
import Quandl

## Read in the Dataset
##### A dataset of Household Electrical Usage in the US
##### Available at https://www.quandl.com/data/UN/ELECTRICITYCONSUMPTIONBYHOUSEHOLDS_USA-Electricity-Consumption-By-Households-United-States-of-America
dataset = pd.DataFrame(Quandl.get('UN/ELECTRICITYCONSUMPTIONBYHOUSEHOLDS_USA',returns='numpy') )
dataset
dataset.describe()

### Quandl also allows filtering of data when reading the dataset
dataset = pd.DataFrame(Quandl.get('UN/ELECTRICITYCONSUMPTIONBYHOUSEHOLDS_USA', 
                     trim_start='1996-12-31',
                     returns='numpy'))

##### There are also options for simple calculations
##### and column selection, see https://www.quandl.com/help/python


plt.plot(dataset['Year'],
         dataset['Kilowat-hours - milion'])
plt.title('U.S. Household Energy Consumption')
plt.xlabel('Year')
plt.ylabel('Enery Usage')
plt.show()
