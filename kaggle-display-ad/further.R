library('sense')

# LOAD
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
original_training <- read.csv('train.csv', nrows=50000, colClasses=columns)
str(original_training)

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
original_test = read.csv('test.csv', colClasses=columnsTest)
str(original_test)

# CLEAN
# clean up training data
display_ad_training = original_training
#   Set null values to column median
display_ad_training$I4[is.na(display_ad_training$I4)] <- median(display_ad_training$I4, na.rm=TRUE)
display_ad_training$I6[is.na(display_ad_training$I6)] <- median(display_ad_training$I6, na.rm=TRUE)
display_ad_training$I7[is.na(display_ad_training$I7)] <- median(display_ad_training$I7, na.rm=TRUE)
display_ad_training$I8[is.na(display_ad_training$I8)] <- median(display_ad_training$I8, na.rm=TRUE)
display_ad_training$I13[is.na(display_ad_training$I13)] <- median(display_ad_training$I13, na.rm=TRUE)

# clean up the test data
display_ad_test = original_test
#    Set null values to column median
display_ad_test$I4[is.na(display_ad_test$I4)] <- median(display_ad_test$I4, na.rm=TRUE)
display_ad_test$I6[is.na(display_ad_test$I6)] <- median(display_ad_test$I6, na.rm=TRUE)
display_ad_test$I7[is.na(display_ad_test$I7)] <- median(display_ad_test$I7, na.rm=TRUE)
display_ad_test$I8[is.na(display_ad_test$I8)] <- median(display_ad_test$I8, na.rm=TRUE)
display_ad_test$I13[is.na(display_ad_test$I13)] <- median(display_ad_test$I13, na.rm=TRUE)





display_ad_md = glm(Label ~ I4 + I6 + I7 + I8 + I10 + I13 + C6  + C9 + C13 + C14 + C17 + C20 + C22 + C23 + C25, data=display_ad_training, family=binomial)
summary(display_ad_md)

display_ad_test$I10[ !is.element(display_ad_test$I10, levels(display_ad_training$I10) )] <- levels(display_ad_training$I10)[1]
display_ad_test$I10 = factor(display_ad_test$I10)

display_ad_test$C5[ !is.element(display_ad_test$C5, levels(display_ad_training$C5) )] <- levels(display_ad_training$C5)[1]
display_ad_test$C6[ !is.element(display_ad_test$C6, levels(display_ad_training$C6) )] <- levels(display_ad_training$C6)[1]
display_ad_test$C8[ !is.element(display_ad_test$C8, levels(display_ad_training$C8) )] <- levels(display_ad_training$C8)[1]
display_ad_test$C9[ !is.element(display_ad_test$C9, levels(display_ad_training$C9) )] <- levels(display_ad_training$C9)[1]
display_ad_test$C13[ !is.element(display_ad_test$C13, levels(display_ad_training$C13) )] <- levels(display_ad_training$C13)[1]

display_ad_test$C14[ !is.element(display_ad_test$C14, levels(display_ad_training$C14) )] <- levels(display_ad_training$C14)[1]
display_ad_test$C17[ !is.element(display_ad_test$C17, levels(display_ad_training$C17) )] <- levels(display_ad_training$C17)[1]
display_ad_test$C20[ !is.element(display_ad_test$C20, levels(display_ad_training$C20) )] <- levels(display_ad_training$C20)[1]
display_ad_test$C22[ !is.element(display_ad_test$C22, levels(display_ad_training$C22) )] <- levels(display_ad_training$C22)[1]
display_ad_test$C23[ !is.element(display_ad_test$C23, levels(display_ad_training$C23) )] <- levels(display_ad_training$C23)[1]
display_ad_test$C25[ !is.element(display_ad_test$C25, levels(display_ad_training$C25) )] <- levels(display_ad_training$C25)[1]

# not enough of that factor variable
#display_ad_test$C22[ is.element(display_ad_test$C22, c('d9ce1838') )] <- levels(display_ad_training$C22)[1]
#display_ad_test$C25[ is.element(display_ad_test$C25, c('98419e90') )] <- levels(display_ad_training$C25)[1]

display_ad_test = droplevels(display_ad_test)

display_ad_test$Predicted = predict(display_ad_md, newdata=display_ad_test, type = "response")

#nrow(display_ad_test)
sum(is.na(display_ad_test$Predicted))
display_ad_test$Predicted[is.na(display_ad_test$Predicted)] <- .5

#colSums(is.na(display_ad_test))
write.csv(display_ad_test[, c('Id','Predicted')], file="glm_submission.csv",row.names=FALSE)
zip('glm_submission.zip', c('glm_submission.csv') )
