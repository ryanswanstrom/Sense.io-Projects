

# ### All-subsets Regression

# use this to find the Cp values
install.packages('leaps')
library('leaps')
# only check for columns that we are looking at
x = training_data[,c(3,5,9)]
y = training_data[,10]
models = leaps(x, y)
models

plot(models$size, models$Cp, log = "y", xlab = "# of predictors", ylab = expression(C[p]), main='Cp values by Number of Predictors', col="red", cex=1.5)

minimum <- models$Cp == min(models$Cp)
best.model <- models$which[minimum, ]

x_val = validation_data[,c(3,5,9)]
y_val = validation_data[,10]
models_val = leaps(x_val, y_val)
models_val


install.packages('qpcR')
library('qpcR')  # for PRESS statistic

#calculate the MSRP
msrp = function(actuals, predicted) {
  sum((actuals-predicted)^2)/length(actuals)
}

# print out linear model info
model_info = function(model) {
  print(summary(model))
  #SSE
  SSE = deviance(model)
  print(paste('SSE:', SSE))
  #PRESS
  pr = PRESS(model, verbose=FALSE)
  print(paste('PRESS:', pr$stat))
  #MSE
  MSE = tail(anova(model)$Mean, 1)
  print(paste('MSE:', MSE))
  #R2a
  aR2 = summary(model)$adj.r.squared
  print(paste('Adjusted R^2:', aR2))
  
}

## Model 1: Linear Model with age, numFollowing, and numOfLists

model_1_training = lm(num_of_followers ~ age + num_following + num_of_lists, training_data)
model_info(model_1_training)
print("Cp: 4.0")
# check how closely the model will predict the values in the validation set
predicted_vals = predict(model_1_training, newdata=validation_data)
MSRP = msrp(validation_data$num_of_followers, predicted_vals)
print(paste('MSPR:', MSRP))

# this is for the validation data
model_1_validation = lm(num_of_followers ~ age + num_following + num_of_lists, validation_data)
model_info(model_1_validation)
print("Cp: 4.0")


## Model 2: Linear Model with num_following and num_of_lists


model_2_training = lm(num_of_followers ~ num_following + num_of_lists, training_data)
model_info(model_2_training)
print("Cp: 7.13")
# check how closely the model will predict the values in the validation set
predicted_vals = predict(model_2_training, newdata=validation_data)
MSRP = msrp(validation_data$num_of_followers, predicted_vals)
print(paste('MSPR:', MSRP))

# this is for the validation data
model_2_validation = lm(num_of_followers ~ num_following + num_of_lists, validation_data)
model_info(model_2_validation)
print("Cp: 3.45")


## Model 3: Linear Model with just num_of_lists


model_3_training = lm(num_of_followers ~ num_of_lists, training_data)
model_info(model_3_training)
print("Cp: 5.74")
# check how closely the model will predict the values in the validation set
predicted_vals = predict(model_3_training, newdata=validation_data)
MSRP = msrp(validation_data$num_of_followers, predicted_vals)
print(paste('MSPR:', MSRP))

# this is for the validation data
model_3_validation = lm(num_of_followers ~ num_of_lists, validation_data)
model_info(model_3_validation)
print("Cp: 1.85")


## Model 4: Linear Model with age and num_of_lists

model_4_training = lm(num_of_followers ~ age + num_of_lists, training_data)
model_info(model_4_training)
print("Cp: 3.883")
# check how closely the model will predict the values in the validation set
predicted_vals = predict(model_4_training, newdata=validation_data)
MSRP = msrp(validation_data$num_of_followers, predicted_vals)
print(paste('MSPR:', MSRP))

# this is for the validation data
model_4_validation = lm(num_of_followers ~ age + num_of_lists, validation_data)
model_info(model_4_validation)
print("Cp: 2.66")

### Model Transformation

## Model 5: Linear Model with Log(num_of_followers) and age, num_following, and num_of_lists

#Before running the next model, the Box-Cox method was used to determine if any
#transformations need to be done on the response variable (num_of_followers).
#Box-Cox returns $\lambda  = 0.06$ which is pretty close to 0, so a Log
#of the response was applied.

# run the box cox
model = lm(num_of_followers ~ age + num_following + num_of_lists , data=training_data)
bc = boxcox(model, xlab = expression(lambda), ylab = "log-Likelihood")
max = with(bc, x[which.max(y)])

# create a column for the transformed column
training_data$log_num_of_followers = log(training_data$num_of_followers)
validation_data$log_num_of_followers = log(validation_data$num_of_followers)

# run the model

#m4_error = model_test_function(log_num_of_followers ~ age + num_following + num_of_lists, 1)


## Model 6: Linear Model with num_of_followers^.06 and age, num_following, and num_of_lists

#Also due to the Box-Cox, the num_of_followers were raised to the 0.06 power.  



# transform Y^.06
# create a column for the transformed column
training_data$raise_num_of_followers = training_data$num_of_followers^.06
validation_data$raise_num_of_followers = validation_data$num_of_followers^.06

#m5_error = model_test_function(raise_num_of_followers ~ age + num_following + num_of_lists, 1)


# Initial Conclusions

#Of the initial 5 models, the best predictive power on the validation set belongs to 
#Model 3, the linear model using just the num_of_lists.  However, a few other models
#can be applied.


## Model 6: Robust linear Regression with age, num_following, and num_of_lists

robust_model_6 = rlm(num_of_followers ~ age + num_following + num_of_lists , data=training_data, psi = psi.bisquare, init='lts', maxit=50)
summary(robust_model_6)
predicted_vals = predict(robust_model_6, newdata=validation_data)
m6_error = sum(abs(predicted_vals - validation_data$num_of_followers))/length(predicted_vals)
print(paste('The average prediction error is:', m6_error))


## Model 7: Robust linear Regression with num_following, and num_of_lists

robust_model_7 = rlm(num_of_followers ~ num_following + num_of_lists , data=training_data, psi = psi.bisquare, init='lts', maxit=50)
summary(robust_model_7)
predicted_vals = predict(robust_model_7, newdata=validation_data)
m7_error = sum(abs(predicted_vals - validation_data$num_of_followers))/length(predicted_vals)
print(paste('The average prediction error is:', m7_error))


## Model 8: Robust linear Regression with num_following, and num_of_lists

#Robust Regression is less sensitive to outliers than ordinary least squares regression.  

robust_model_8 = rlm(num_of_followers ~ num_following + num_of_lists , data=training_data, psi = psi.bisquare, init='lts', maxit=50)
summary(robust_model_8)
predicted_vals = predict(robust_model_8, newdata=validation_data)
m8_error = sum(abs(predicted_vals - validation_data$num_of_followers))/length(predicted_vals)
print(paste('The average prediction error is:', m8_error))


## Model 9: Decision Tree

install.packages('tree')
library('tree')
regtree = tree(num_of_followers ~ age + num_of_tweets + num_following + num_of_favorites + num_of_lists + as.factor(has_profile), data = training_data)
summary(regtree)
predicted_vals = predict(regtree, newdata=validation_data)
m9_error = sum(abs(predicted_vals - validation_data$num_of_followers))/length(predicted_vals)
print(paste('The average prediction error is:', m9_error))


## Model 10: Quantile Regression
# TODO: Add something here
  
  
# Further Conclusion
#Model 1 is chosen as the best model, so it can be rebuilt with all the data.



final_model = lm(num_of_followers ~ age + num_following + num_of_lists , data=full_data)
summary(final_model)
confint(final_model)
