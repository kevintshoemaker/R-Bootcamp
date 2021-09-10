
##################################################
####                                          ####  
####  R Bootcamp #1, Module 3                 ####
####                                          #### 
####   University of Nevada, Reno             ####
####                                          #### 
##################################################

## NOTE: this module borrows heavily from an R short-course developed by a team at Colorado State University. 
   # Thanks to Perry Williams for allowing us to use these materials!!
   # Thanks to John Tipton at CSU for developing much of this module (plotting in R)!

############################################
####  Data visualization and statistics ####
############################################


# ?trees      # description of built in dataset  (uncomment to run)

dim(trees)   # Show the dimension of the trees dataframe                                              

str(trees)   # Show the structure of the trees dataframe

head(trees)   # Show the first few observations of the trees dataframe


# Access the columns 
trees$Girth     
trees$Volume


plot(x=trees$Girth, y=trees$Volume)    # use R's built-in "trees" dataset: ?trees


?par

par()   # view the default graphical parameters (can be kind of overwhelming!)


# Use "layout" to define a 2 row x 2 column matrix with elements 1, 2, 3, and 4.
# This divides the image into four sections and then fills these with the plot function
layout(matrix(1:4, nrow=2, ncol=2))

# layout.show(4)   # uncomment to run

  # par(mfrow=c(2,2))  # (alternative way to do this)

plot(x=trees$Girth, y=trees$Volume)             # points
plot(x=trees$Girth, y=trees$Volume, type="l")   # lines
plot(x=trees$Girth, y=trees$Volume, type="b")   # both
plot(x=trees$Girth, y=trees$Volume, type="o")   # both with conected lines


plot(x=trees$Girth, y=trees$Volume)             ## The plot is still in 4 parts

graphics.off()                                  ## now the plot is reset!

# layout(1)   # (alternative way to reset back to a single plot)

plot(x=trees$Girth, y=trees$Volume)             ## The plot is still in 4 parts



# Use layout to define a 3 row x 1 column matrix with elements 1, 2, and 3.
# This divides the image into three sections and then fills these with the plot function
layout(matrix(1:3, nrow=3, ncol=1))

# pch: 'plotting character' changes the type of point that is used (default is an open circle)!
plot(x=trees$Girth, y=trees$Volume, pch=19)     # filled point
plot(x=trees$Girth, y=trees$Volume, pch=2)      # open triangle
plot(x=trees$Girth, y=trees$Volume, pch=11)     # star


layout(matrix(1:4, 2, 2))
# main: adds a title
plot(x=trees$Girth, y=trees$Volume, pch=19, 
     main="Girth vs. Volume for Black Cherry Trees")

# xlab: adds an x axis label
plot(x=trees$Girth, y=trees$Volume, pch=19, 
     main="Girth vs. Volume for Black Cherry Trees", 
     xlab="Tree Girth (in)")

# ylab: adds a y axis label
plot(x=trees$Girth, y=trees$Volume, pch=19, 
     main="Girth vs. Volume for Black Cherry Trees", 
     xlab="Tree Girth (in)", ylab="Tree Volume (cu ft)")

# las: rotates axis labels; las=1 makes them all parallel to reading direction
plot(x=trees$Girth, y=trees$Volume, pch=19, 
     main="Girth vs. Volume for Black Cherry Trees", 
     xlab="Tree Girth (in)", ylab="Tree Volume (cu ft)", 
     las=1)


# Use layout to define a 2 row x 2 column matrix with elements 1, 1, 2, and 3.
# This divides the image into four sections but fills the first two sections
# with the first plot and then fills these next two sections with the final two plots
layout(matrix(c(1, 1, 2, 3), nrow=2, ncol=2))

# col: select a color for the plotting characters
plot(x=trees$Girth, y=trees$Volume, pch=19, 
     main="Girth vs. Volume for Black Cherry Trees",
     xlab="Tree Girth (in)", ylab="Tree Volume (cu ft)",
     las=1, col="blue")

# We can use the c() function to make a vector and have several colors, plotting characters, etc. per plot.
# We start with alternating colors for each point
plot(x=trees$Girth, y=trees$Volume, pch=19, 
     main="Girth vs. Volume for Black Cherry Trees",
     xlab="Tree Girth (in)", ylab="Tree Volume (cu ft)", 
     las=1, col=c("black", "blue"))

# And we can also alternate the plotting symbol at each point.
plot(x=trees$Girth, y=trees$Volume, pch=c(1,19), 
     main="Girth vs. Volume for Black Cherry Trees", 
     xlab="Tree Girth (in)", ylab="Tree Volume (cu ft)", 
     las=1, col="blue")


?iris
head(iris)     # display first few rows of data
dim(iris)      # dimensionality of the data
str(iris)      # details of the data structure


plot.colors <- c("violet", "purple", "blue")   # define the colors for representing species ID


color.vector <- rep(x=plot.colors, each=50)
color.vector
## color vector is now a list of our colors, each repeated 50 times

plot(x=iris$Petal.Length, y=iris$Sepal.Length, pch=19, col=color.vector, 
     main="Plot of Iris colored by species")


names(plot.colors) <- levels(iris$Species)   # the "levels()" function returns all unique labels for any "factor" variable    
plot.colors


# generate a vector of colors for our plot (one color for each observation)

indices <- match(iris$Species,names(plot.colors))   # the "match()" function goes through each element of the first vector and finds the matching index in the second vector         
color.vector2 <- plot.colors[indices]



plot(x=iris$Petal.Length, y=iris$Sepal.Length, pch=19, col=color.vector2, 
     main="Iris sepal length vs. petal length", xlab="Petal length", 
     ylab="Sepal length", las=1)


# make a new version of the iris data frame that is neither in order nor has the same number of observations for each species (to illustrate generality of the new method)

iris2 <- iris[sample(1:nrow(iris),replace = T),]   # use the "sample()" function to create a randomized ("bootstrapped") version of the iris data frame

# now repeat the above steps:

indices <- match(iris2$Species,names(plot.colors))   # the "match()" function returns the indices of the first vector that match the second vector   
color.vector2 <- plot.colors[indices]
plot(x=iris2$Petal.Length, y=iris2$Sepal.Length, pch=19, col=color.vector2, 
     main="Iris sepal length vs. petal length", xlab="Petal length", 
     ylab="Sepal length", las=1)


## The old method is NOT general:

color.vector <- rep(x=plot.colors, each=50)
plot(x=iris2$Petal.Length, y=iris2$Sepal.Length, pch=19, col=color.vector, 
     main="Plot of Iris colored by species (not!)")

########
# experiment with legends

# ?legend

layout(matrix(1:3, nrow=1, ncol=3))

# Plot
plot(x=iris$Petal.Length, y=iris$Sepal.Length, pch=19, col=color.vector, 
     main="Iris sepal length vs. petal length", xlab="Petal length", 
     ylab="Sepal length", las=1)

# First legend
legend("topleft", pch=19, col=plot.colors, legend=unique(iris$Species))

# Second plot
plot(x=iris$Petal.Length, y=iris$Sepal.Length, pch=19, col=color.vector,
     main="Iris sepal length vs. petal length", 
     xlab="Petal length", ylab="Sepal length", las=1)

# Second legend
# The bty="n" argument suppresses the border around the legend. (A personal preference)
legend("topleft", pch=19, col=plot.colors, 
       legend=c("I. setosa", "I. versicolor", "I. virginica"), bty="n")


# Plot Three
plot(x=iris$Petal.Length, y=iris$Sepal.Length, pch=19, col=color.vector, 
     main="Iris sepal length vs. petal length", 
     xlab="Petal length", ylab="Sepal length", las=1)

#Legend tree with Italics
legend("topleft", pch=19, col=plot.colors, 
       legend=c("I. setosa", "I. versicolor", "I. virginica"), 
       bty="n", text.font=3)


## Diplaying gradients (continuous data) using color and size

?mtcars

head(mtcars)


## Plot fuel economy by weight

plot(mpg~wt,  data=mtcars,pch=20,xlab="Vehicle weight (1000 lbs)",ylab="Fuel economy (mpg)")      # note the tilde, which can be read "as a function of" -- i.e., "plot mpg as a function of wt"   
 

## Plot fuel economy by weight and horsepower

hp_rescale <- with(mtcars,(hp-min(hp))/diff(range(hp)))    # scale from 0 to 1

plot(mpg~wt,  data=mtcars,pch=1,xlab="Vehicle weight (1000 lbs)",ylab="Fuel economy (mpg)",cex=(hp_rescale+0.6)*1.2)   # plot with different sized points

legend("topright",pch=c(1,1),pt.cex=c(0.6,0.6*1.2),legend=paste(range(mtcars$hp),"horsepower"),bty="n")


 

## Plot fuel economy by weight and horsepower again- this time by color

colramp <- terrain.colors(125)

colindex <- round(hp_rescale*99+1)

plot(mpg~wt,  data=mtcars,pch=20,cex=2,xlab="Vehicle weight (1000 lbs)",ylab="Fuel economy (mpg)",col=colramp[colindex])   # plot with different sized points

legend("topright",pch=c(20,20),pt.cex=c(2,2),col=c(colramp[1],colramp[100]),legend=paste(range(mtcars$hp),"horsepower"),bty="n")


 

## calculate the mean Sepal Length of for each species
bar.heights <- tapply(iris$Sepal.Length, iris$Species, mean)   #use "tapply()" function, which summarizes a numeric variable by levels of a categorical variable)

# The basic 'barplot()' function
barplot(bar.heights)


# Let's add some flair
barplot(bar.heights, names.arg=c("I. setosa", "I. versicolor", "I. virginica"), 
        las=1, col=adjustcolor(plot.colors, alpha.f=0.5),
        main="Sepal length for 3 Irises", ylab="Sepal length (cm)")


CI <- 2 * tapply(iris$Sepal.Length, iris$Species, sd)
lwr <- bar.heights - CI
upr <- bar.heights + CI

# I used the ylim= argument to pass a 2-element numeric vector specifying the y extent of the barplot (y axis lower and upper bounds). I added some extra room on the top to account for error bars.
# Importantly, assign the barplot to an object. I called it 'b' but you can call it whatever you like. (otherwise, it's hard to know what the "X" values of the error bars are!)

b <- barplot(bar.heights, 
             names.arg=c("I. setosa", "I. versicolor", "I. virginica"), 
             las=1, ylim=c(0,8), col=adjustcolor(plot.colors, alpha.f=0.5),
             main="Sepal length for 3 Irises", ylab="Sepal length (cm)")

# Specify where each arrow starts (x0= and y0=) and ends (x1= and y1=)
arrows(x0=b, x1=b, y0=lwr, y1=upr, code=3, angle=90, length=0.1)

# ?arrows


layout(matrix(1:2, 1, 2))

## y-axis is in counts by default (total observations in each "bin")
hist(iris$Sepal.Length, main="Histogram of Sepal Length",
     xlab = "Sepal Length")

## change y-axis to proportions of the entire dataset using freq=FALSE
hist(iris$Sepal.Length, freq=FALSE, main="Histogram of Sepal Length", 
     xlab = "Sepal Length")
## Add a density estimator

lines(density(iris$Sepal.Length))   # add a line to the histogram to approximate the probability density of the data distribution
curve(dnorm(x,mean(iris$Sepal.Length),sd(iris$Sepal.Length)),add=T,col="red",lty=3)   # add a normal distribution


pairs(iris)


?ToothGrowth
head(ToothGrowth)


prop <- c(0.18, 0.25, 0.13, 0.05)
asympLCL <- c(0.14, 0.20, 0.11, 0.035)
asympUCL <- c(0.24, 0.33, 0.18, 0.09)


set.seed(13)
n <- 20 # Number of experimental trials
a <- 12
b <- 1.5

rings <- round(runif(n)*50)  # number of bell rings
wings <- round(a + b*rings + rnorm(n, sd=5))       # number of angels who get their wings
offset <- rpois(n, lambda=10)           # measurement error
lwr <- wings - offset                 
upr <- wings + offset


####################
# STATISTICS!
####################

#####
#####  Load Data
#####

sculpin.df <- read.csv("sculpineggs.csv")

head(sculpin.df)


#####
#####  Summary Statistics
#####

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
var(sculpin.df$NUMEGGS)^0.5       # another way to compute std. dev.

colMeans(sculpin.df)           # column mean of data frame
apply(sculpin.df,2,mean)       # column mean of data frame   # note the use of the "apply()" function. 
apply(sculpin.df,2,median)     # column median of data frame


########
# Or just use the "summary()" function!

summary(sculpin.df) # provides a set of summary statistics for all columns in a data frame. 



###########
# Deal with missing data

newdf <- read.table(file="data_missing.txt", sep="\t", header=T)  # load dataset with missing data

mean(newdf$Export)

mean(newdf$Export,na.rm = TRUE)


#####
#####  Plot data 
#####

hist(sculpin.df$NUMEGGS)

plot(x = sculpin.df$FEMWT,y = sculpin.df$NUMEGGS)


#####
#####  Linear Regression  
#####

m1 <- lm(NUMEGGS ~ FEMWT, data=sculpin.df)      # fit linear regression model

m1                                      # view estimates of intercept and slope 
summary(m1)                             # view summary of fit
summary(m1)$r.squared                   # extract R-squared
confint(m1)                             # confidence intervals for intercept and slope
AIC(m1)                                 # report AIC (Akaike's Information Criterion, used to perform model selection) 

plot(x = sculpin.df$FEMWT,y = sculpin.df$NUMEGGS)    # plot data
abline(m1)                                           # plot line of best fit

########
# Use the "predict()" function!

FEMWT.pred <- data.frame(FEMWT = 30)                   # create new data frame to predict number of eggs at FEMWT of 30
predict(m1,newdata=FEMWT.pred)                         # make prediction
predict(m1,newdata=FEMWT.pred,interval="confidence")   # make prediction and get confidence interval
predict(m1,newdata=FEMWT.pred,interval="prediction")   # make prediction and get prediction interval



##########
#  Explore the use of the "I()" syntax to interpret mathematical expressions literally (as is) within formulas. 

mod_noI <- lm(NUMEGGS ~ FEMWT^2, data=sculpin.df)                  # fit linear regression model. But the "^2" doesn't seem to do anything here? What happened?
summary(mod_noI)

mod_withI <- lm(NUMEGGS ~ I(FEMWT^2), data=sculpin.df)                  # fit linear regression model
summary(mod_withI)


##################################
####  Model selection example ####
##################################

## Try to work through these examples and make sure you understand them before moving on to the challenge exercises.

m1 <- lm(NUMEGGS ~ FEMWT, data=sculpin.df)                  # fit linear regression model
summary(m1)

m2 <- lm(NUMEGGS ~ 1, data=sculpin.df)                      # fit linear regression with intercept only (mean model)
summary(m2)

m3 <- lm(NUMEGGS ~ I(FEMWT^0.5), data=sculpin.df)           # fit linear regression with intercept and sqrt of FEMWT term
summary(m3)


plot(NUMEGGS ~ FEMWT,data=sculpin.df)                      # plot data
abline(m1,col="black")                                     # plot line of best fit
abline(m2,col="red")                                       # plot intercept only model

#########
#  Here's a flexible method for drawing any arbitrary non-linear relationship!
FEMWT.pred <- data.frame(FEMWT = seq(10,45,by=0.1))        # create new data frame to predict number of eggs from FEMWT of 10 to 45 by increments of 0.1
NUMEGGS.pred <- predict(m3,newdata=FEMWT.pred)             # make prediction using "predict()" function
lines(FEMWT.pred$FEMWT,NUMEGGS.pred,col="green")  # plot sqrt model (note the use of the "lines()" function to draw a line!)

########
# Perform model selection!


#Compare models using AIC
AIC(m1)
AIC(m2)
AIC(m3)

#Compare models using R-squared
summary(m1)$r.squared 
summary(m2)$r.squared 
summary(m3)$r.squared 

#########
#  And finally, here's how you can draw a confidence interval or prediction interval around a regression relationship!

plot(NUMEGGS ~ FEMWT,data=sculpin.df)                      # plot data
NUMEGGS.confint <- predict(m3,newdata=FEMWT.pred,interval="prediction")             # use "predict()" function to compute the prediction interval!
points(FEMWT.pred$FEMWT,NUMEGGS.confint[,"fit"],col="green",typ="l",lwd=2)  # plot fitted sqrt model
points(FEMWT.pred$FEMWT,NUMEGGS.confint[,"lwr"],col="green",typ="l",lty=2)  # plot fitted sqrt model
points(FEMWT.pred$FEMWT,NUMEGGS.confint[,"upr"],col="green",typ="l",lty=2)  # plot fitted sqrt model


