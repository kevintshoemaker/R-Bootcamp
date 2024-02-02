
#  R Bootcamp #2, module 2.3 -----------------------------              
#     University of Nevada, Reno             
#     Topic: basic statistics 


# STATISTICS! ------------------

#  Load Data ------------------

sculpin.df <- read.csv("sculpineggs.csv")

head(sculpin.df)


# Summary Statistics ------------------

mean(sculpin.df$NUMEGGS)      # compute sample mean
median(sculpin.df$NUMEGGS)    # compute sample median

min(sculpin.df$NUMEGGS)       # sample minimum
max(sculpin.df$NUMEGGS)       # sample maximum
range(sculpin.df$NUMEGGS)     # both min and max.

quantile(sculpin.df$NUMEGGS,0.5)            # compute sample median using quantile function
quantile(sculpin.df$NUMEGGS,c(0.25,0.75))   # compute sample quartiles

var(sculpin.df$NUMEGGS)           # sample variance
sd(sculpin.df$NUMEGGS)            # sample standard deviation
sd(sculpin.df$NUMEGGS)^2          # another way to compute variance

apply(sculpin.df,2,mean)       # column means of data frame 
apply(sculpin.df,2,median)     # column medians of data frame

# maybe you'd like to use some tidyverse functions instead:

sculpin.df %>% summarize(across(everything(),mean) ) 

########
# Or just use the "summary()" function!

summary(sculpin.df) # provides a set of summary statistics for all columns in a data frame. 



# Deal with missing data --------------

newdf <- read.table(file="data_missing.txt", sep="\t", header=T)  # load dataset with missing data

mean(newdf$Export)

mean(newdf$Export,na.rm = TRUE)


#  Plot data  (base R)
# 
# hist(sculpin.df$NUMEGGS)
# plot(x = sculpin.df$FEMWT,y = sculpin.df$NUMEGGS)

#  Ggplot alternative:

ggplot(sculpin.df,aes(NUMEGGS)) + geom_histogram(bins=5)
ggplot(sculpin.df,aes(FEMWT,NUMEGGS)) + geom_point()


#  Linear Regression   -------------------

m1 <- lm(NUMEGGS ~ FEMWT, data=sculpin.df)      # fit linear regression model

summary(m1)                             # view model summary
summary(m1)$r.squared                   # extract R-squared
confint(m1)                             # confidence intervals for intercept and slope
AIC(m1)                                 # report AIC (Akaike's Information Criterion, used to perform model selection) 

plot(x = sculpin.df$FEMWT,y = sculpin.df$NUMEGGS)    # plot data
abline(m1)                                           # plot line of best fit

# Use the "predict()" function! --------------

nd <- data.frame(FEMWT = 30)                   # create new data frame to predict number of eggs at FEMWT of 30
predict(m1,newdata=nd)                         # make prediction
predict(m1,newdata=nd,interval="confidence")   # make prediction and get confidence interval
predict(m1,newdata=nd,interval="prediction")   # make prediction and get prediction interval



#  Explore the use of the "I()" syntax to interpret mathematical expressions literally (as is) within formulas. 

mod_noI <- lm(NUMEGGS ~ FEMWT^2, data=sculpin.df)                  # fit linear regression model. But the "^2" doesn't seem to do anything here? What happened?
summary(mod_noI)

mod_withI <- lm(NUMEGGS ~ I(FEMWT^2), data=sculpin.df)                  # fit linear regression model
summary(mod_withI)

# try a model with a polynomial fit
mod_withpoly <- lm(NUMEGGS ~ poly(FEMWT,2),data=sculpin.df)
summary(mod_withpoly)

# try a log transformation on the response:

mod_logtrans <- lm(log(NUMEGGS) ~ FEMWT, data=sculpin.df) 
summary(mod_logtrans)


#  Model selection example -------------------

m1 <- lm(NUMEGGS ~ FEMWT, data=sculpin.df)                  # fit linear regression model
summary(m1)

m2 <- lm(NUMEGGS ~ 1, data=sculpin.df)                      # fit linear regression with intercept only (null model)
summary(m2)

m3 <- lm(NUMEGGS ~ poly(FEMWT,2), data=sculpin.df)           # fit polynomial regression
summary(m3)


plot(NUMEGGS ~ FEMWT,data=sculpin.df)                      # plot data
abline(m1,col="black")                                     # plot line of best fit
abline(m2,col="red")                                       # plot intercept only model

# Use 'predict' to draw lines on scatterplot  -----------------
#  Here's a flexible method for drawing any arbitrary modeled relationship!
nd <- data.frame(FEMWT = seq(10,45,by=0.1))        # create new data frame to predict number of eggs from FEMWT of 10 to 45 by increments of 0.1
NUMEGGS.pred <- predict(m3,newdata=nd,interval="confidence")             # make prediction using "predict()" function
lines(nd$FEMWT,NUMEGGS.pred[,1],col="green")  # plot sqrt model (note the use of the "lines()" function to draw a line!)

# some of you might want to try recreating this plot using gglot!

# Perform model selection! -------------

#Compare models using AIC
AIC(m1)
AIC(m2)
AIC(m3)

# which model has the lowest AIC?

#  And finally, here's how you can draw a confidence interval or prediction interval around a non-linear regression relationship!

plot(NUMEGGS ~ FEMWT,data=sculpin.df)                      # plot data
NUMEGGS.confint <- predict(m3,newdata=nd,interval="confidence")             # use "predict()" function to compute the confidence interval!
lines(nd$FEMWT,NUMEGGS.confint[,"fit"],col="green",typ="l",lwd=2)  # plot fitted sqrt model
lines(nd$FEMWT,NUMEGGS.confint[,"lwr"],col="green",typ="l",lty=2)  # plot fitted sqrt model
lines(nd$FEMWT,NUMEGGS.confint[,"upr"],col="green",typ="l",lty=2)  # plot fitted sqrt model


# alternative using ggplot:
NUMEGGS.confint2 <- as_tibble(cbind(nd,NUMEGGS.confint))
ggplot() %>% +
  geom_point(data=sculpin.df,mapping=aes(FEMWT,NUMEGGS)) +
  geom_path(data=NUMEGGS.confint2,aes(x=FEMWT,y=fit)) +
  geom_ribbon(data=NUMEGGS.confint2,aes(x=FEMWT,ymin=lwr,ymax=upr),alpha=0.5)



# CHALLENGE EXERCISES   -------------------------------------

#1. Fit a polynomial regression model with NUMEGGS as the response and `poly(FEMWT,3)` as the response. Plot the results by overlaying the regression line on a scatterplot using ggplot2.
#
#2. Use the model you built in part 1 to predict the number of eggs for FEMWT=5. What is the 95% confidence interval around this prediction? Is this prediction biologically reasonable?



