library('sense')


### bigrf
install.packages('bigrf')
library('bigrf')


### remove old predictions
system('rm output/out*.csv')

# LOAD
# Load Data, training and test
# ---------
# about 16.9M million rows total
columns = c('integer',
            'factor',
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
original_training <- read.csv('train.csv', nrows=200000, colClasses=columns)
str(original_training)
  
# set up parallel
set.seed(8167542)
install.packages('doParallel')
library('doParallel')
registerDoParallel(cores=detectCores())

predictors = c('I4', 'I6', 'I7', 'I8', 'I10', 'I13', 'C6', 'C9', 'C14')
# Run model, grow 100 trees
system.time(forest1 <- bigrfc(original_training[,predictors], original_training[,c(2)], ntree=100L) )
  

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


registerDoParallel(cores=1)
files = c(1:200)
lapply(files, function(x){
    test_file = read.csv(paste('testfiles/test_file-',x,'.csv', sep=''), colClasses=columnsTest)
    print('file read')
    system.time(Predicted <- predict(forest1, test_file[,predictors]) )
    print('predictions done')
    test_file$Predicted = (Predicted@testvotes[,2])/(Predicted@testvotes[,2] + Predicted@testvotes[,1])
    write.table(test_file[, c('Id','Predicted')], paste('output/output-', x, '.csv'), sep=',', row.names=FALSE,col.names=FALSE) 
    print(paste('file-', x, ' has been processed'))
  }
)

# WRITE the output file
system('rm rf_submission*')
system('cat output/* >> rf_submission.csv' )
system('head rf_submission.csv')
zip('rf_submission.zip', c('rf_submission.csv') )
