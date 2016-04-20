# Setup
# -----
#
# The [sense library](https://github.com/SensePlatform/sense-r-module) includes
# a number of helper functions you can use from within R dashboards.

library('sense')

# [ggplot2](http://ggplot2.org/) is a great way to make pretty graphs.

#library('ggplot2')

# Load Data, training and test
# ---------
# about 16.9M million rows total
columns = c('integer',
            'integer',
            'integer',
            'integer',
            'integer',
            'integer',
            'integer',
            'integer',
            'integer',
            'integer',
            'integer',
            'factor',
            'integer',
            'integer',
            'integer',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor')
display_ad_training <- read.csv('train.csv', nrow=80000, colClasses=columns)
str(display_ad_training)
#as.factor(display_ad_training$I10)


#hist(display_ad_training$I1[!is.na(display_ad_training$I1) ] )
#plot(display_ad_training$I5, display_ad_training$I3 )
#pairs(display_ad_training[, c('I1','I2','I3','I4','I5')] )
#pairs(display_ad_training[, c('I6','I7','I8','I9','I10')] )
#pairs(display_ad_training[, c('I11','I12','I13')] )

# C1 + C2 + C5 + C6 + C7 + C8 + C9 + C11 + C13 + C14 + C15 + C17 + C18 + C19 + C20 + C22 + C23 + C25
display_ad_md = glm(Label ~ + I4 + I6 + I7 + I8 + I10 + I13 + C1 + C2, data=display_ad_training, family=binomial)
summary(display_ad_md)

columnsTest = c('integer',
            'integer',
            'integer',
            'integer',
            'integer',
            'integer',
            'integer',
            'integer',
            'integer',
            'integer',
            'factor',
            'integer',
            'integer',
            'integer',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor',
            'factor')
display_ad_test = read.csv('test.csv', colClasses=columnsTest)
str(display_ad_test)

# Set null values to column median
display_ad_test$I4[is.na(display_ad_test$I4)] <- median(display_ad_test$I4, na.rm=TRUE)
display_ad_test$I6[is.na(display_ad_test$I6)] <- median(display_ad_test$I6, na.rm=TRUE)
display_ad_test$I7[is.na(display_ad_test$I7)] <- median(display_ad_test$I7, na.rm=TRUE)
display_ad_test$I8[is.na(display_ad_test$I8)] <- median(display_ad_test$I8, na.rm=TRUE)
display_ad_test$I13[is.na(display_ad_test$I13)] <- median(display_ad_test$I13, na.rm=TRUE)

display_ad_test$I10[ !is.element(display_ad_test$I10, levels(display_ad_training$I10) )] <- levels(display_ad_training$I10)[1]
display_ad_test$I10 = factor(display_ad_test$I10)

display_ad_test$C1[ !is.element(display_ad_test$C1, levels(display_ad_training$C1) )] <- levels(display_ad_training$C1)[1]
display_ad_test$C1 = factor(display_ad_test$C1)
display_ad_test$C2[ !is.element(display_ad_test$C2, levels(display_ad_training$C2) )] <- levels(display_ad_training$C2)[1]
display_ad_test$C2 = factor(display_ad_test$C2)

# run model on test data
display_ad_test$Predicted = predict(display_ad_md, newdata=display_ad_test, type = "response")

nrow(display_ad_test)
sum(is.na(display_ad_test$Predicted))
display_ad_test$Predicted[is.na(display_ad_test$Predicted)] <- .5

#colSums(is.na(display_ad_test))
write.csv(display_ad_test[, c('Id','Predicted')], file="glm_submission.csv",row.names=FALSE)
zip('glm_submission.zip', c('glm_submission.csv') )

