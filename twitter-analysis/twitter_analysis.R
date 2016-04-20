# ## Exploratory Analysis

#Obviously more can be added here.  About the only thing to note here is
#the **has_pic** column contains only a single value that is different
#from the rest.  Thus **has_pic** will not be included in the analysis.

library('sense')
#read in the files
set.seed(78432)
training_data = read.csv('twitter_data_training.csv')
validation_data = read.csv('twitter_data_test.csv')
full_data = read.csv('twitter_data.csv')
summary(training_data)

#pairs(training_data[3:10])

# ##Outliers

#When looking at the num_following versus the num_of_lists plot, there
#appear to be a few outliers.  Thus, the user with the very high num_following
#and the users with the very high num_of_lists were removed.  Therefore, the
#training set now contains 597 users instead of 600 users. Also, the analysis is
#not included here, but the models performed the same or better with the outliers
#removed.

cols <- ifelse(training_data$num_following > 20000 | training_data$num_of_lists > 5000, "firebrick", "steelblue")
plot(training_data$num_of_lists, training_data$num_following, col=cols, pch=20, cex=1.5)

training_data=training_data[training_data$num_following < 20000 & training_data$num_of_lists < 5000 ,]
dim(training_data) # new dimensions
plot(training_data$num_of_lists, training_data$num_following, col='steelblue', pch=20, cex=1.5)


# ##Analysis

#First, a linear model with all the predictors was created.
#The full linear model identified the following predictors as
#significant: age, num_following, and num_of_lists. Then backwards
#step-wise regression was performed and the best fitting model
#was identified as the model containing the same predictors 
#as the linear model previously mentioned.  

#The Box-Cox method was used to determine if any transformations needed to be performed 
#on the response variable.  As can be seen in the Box-Cox plot, the maximum value occurred at 0.06.  Due to that value, two separate
#transformations were performed.  The first transformation took the natural log of the
#dependent variable.  The second transformation involved raising the dependent variable 
#to the exponent, 0.06.  Neither of these transformations yielded promising results, so the
#detailed analysis is not included in this report.  

#Next, all-subsets regression was performed using the _leaps_ package
#in the R programming language.  The _leaps_ package will perform
#an exhaustive search of all possible subsets of the variables in
#order to find the best fitting models based upon the Mallows' Cp Criterion.
#As can be seen in the output plot, four models appeared to have low Cp values
#as compared to the rest.  Not surprisingly, the four models contain
#different combinations of the 3 predictors already identified, including the
#model indentified by the step-wise regression.  For these reasons and the reasons above, the four
#models with the lowest Cp values will be compared to determine the best model.

#Here are the 4 candidate models being considered.  

# ### Model 1
# $$numOfFollowers = \beta_0 + \beta_1 \cdot age + \beta_2 \cdot numFollowing + \beta_3 \cdot numOfLists$$

# ### Model 2
# $$ numOfFollowers = \beta_0 + \beta_2 \cdot numFollowing + \beta_3*numOfLists$$

# ### Model 3
# $$numOfFollowers = \beta_0 + \beta_3*numOfLists$$

# ### Model 4
# $$numOfFollowers = \beta_0 + \beta_1 \cdot age + \beta_3*numOfLists$$

# ##Best Model

#First look at the PRESS statistic.  A PRESS statistic reasonably close to the
#SSE supports the validity of a linear regression model.  As can be seen in
#the table, all four candidate models have a PRESS statistic reasonably close
#to the SSE.  

#Next look at the Mallows' $C_p$ value.  A lower $C_p$ value is better, in particular,
#the $C_p$ value should be less than p (number of predictors + 1 for the intercept).  Also
#a $C_p$ value equal to p indicates a model with no bias.  Therefore, it is advantageous
#to find a $C_p$ near p.  Model 4 has the lowest overall $C_p$ value, but for Model 4 the p is 3, 
#making the $C_p$ value greater than p.  Only Model 1 has a $C_p$ less than or equal to p.  Model
#1 has a $C_p = 4$ and $p = 4$.  Thus, Mallows' $C_p$ would favor Model 1.

#Finally, look at the MSRP (Mean Squared Prediction Error) for the four models.  A lower value
#indicates more predictive power.  Model 1 has the lowest value of the four models,
#so MSRP favors Model 1 as well.

#Overall, Model 1 appears to be the best predictive model for the twitter data.
#Model 1 was then recreated using all the available data, not just the training
#data.  The final model for predicting the number of followers of a twitter
#user in the top 1000 for the search term 'data' is:

# $$numOfFollowers = 898 - 1.5 \cdot age + .8 \cdot numFollowing + 28.1 \cdot numOfLists$$

#Here is how the final model can be interpreted. Given a new account following 0 users
#and not it any lists, a twitter user in the top 1000 would be expected to have 898 followers.
#At first this seems ridulous.  Why would a user have any followers without any activity
#and a brand new account.  Remember, that this data is for twitter users in the top 1000, so 
#for a new twitter account to appear in the top 1000, it is likely the person/organization that
#created the account is already influential outside of twitter.  Think about a celebrity
#creating a twitter account. The account will quickly start attracting followers 
#with the anticipation of future activity.

#All other factors remaining the same,
#an increase in the age of the account by 1 day results in a decrease in the number 
#of followers by 1.5.  Thus having a twitter account for longer does not appear to increase
#followers.  Also, when the other predictors remain the same, for every 1 user an 
#account follows, it will result in .8 new followers. Another way to look at that is: keeping everything else the same, following 10 more people will result in 8 more followers.

#With the rest of the predictors remaining the same, being included in 1 more list results
#in 28.1 more followers.  Thus being in lists is the most influential predictor of followers.
#This makes sense considering the data is associated with the top 1000 and being in more lists means being more influential.  

#One interesting area of future research would be generalizing this model to work with other search terms.
#Does the same model still work well or do different terms need different models? 
#How do search terms based upon trending topics have an affect?

# ##Conclusions

#It is possible to predict the number of followers for a twitter user in the top 1000 based
#upon the search term "data".  It appears the age of the account, the number of twitter users 
#the account is following, and the number of lists including the account are all 
#correlated with the number of followers for an account in the top 1000 twitter users
#for the search term "data".  For those that are familiar with twitter,
#it is not surprising that the number of tweets
#does not appear to be correlated with the number of followers.  Thus, tweeting
#more is not helpful for getting more followers.  Also, having a profile does not
#appear to be connected with the number of followers either.  

#Surprisingly, 
#the quality of tweets does not appear to be correlated with the number of followers
#either.  Number of tweets that have been favorited would be an indicator
#of the quality of the tweets.  More favorites would appear to indicate more
#quality tweets.  However, having more or less quality tweets does not 
#appear to be correlated with the total number of followers. 


# ##R code

basic_model = lm(num_of_followers ~ age + num_of_tweets + num_following + num_of_favorites + num_of_lists + as.factor(has_profile), data=training_data)
summary(basic_model)

# ### Stepwise Regression
library('MASS')
step <- stepAIC(basic_model, direction="backward") # forward, backward, or both
step$anova # display results 

