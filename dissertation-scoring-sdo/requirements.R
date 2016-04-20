# Read in the initial Raw data and transform

#req_data <- read.csv('data/requirements_initial_raw.csv')
#summary(req_data)
#str(req_data)
#
#req_data$PROJ_ID = paste('Proj', req_data$TeamID, req_data$SprintID, sep='-')
#
#        
##### group by Datekey and PROJ_ID,
##### and sum SPCommitted and SPCompleted
#dat1 = aggregate(SPCommitted ~ Datekey + PROJ_ID, req_data, sum )
#dat2 = aggregate(SPCompleted ~ Datekey + PROJ_ID, req_data, sum )
#req_raw = merge(dat1,dat2,by=c("Datekey","PROJ_ID"))
#
#req_raw$MONTH_DT = as.Date(as.character(req_raw$Datekey), '%Y%m%d')
#req_raw$SCHEDULED = req_raw$SPCommitted
#req_raw$COMPLETED = req_raw$SPCompleted
#### Write out the requirements_raw file
#write.csv(req_raw[,c('PROJ_ID','MONTH_DT','SCHEDULED','COMPLETED')], 'data/requirements_raw.csv',row.names=FALSE)

### Now read in the requirements data
requirements_raw = read.csv('data/requirements_raw.csv',
                              colClasses=c('factor',
                                      'Date',
                                      'numeric',
                                      'numeric') )

##### remove rows where COMPLETED and SCHEDULED are both 0
requirements_clean = requirements_raw[requirements_raw$SCHEDULED != 0, ]

requirements_clean$DIFF = requirements_clean$COMPLETED/requirements_clean$SCHEDULED
summary(requirements_clean)
str(requirements_clean)
var(requirements_clean$SCHEDULED)
var(requirements_clean$COMPLETED)
var(requirements_clean$DIFF)

hist(requirements_clean[requirements_clean$DIFF != 1,]$DIFF)

##### Now calculate the requirements CRI score
##### but only for year 2014 and 2015
current_requirements = requirements_clean[requirements_clean$MONTH_DT 
                     > as.Date('2013-12-31'), ]
current_requirements$MONTH_DT = as.yearmon(as.Date(current_requirements$MONTH_DT), "%Y-%B")
current_requirements$SCORE = 100*(current_requirements$COMPLETED-current_requirements$SCHEDULED)/current_requirements$SCHEDULED

req_scores = aggregate(SCORE ~ MONTH_DT, current_requirements, mean )
req_scores$SCORE = round(req_scores$SCORE, 2)
req_scores

barchart(req_scores, main='CRI Requirements Scores', ylab='CRI Requirements Score',xlab='Month/Year')




