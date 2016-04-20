.libPaths()
.libPaths( c( .libPaths(), file.path(Sys.getenv("SPARK_HOME"), "R", "lib")) )
library('SparkR')

## Initialize SparkContext
sc <- sparkR.init(appName = "Flights Data Example")

## Initialize SQLContext
sqlContext <- sparkRSQL.init(sc)

flightsCsvPath <- 'flights.csv'

## Create a local R dataframe
flights_df <- read.csv(flightsCsvPath, header = TRUE)

## Create a SparkR DataFrame
flights_sdf = createDataFrame(sqlContext, flights_df)
printSchema(flights_sdf)

cache(flights_sdf)

head(flights_sdf)

columns(flights_sdf)

count(flights_sdf)

# Select specific columns
destDF <- select(flights_sdf, "dest", "plane", "cancelled")

# Using SQL to select columns of data
# First, register the flights DataFrame as a table
registerTempTable(flights_sdf, "FLIGHTS_TABLE")
destDF <- sql(sqlContext, "SELECT dest, plane, cancelled FROM FLIGHTS_TABLE where dest = 'DEN' and dep_delay > arr_delay")
count(destDF)

# The collect function is used to convert the SparkR dataframe 
# to a regular R dataframe
reg_df <- collect(destDF)

# Print the regular data frame
str(reg_df)

## Perform other operations on the local dataframe

# Stop the SparkContext now
sparkR.stop()