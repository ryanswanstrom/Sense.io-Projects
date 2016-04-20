library('data.table')

set.seed(578234)
par(mfrow=c(2,2))
### Quality Sensitivity Analysis

sen_qual = data.table(current_quality)
calc_qual = function(pred, prod, sigma) {
  100 * ifelse(pred >= prod,
              (pred - prod)/pred,
              (pred - prod)/(sigma^2) )
}

dev = sen_qual[,list(sd=sd(DEV_EFF)),by=APP]
sit = sen_qual[,list(sd=sd(SIT_DFTS)),by=APP]
uat = sen_qual[,list(sd=sd(UAT_DFTS)),by=APP]


sen_qual$DEV_EFF = 
apply(sen_qual, 1, function(x) {
  as.numeric(x[3]) + rnorm(1, mean=0, sd= dev[dev$APP == x[1]]$sd)
})
sen_qual[sen_qual$DEV_EFF < 0,]$DEV_EFF = 0
sen_qual$SIT_DFTS = 
apply(sen_qual, 1, function(x) {
  as.numeric(x[4]) + rnorm(1, mean=0, sd= dev[dev$APP == x[1]]$sd)
})
sen_qual[sen_qual$SIT_DFTS < 0,]$SIT_DFTS = 0
sen_qual$UAT_DFTS = 
apply(sen_qual, 1, function(x) {
  as.numeric(x[5]) + rnorm(1, mean=0, sd= dev[dev$APP == x[1]]$sd)
})
sen_qual[sen_qual$UAT_DFTS < 0,]$UAT_DFTS = 0

sigma = summary(baseline_quality_function)$sigma
sen_qual$PREDICTION_NEW = 
        predict(baseline_quality_function, newdata=sen_qual)
sen_qual[PREDICTION_NEW > sigma^2,]$PREDICTION_NEW = sigma^2

sen_qual$SCORE_NEW = calc_qual(sen_qual$PREDICTION_NEW, sen_qual$PROD_DFTS, sigma)
hist(sen_qual$SCORE_NEW - sen_qual$SCORE, 
     main='Sensitivity of Quality',
     xlab='Distance From Original Score',
     col='steelblue')


### Availability Sensitivity Analysis

calc_avail = function(actual, expected) {
  100 * ifelse(
    actual <= expected,
    (actual - expected)/expected,
    (actual - expected)/(1 - expected)
  )  
}
  
std = sd(avail_data_current$ACTUAL_UP)
avail_data_current$ACTUAL_UP_NEW = sapply(avail_data_current$ACTUAL_UP, 
                   function(x) {x + rnorm(1, 0, std)} )

avail_data_current[avail_data_current$ACTUAL_UP_NEW > 1, ]$ACTUAL_UP_NEW = 1

avail_data_current$SCORE_NEW = calc_avail(avail_data_current$ACTUAL_UP_NEW, avail_data_current$EXPECTED_UP)
hist(avail_data_current$SCORE_NEW - avail_data_current$SCORE, 
     main='Sensitivity of Availability',
     xlab='Distance From Original Score',
     col='steelblue')


### Schedule Sensitivity Analysis

##### scale is defined in schedule.R
calc_sched = function(pdelta) {
  (200/pi)*atan(pdelta /scale) 
}

##### Since not much data, run many times
score_distances = c()

for (i in 1:100) {
  sched_data$PERCENT_DELTA_NEW = sapply(sched_data$PERCENT_DELTA, 
                   function(x) {x + rcauchy(1, 0, scale)} )

  sched_data$SCORE_NEW = calc_sched(sched_data$PERCENT_DELTA_NEW)
  score_distances = c(score_distances, sched_data$SCORE_NEW - sched_data$SCORE)
}
hist(score_distances, 
     main='Sensitivity of Schedule',
     xlab='Distance From Original Score',
     col='steelblue')


### Requirements Sensitivity Analysis

sen_req = data.table(requirements_clean)
calc_req = function(comp, sched) {
  100*ifelse(
    comp > 2*sched, 1,
    (comp-sched)/sched )
}

cmp = sen_req[,list(sd=sd(COMPLETED)),by=PROJ_ID]

#hist(sen_req$COMPLETED)
sen_req$SCORE = calc_req(sen_req$COMPLETED, sen_req$SCHEDULED)

std = sd(sen_req$COMPLETED)
sen_req$COMPLETED_NEW = sapply(sen_req$COMPLETED, 
                   function(x) {x + rnorm(1, 0, std)} )
sen_req$COMPLETED_NEW = apply(sen_req, 1, function(x) {
  as.numeric(x[4]) + rnorm(1, mean=0, sd= cmp[cmp$PROJ_ID == x[1]]$sd)
})
sen_req[sen_req$COMPLETED_NEW < 0,]$COMPLETED_NEW = 0
#hist(sen_req$COMPLETED_NEW)

sen_req$SCORE_NEW = calc_req(sen_req$COMPLETED_NEW, sen_req$SCHEDULED)
hist(sen_req$SCORE_NEW - sen_req$SCORE, 
     main='Sensitivity of Requirements',
     xlab='Distance From Original Score',
     col='steelblue')



