# Load Data
# ---------
#
# Load the Availability data.
setAs("character","myDate", 
      function(from) {as.Date(from, format="%m/%d/%Y")} )
setClass('myDate')

avail_raw <- read.csv('data/availability_raw.csv',
                      colClasses=c('factor',
                                    'myDate',
                                    'numeric',
                                    'numeric'))

summary(avail_raw)
str(avail_raw)

# trim to only 2014 and newer
avail_data_current = 
        avail_raw[avail_raw$MONTH_DT >= as.Date('2014-01-01') ,]

avail_data_current$SCORE =  100 * ifelse(
  avail_data_current$ACTUAL_UP <= avail_data_current$EXPECTED_UP,
  (avail_data_current$ACTUAL_UP - avail_data_current$EXPECTED_UP)/avail_data_current$EXPECTED_UP,
  (avail_data_current$ACTUAL_UP - avail_data_current$EXPECTED_UP)/(1 - avail_data_current$EXPECTED_UP)
  )       
 
avail_scores = aggregate(SCORE ~ MONTH_DT, avail_data_current, mean )
avail_scores$MONTH_DT = as.yearmon(avail_scores$MONTH_DT, "%Y-%B")
avail_scores$SCORE = round(avail_scores$SCORE, 2)

barchart(avail_scores, main='CRI Availability Scores',
         ylab='CRI Availability Score',xlab='Month/Year')