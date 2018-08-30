##################################################
####                                          ####  
####  R Bootcamp #1, Module 3                 ####
####                                          #### 
####   University of Nevada, Reno             ####
####                                          #### 
##################################################

## NOTE: this module borrows heavily from an R short course developed by a team at Colorado State University. 
   # Thanks to Perry Williams for allowing us to use these materials!!
   # Thanks to John Tipton at CSU for developing much of this module (plotting in R)!

############################################
####  Data visualization and statistics ####
############################################



?trees      # description of built in dataset

dim(trees)   # Show the dimension of the trees dataframe                                              

str(trees)   # Show the structure of the trees dataframe

head(trees)   # Show the first few observations of the trees dataframe


# Access the columns 
trees$Girth     
trees$Volume


plot(x=trees$Girth, y=trees$Volume)    # use R's built-in "trees" dataset: ?trees


?par

par()   # view the default graphical parameters


# Use "layout" to define a 2 row x 2 column matrix with elements 1, 2, 3, and 4.
# This divides the image into four sections and then fills these with the plot function
layout(matrix(1:4, nrow=2, ncol=2))

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
layout(matrix(c(1, 1, 2, 3), 2, 2))

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


plot.colors <- c("violet", "purple", "blue")


color.vector <- rep(x=plot.colors, each=50)
color.vector
## color vector is now a list of our colors, each repeated 50 times

plot(x=iris$Petal.Length, y=iris$Sepal.Length, pch=19, col=color.vector, 
     main="Plot of Iris colored by species")


length(iris$Petal.Length)
length(iris$Sepal.Length)
length(color.vector)


plot.colors <- c("violet", "purple", "blue")
# subset the colors in plot.colors based on the variable iris$Species
# iris$Species is a factor variable that has 3 levels
color.vector <- plot.colors[iris$Species]

plot(x=iris$Petal.Length, y=iris$Sepal.Length, pch=19, col=color.vector, 
     main="Iris sepal length vs. petal length", xlab="Petal length", 
     ylab="Sepal length", las=1)


layout(matrix(1:3, 1, 3))

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


## calculate the mean Sepal Length of for each species
bar.heights <- by(iris$Sepal.Length, iris$Species, mean)

# The basic barplot function
barplot(bar.heights)


# Let's add some flair
barplot(bar.heights, names.arg=c("I. setosa", "I. versicolor", "I. virginica"), 
        las=1, col=adjustcolor(plot.colors, alpha.f=0.5),
        main="Sepal length for 3 Irises", ylab="Sepal length (cm)")


CI <- 2 * by(iris$Sepal.Length, iris$Species, sd)
lwr <- bar.heights - CI
upr <- bar.heights + CI

# I used the ylim= argument to pass a 2-element numeric vector specifying the y extent of the barplot. I added some extra room on the top to account for error bars.
# Importantly, assign the barplot to an object. I called it 'b' but you can call it whatever you like.

b <- barplot(bar.heights, 
             names.arg=c("I. setosa", "I. versicolor", "I. virginica"), 
             las=1, ylim=c(0,8), col=adjustcolor(plot.colors, alpha.f=0.5),
             main="Sepal length for 3 Irises", ylab="Sepal length (cm)")

# Specify where each arrow starts (x0= and y0=) and ends (x1= and y1=)
arrows(x0=b, x1=b, y0=lwr, y1=upr, code=3, angle=90, length=0.1)


layout(matrix(1:2, 1, 2))
## y-axis is in counts
hist(iris$Sepal.Length, main="Histogram of Sepal Length",
     xlab = "Sepal Length")
## change y-axis to proportions using freq=FALSE
hist(iris$Sepal.Length, freq=FALSE, main="Histogram of Sepal Length", 
     xlab = "Sepal Length")
## Add a density estimator
lines(density(iris$Sepal.Length))


pairs(iris)


?ToothGrowth
head(ToothGrowth)


plot.colors <- c("red", "blue")
# subset the colors in plot.colors based on the variable iris$Species
# iris$Species is a factor variable that has 3 levels
color.vector <- plot.colors[ToothGrowth$supp]

plot(x=ToothGrowth$len, y=ToothGrowth$dose, pch=19, col=color.vector, 
     main="Tooth Growth vs. Vitamin C Dose", xlab="Viatmin C Dose (mg)", 
     ylab="Tooth Growth (mm)", las=1)

# First legend
legend("topleft", pch=19, col=plot.colors, legend=unique(ToothGrowth$supp))


prop <- c(0.18, 0.25, 0.13, 0.05)
asympLCL <- c(0.14, 0.20, 0.11, 0.035)
asympUCL <- c(0.24, 0.33, 0.18, 0.09)


plot.colors <- c("red", "blue", "yellow", "green")
b <- barplot(prop, ylim = c(0, max(asympUCL)),
        names.arg=c("ambient", "watered", "heated + watered", "heated"),
        las=1, col=adjustcolor(plot.colors, alpha.f=0.5),
        main="Plant Survivorship by treatment", ylab="Probability of survival")
arrows(x0=b, x1=b, y0=asympLCL, y1=asympUCL, code=3, angle=90, length=0.1)


set.seed(13)
n <- 20 # Number of experimental trials
a <- 12
b <- 1.5

rings <- round(runif(n)*50)
wings <- round(a + b*rings + rnorm(n, sd=5))
offset <- rpois(n, lambda=10)
lwr <- wings - offset
upr <- wings + offset


plot(x=rings, y=wings, ylim=c(min(lwr), max(upr)), 
     ylab="Number of Angels Who Get Wings", xlab="Number of Bell Rings", 
     main="Bell Rings vs. Angels Getting Wings", pch=19, col="blue")
arrows(x0=rings, x1=rings, y0=lwr, y1=upr, code=3, angle=90, length=0.1)


####################
# STATISTICS!
####################

#####
#####  Load Data
#####

sculpin.df <- read.csv("sculpineggs.csv")

head(sculpin.df)

summary(sculpin.df) # provides a set of summary statistics for data frame. 


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
AIC(m1)                                 # report AIC 

plot(x = sculpin.df$FEMWT,y = sculpin.df$NUMEGGS)    # plot data
abline(m1)                                           # plot line of best fit

FEMWT.pred <- data.frame(FEMWT = 30)                   # create new data frame to predict number of eggs at FEMWT of 30
predict(m1,newdata=FEMWT.pred)                         # make prediction
predict(m1,newdata=FEMWT.pred,interval="confidence")   # make prediction and get confidence interval
predict(m1,newdata=FEMWT.pred,interval="prediction")   # make prediction and get prediction interval



####################
####  Exercises ####
####################

m1 <- lm(NUMEGGS ~ FEMWT, data=sculpin.df)                  # fit linear regression model
summary(m1)

m2 <- lm(NUMEGGS ~ 1, data=sculpin.df)                      # fit linear regression with intercept only (mean model)
summary(m2)

m3 <- lm(NUMEGGS ~ I(FEMWT^0.5), data=sculpin.df)           # fit linear regression with intercept and sqrt of FEMWT term

plot(NUMEGGS ~ FEMWT,data=sculpin.df)                      # plot data
abline(m1,col="black")                                     # plot line of best fit
abline(m2,col="red")                                       # plot intercept only model

FEMWT.pred <- data.frame(FEMWT = seq(10,45,by=0.1))        # create new data frame to predict number of eggs from FEMWT of 10 to 45 by increments of 0.1
NUMEGGS.pred <- predict(m3,newdata=FEMWT.pred)             # make prediction
points(FEMWT.pred$FEMWT,NUMEGGS.pred,col="green",typ="l")  # plot sqrt model

#Compare models using AIC and R-squared
AIC(m1)
AIC(m2)
AIC(m3)

summary(m1)$r.squared 
summary(m2)$r.squared 
summary(m3)$r.squared 

