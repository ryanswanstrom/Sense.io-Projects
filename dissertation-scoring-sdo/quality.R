### Load Raw Quality Data
setAs("character","myDate", 
      function(from) {as.Date(from, format="%m/%d/%Y")} )
setClass('myDate')

quality_raw <- read.csv('data/quality_raw.csv', 
                         colClasses=c('factor',
                                      'myDate',
                                      'numeric',
                                      'numeric',
                                      'numeric',
                                      'numeric') )

### Get descriptive statistics
str(quality_raw)
summary(quality_raw)
var(quality_raw)

### Find the Baseline Quality Function
#### Use data prior to 2014
history_quality_raw = 
        quality_raw[quality_raw$MONTH_DT 
                     <= as.Date('2013-12-31') ,]

#### Create some plots of the historical quality data
par(mfrow=c(2,2))
plot(history_quality_raw$DEV_EFF, 
    history_quality_raw$PROD_DFTS, 
     xlab='DEV_EFF', ylab='PROD_DFTS', col='steelblue')
plot(history_quality_raw$SIT_DFTS, 
    history_quality_raw$PROD_DFTS, 
     xlab='SIT_DFTS', ylab='PROD_DFTS', col='steelblue')
plot(history_quality_raw$DEV_EFF, 
    history_quality_raw$PROD_DFTS, 
     xlab='UAT_DFTS', ylab='PROD_DFTS', col='steelblue')


##### Remove the outlier data point with 1216 PROD_DFTS
history_quality_clean = history_quality_raw[history_quality_raw$PROD_DFTS < 1000,]

##### create the model after dropping the
##### data point with over 1000 PROD_DFTS
baseline_quality_function = lm(PROD_DFTS ~ DEV_EFF + SIT_DFTS + UAT_DFTS, 
           data=history_quality_clean )
summary(baseline_quality_function)

par(mfrow=c(1,2))
qqnorm(baseline_quality_function$resid,col='steelblue')
qqline(baseline_quality_function$resid,col='steelblue')
summary(baseline_quality_function)$sigma
plot(baseline_quality_function$fitted,abs(baseline_quality_function$resid),
     col='steelblue',
    main='Fitted vs Resid',
    xlab='Fitted',
    ylab='Absolute Value of Residuals')
pairs(history_quality_clean[ ,c('DEV_EFF','SIT_DFTS','UAT_DFTS')],col='steelblue')

#### source code for ridge regression
#### did not yield better results
install.packages('ridge')
library('ridge')
rd = linearRidge(PROD_DFTS ~ DEV_EFF 
           + SIT_DFTS + UAT_DFTS , 
           data=history_quality_clean, nPCs=1)
summary(rd)


### Now calculate the Quality scores
#### Get data for 2014 and newer
current_quality = 
        quality_raw[quality_raw$MONTH_DT 
                     > as.Date('2013-12-31') ,]

current_quality$PREDICTION = 
        predict(baseline_quality_function, newdata=current_quality)
current_quality$SCORE = 100 * 
        ifelse(current_quality$PREDICTION 
               >= current_quality$PROD_DFTS,
                  (current_quality$PREDICTION 
                    - current_quality$PROD_DFTS)
                    /current_quality$PREDICTION,
                  (current_quality$PREDICTION 
                    - current_quality$PROD_DFTS)
                    /(summary(baseline_quality_function)$sigma^2)
                                     )

qual_scores = aggregate(SCORE ~ MONTH_DT, current_quality, mean )
qual_scores$MONTH_DT = as.yearmon(qual_scores$MONTH_DT, "%Y-%B")
qual_scores$SCORE = round(qual_scores$SCORE, 2)
qual_scores

barchart(qual_scores, main='CRI Quality Scores', ylab='CRI Quality Score',xlab='Month/Year')
