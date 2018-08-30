
##################################################
####                                          ####  
####  R Bootcamp #2, Module 1                 ####
####                                          #### 
####   University of Nevada, Reno             ####
####                                          #### 
##################################################

## NOTE: this module borrows heavily from an R short-course developed by a team at Colorado State University. 
   # Thanks to Perry Williams for allowing us to use these materials!!

##########################################
####  PROGRAMMING: FUNCTIONS AND MORE ####
##########################################



#######
# Start with blank workspace

rm(list=ls())



####
####  Functions
####

my.function = function(){       # this function has no arguments
  message <- "Hello, world!"
  print(message)
}


my.function()


## We can write our own functions. Useful if we have to repeat operations over and over.
my.mean <- function(x){
    m <- sum(x)/length(x)
    return(m)
}

foo <- c(2, 4, 6, 8)
my.mean(foo)



## A function to square the arguments.
square <- function(x){
    x^2
}

## Square a single value (scaler).
square(2)

## Square a vector.
square(1:10)



## Often, we need to write functions that are not included in the base R package e.g., the logit function.
## Calculate the log-odds (logit).
logit <- function(x){
    log(x/(1-x))
}

## Calculate logit of 0.9.
logit(.9)

## Sequence between 0 and 1.
x <- seq(from = 0, to = 1, by = 0.01)

## Caclulate the logit of a vector.
logit.x <- logit(x)
logit.x

## Plot x on x-axis, and logit(x) on y axis.
par(mfrow = c(1, 1))
plot(x, logit.x, type = 'l')    # View the output graphically.


## The expit (or inverse logit) funtion.
expit <- function(x){
    exp(x)/(1+exp(x))
}

## Calculate the inverse-logit of logit(0.9) = 2.197225.
expit(2.197225)

expit.logit.x <- expit(logit.x)    # Return to original x values.

## Plot x on x-axis, and expit(logit(x)) = x on y axis.
plot(x, expit.logit.x, type = 'l')

## Plot "logistic" curve
plot(x=seq(-3,3,0.1),y=expit(seq(-3,3,0.1)),type="l")



## Kaplan Meier known-fate maximum likelihood estimator.
survival.mle <- function(n, d){
    (n-d)/n
}
## n is the number of animals fitted with ratio transmitters being monitored.
## d is the number of n that died.

## One year of data.
survival.mle(n = 10, d = 5)

## Many years of data.
d <- sample(0:50, 10, replace = TRUE)
n <- c(100, 100-d)
(surv <- survival.mle(n = n[1:10], d = d))

## Plot year-specific survival rate.
plot(1:10, surv, type = 'l')


####
####  if...else statements
####

########
# Draw a sample from a Binomial distribution with p = 0.7 (here, p is detection probability).
n.samples <- 1
p <- 0.7
x <- rbinom(n = n.samples, size = 1, prob = p)

if (x > 0) {
    print("Detected")
} else {
    print("Not detected")
}



####
####  ifelse()
####

## Note if...else only works for testing one value. If we have a spreadsheet with lots of data, need something else.
n.samples <- 100
set.seed(2017)

## 100 samples from a binomial disribution with detection probability = p = 0.7.
y <- rbinom(n = n.samples, size = 1, prob = p)
y

## incorrect usage
if (y == 1) {
    print("Detected")
} else {
    print("Not detected")
}   # PRINTS A WARNING MESSAGE!

## Use ifelse instead.
detection.history <- ifelse(y == 1, print("Detected"), print("Not detected"))
detection.history

## Going the other direction.
ifelse(detection.history == "Detected", 1, 0)

xt  <-  cbind(rbinom(10, 1, .5), rbinom(10, 1, .6))
xt
ifelse(xt[, 1] > 0 & xt[, 2] > 0, print("Detected twice"),
       print("Not detected twice"))



####
####  for loops
####

n.iter <- 10
count <- 0
for(i in 1:n.iter){
    count <- count+1            # assign a new value of count equal to the old value of count + 1
    print(count)
}



  # closer look at iteration vector:
1:n.iter


## Using the placeholder variable "i" within the for loop:

count <- 0
for(i in 1:n.iter){
    count <- count+i            # assign a new value of count equal to the old value of count + i
    print(count)
}

## A for-loop for dependent sequence (here, the Fibonacci sequence)
n.iter <- 10
x <- rep(0, n.iter)            # set up vector of all zeros
x[1] <- 1                     # assign x_1  <-  1
x[2] <- 1                     # assign x_2 = 0
x

for(i in 3:n.iter){
    x[i] <- x[i-1]+x[i-2]       # x_i = x_(i-1) + x_(i-2)
}
x



###
### apply
###

W <- matrix(rpois(4, 10), nrow = 2, ncol = 2)  # Create a 2X2 matrix using a Poisson distribution with lambda = 10.
W

## Calculate the row means.
apply(W, 1, mean)

## Calculate the column means.
apply(W, 2, mean)

## Identify the column that has the largest value.
apply(W, 1, which.max)

## Apply your own functions to each row in a matrix.
MyFunc <- function(x){
    2+sum(x/5)-3/2*mean(x)^2
}
apply(W, 1, MyFunc)


####################
####  Exercises ####
####################

## if...else
## Reject or fail to reject a null hypothesis.
n.samples <- 100
x <- rnorm(n = n.samples, mean = 1, sd = 1) # Sample from a normal distribution.
mu <- mean(x)                               # Sample mean.
s <- sd(x)                                  # Sample standard deviation.
t <- mu/(s/sqrt(n.samples))                 # Calculate t-statistic.
t.crit <- qt(p = 0.975, df = 99)            # Calculate critical value for test.
if (t > t.crit) {
    print("reject")                        # Reject if condition holds.
} else {
    print("fail to reject")                # Fail to reject otherwise.
}

###
### Clean up messy matrix using ifelse
###

## Simulate data.
observations <- matrix(sample(c("Detected", "NotDetected", 1, 0), 20*3, replace = TRUE), 20, 3)
habitat <- rnorm(20, 0, 2)
Data <- cbind(observations, habitat)
Data

## Clean-up data
NewObs <- ifelse(Data[, 1:3] == "Detected"|Data[, 1:3] == "1", 1, 0) #  The "|" means "or." Similarly "&" means "and"
NewHabitat <- as.numeric(Data[, 4])  # as.numeric gets rid of quotes around habitat data.
NewHabitat <- round(NewHabitat, 2)   # round rounds to number of decimals specified.
NewData <- cbind(NewObs, NewHabitat) # bind the columns to form a matrix.
colnames(NewData) <- c("obs1", "obs2", "obs3", "Habitat")  # provide column names
NewData

###
### for loop
###

## Plot a 3D surface using data already stored in R.
Z <- 2 * volcano        # Exaggerate the relief
X <- 10 * (1:nrow(Z))   # 10 meter spacing (S to N)
Y <- 10 * (1:ncol(Z))   # 10 meter spacing (E to W)
Z
par(mfrow = c(2,1), bg = "white")
persp(X,  Y, Z, theta = 135, phi = 30, col = "green3",
      scale = FALSE, ltheta = -120, shade = 0.75,
      border = NA, box = FALSE)

## change the value of theta from 135 to 90 to change the viewing angle
persp(X, Y, Z, theta = 90, phi = 30, col = "green3",
      scale = FALSE,  ltheta = -120, shade = 0.75,
      border = NA, box = FALSE)

## Use a for-loop to help view many angles.
par(mfrow = c(1,1))
for(i in 1:18){
    persp(X, Y, Z, theta = i*20, phi = 30, col = "green3",
          scale = FALSE,  ltheta = -120, shade = 0.75,
          border = NA, box = FALSE)
    print(i*20)
    readline()                               # Pauses the for-loop until [enter] is pushed
}

## Use a for-loop to create a simulation to test the central limit theorem.
n.iter <- 1000                                # 1000 hypothetical "repeat samples."
sample.size <- 30                             # Sample size of 30 from each repeat sample.
mu <- 5                                       # True population mean of 5.
sd <- 2                                       # True standard deviation of 2.
means <- numeric(n.iter)                      # Empty vector to store the sample means.
for(i in 1:n.iter){                        # For each of the repeat samples, calculate and
    sample <- rnorm(sample.size, mean = mu, sd = sd)  # store the mean.
    means[i] <- mean(sample)
}
hist(means)                                # Histogram of all the means.
abline(v = mean(means), col = 2, lwd = 4)          # The mean of the means is close to the true mean of 5.
plot(density(means), main = "")
abline(v = mean(means), col = 2, lwd = 4)
mean(means)                                # Close to true mean of 5
sd(means)*sqrt(30)                         # Close to true sd of 2

## Logistic growth function.
logistic.growth <- function(r, P0, K){          # A function to calculate population
    dpdt <- r*P0*(1-P0/K)                       # size using logistic growth model.
    P0+dpdt                                  # r = intrinsic growth rate, P0 = initial population size,
}                                          # K = carrying capacity.
logistic.growth(r = .5, P0 = 10, K = 100)

## Logistic growth function within a for-loop
years <- 20                                   # How many years we want to calc population size.
pop.size <- numeric(years)                    # Empty vector to store population size.
pop.size[1] <- 5                              # Starting population size (P0).
for(i in 1:(years-1)){                     # Function within a for-loop.
    pop.size[i+1] <- logistic.growth(r = 0.5, P0 = pop.size[i], K = 100)
}
plot(1:years, pop.size, type = 'l',
     xlab = "Years", ylab = "Population Size")

## A more complex function that ouputs a plot.
plot.logistic.growth <- function(r, P, K, years){
    pop.size[1] <- P
    for(i in 1:(years-1)){
        pop.size[i+1] <- P+r*P*(1-P/K)
        P <- pop.size[i+1]
    }
    plot(1:years, pop.size, type = 'l', xlab = "Years",
         ylab = "Population Size",
         main = paste("r = ", r, "K = ", K))
}

plot.logistic.growth(r = 0.5, P = 10, K = 100, years = 20)
par(mfrow = c(2, 2), mar = c(4, 4, 1, 1))                  # Multi-figure (mf) plot with 2 rows and 2 columns.
plot.logistic.growth(r = 0.1, P = 10, K = 100, years = 20)   # Change the values of r and quickly print plots.
plot.logistic.growth(r = 0.2, P = 10, K = 100, years = 20)
plot.logistic.growth(r = 0.3, P = 10, K = 100, years = 20)
plot.logistic.growth(r = 0.5, P = 10, K = 100, years = 20)
par(mfrow = c(1, 1))                               # Return to a 1X1 plot.
