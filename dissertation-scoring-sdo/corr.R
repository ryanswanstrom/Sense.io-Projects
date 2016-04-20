


#### Create some plots of the historical quality data
par(mfrow=c(3,2))
plot(full$SCORE_QUAL, full$SCORE_AVAIL, 
     xlab='CRI Quality Scores', ylab='CRI Availability Scores',
     col='steelblue')
plot(full$SCORE_QUAL, full$SCORE_SCHED, 
     xlab='CRI Quality Scores', ylab='CRI Schedule Scores',
     col='steelblue')
plot(full$SCORE_QUAL, full$SCORE_REQ, 
     xlab='CRI Quality Scores', ylab='CRI Requirements Scores',
     col='steelblue')
plot(full$SCORE_AVAIL, full$SCORE_SCHED, 
     xlab='CRI Availability Scores', ylab='CRI Schedule Scores',
     col='steelblue')
plot(full$SCORE_AVAIL, full$SCORE_REQ, 
     xlab='CRI Availability Scores', ylab='CRI Requirements Scores',
     col='steelblue')
plot(full$SCORE_SCHED, full$SCORE_REQ, 
     xlab='CRI Schedule Scores', ylab='CRI Requirements Scores',
     col='steelblue')