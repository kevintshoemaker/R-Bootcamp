

##################################################
####                                          ####  
####  R Bootcamp #1, Module 4                 ####
####                                          #### 
####   University of Nevada, Reno             ####
####                                          #### 
##################################################

##################################################
####  PROGRAMMING: FUNCTIONS AND MORE         ####
####      author: Perry Williams              ####
##################################################

## NOTE: this module borrows heavily from an R short-course developed by a team at Colorado State University. 


#######
# Start with blank workspace

rm(list=ls())


## We can write our own functions. Useful if we have to repeat the same operations over and over with different inputs.
my.mean <- function(x){       # 'x' is the function argument- 'x' stands in for whatever numeric vector the user wants
    m <- sum(x)/length(x)
    return(m)
}

foo <- c(2, 4, 6, 8)
my.mean(foo)



## A function to square the arguments.
square <- function(x){
    x^2
}

## Square a single value (scalar).
square(2)

## Square all elements of a vector.
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
plot(x, logit.x, type = 'l',xlab="x",ylab="logit(x)")    # View the output graphically.



## Sequence between 0 and 1.
x <- seq(from = 0, to = 1, by = 0.01)

logit.x <- logit(x)

## The expit (or inverse logit) funtion.
expit <- function(x){
    exp(x)/(1+exp(x))
}

## Calculate the inverse-logit of logit(0.9) = 2.197225.
expit(2.197225)

expit.logit.x <- expit(logit.x)    # Return to original x values.

## Plot x on x-axis, and expit(logit(x)) = x on y axis.
plot(x, expit.logit.x, type = 'l',xlab="x",ylab="expit(logit(x))")

## Plot "logistic" curve
plot(x=seq(-3,3,0.1),y=expit(seq(-3,3,0.1)),type="l",xlab="x",ylab="expit(x)")



## n is the number of animals being monitored.
## d is the number of animals that died.
survival <- function(n, d){
    (n-d)/n
}

## One year of data.
survival(n = 10, d = 5)

## Simulate many years of data.
d <- sample(0:50, 10, replace = TRUE)   # note use of "sample()" function   [random number of dead individuals]
n <- rep(100, times=10)                 # total number of individuals 
surv <- survival(n = n, d = d)
surv

## Plot year-specific survival rate (random- will look different every time!)
plot(1:10, surv, type = 'l',xlab="Year",ylab="Survival")


####
####  if...else statements
####

########
# Draw a sample from a Binomial distribution with p = 0.7 (here, p is detection probability).
p <- 0.7            # probability of detection
x <- rbinom(n = 1, size = 1, prob = p)      # single 'coin flip' with prob success equal to p

if (x > 0) {
    print("Detected")
} else {
    print("Not detected")
}


####
####  ifelse()
####

## Note if...else only works for running one logical (T/F) test at a time. If we have a spreadsheet with lots of data, we need something else.
n.samples <- 100
set.seed(2017)     # the 'seed' allows random number generators to give the same result every time!

## 100 samples from a binomial distribution with detection probability p = 0.7.
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

for(i in 1:10){
  print(i)
}

for(j in c(1,2,3,4,5,6,7,8,9,10)){       # alternative
  print(j)
}


n.iter <- 10                   # another alternative!
count <- 0
for(i in 1:n.iter){
  count <- count+1            # assign a new value of count equal to the old value of count plus 1
  print(count)
}



  # closer look at iteration vector:
1:n.iter


## Using the iteration variable "i" within the for loop:
n.iter <- 5
count <- 0
for(i in 1:n.iter){
  count <- count+i            # assign a new value of count equal to the old value of count + i
  print(count)
}

## A for-loop for dependent sequence (here, the Fibonacci sequence)
n.iter <- 10
x <- rep(0, n.iter)           # set up vector of all zeros
x[1] <- 1                     # assign x_1  <-  1
x[2] <- 1                     # assign x_2 = 0
for(i in 3:n.iter){
  x[i] <- x[i-1]+x[i-2]       # x_i = x_(i-1) + x_(i-2)
}
x



###
### apply (another way to iterate)
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


##########
# lapply: apply a function across a list or vector

lapply(1:5,function(x) exp(x)) 

lapply(1:5, function(t) sqrt(trees$Volume[t]))


##########
# sapply: same thing as 'lapply' but simplifies the returned object (into a vector if possible)

mylist <- list()
mylist[[1]] <- seq(-1,1,length=10)
mylist[[2]] <- c(1,.5,-.4)
mylist[[3]] <- matrix(rnorm(12),nrow=3)
sapply(mylist,function(x) sum(exp(x))) 


#########
# tapply: summarize a vector by group (apply a summary function separately to each group)

df.new <- data.frame(
  var1 = runif(10),
  group = sample(c("A","B"),10,replace=T)
)
tapply(df.new$var1,df.new$group,sum)



####################
####  More Practice ####
####################


###
### Perform hypothesis test using if...then...else
###

n.samples <- 100
x <- rnorm(n = n.samples, mean = 1, sd = 1) # Generate fake data from a normal distribution (using random number generator).
hist(x)
mu <- mean(x)                               # Compute the sample mean.
s <- sd(x)                                  # Compute the sample standard deviation.
t <- mu/(s/sqrt(n.samples))                 # Calculate t-statistic (here, standardized difference of the sample mean from zero)
t.crit <- qt(p = 0.975, df = 99)            # Calculate critical value for test (above which we can reject the null hypothesis with acceptable type-I error)
if (t > t.crit) {
    print("reject")                        # Reject if condition holds.
} else {
    print("fail to reject")                # Fail to reject otherwise.
}


###
### Clean up messy matrix using ifelse
###

## Simulate data.
observations <- matrix(sample(c("Detected", "NotDetected", 1, 0), 20*3, replace = TRUE), 20, 3)    # simulate detection/non-detection data over three sampling occasions

habitat <- rnorm(20, 0, 2)    # simulate environmental covariate
Data <- cbind(observations, habitat)       # bind into single matrix.
Data


## Clean-up data using "ifelse()" function
NewObs <- ifelse( (Data[, 1:3] == "Detected") | (Data[, 1:3] == "1"), 1, 0) #  The "|" means "or." Similarly "&" means "and"
NewHabitat <- as.numeric(Data[, 4])  # as.numeric gets rid of quotes around habitat data.
NewHabitat <- round(NewHabitat, 2)   # round rounds to number of decimals specified.
NewData <- cbind(NewObs, NewHabitat) # bind the columns to form a matrix.
colnames(NewData) <- c("obs1", "obs2", "obs3", "Habitat")  # provide column names
NewData


###
### FOR loop examples
###

#############
## EXAMPLE 1: Plot a 3D surface using data already stored in R.

Z <- 2 * volcano        # Exaggerate the relief (multiply the elevation by 2)   

X <- 10 * (1:nrow(Z))   # set horizontal coordinates -- 10 meter spacing (S to N)     

Y <- 10 * (1:ncol(Z))   # set vertical coordinates -- 10 meter spacing (E to W)

# Z   # make sure the elevation matrix looks right

par(bg = "white")
layout(1)   # reset graphics
persp(X,  Y, Z, theta = 135, phi = 30, col = "green3",    # "persp()" produces a 3D "perspective plot"
      scale = FALSE, ltheta = -120, shade = 0.75,
      border = NA, box = FALSE)


## change the value of theta from 135 to 90 to change the viewing angle
persp(X, Y, Z, theta = 90, phi = 30, col = "green3",
      scale = FALSE,  ltheta = -120, shade = 0.75,
      border = NA, box = FALSE)


## Use a for-loop to help view many angles.
for(i in 1:18){
    persp(X, Y, Z, theta = i*20, phi = 30, col = "green3",
          scale = FALSE,  ltheta = -120, shade = 0.75,
          border = NA, box = FALSE)
    print(i*20)
    readline()                               # Pauses the for-loop until [enter] is pushed
}




##########
# Challenge problem 3: code skeleton to get you started!   

get.t.test <- function(data, mu0, alpha = 0.05) {
    n <- length(data)
    mu <- mean(____)
    s <- ____(data)
    t <- (mu-mu0)/(s/sqrt(n))
    t.crit <- qt(p = (1-alpha/2), df = n-1)        # get the critical value
    if (abs(t)>t.crit) {
        answer = "_______"
    } ____ {
        answer = "Fail to reject"
    }
    print(answer)
}


#######
# Example code to get you started with challenge problem 5... 

persp(X, Y, Z, theta = 30, phi = 30, col = "green3",  lphi = ?, scale = FALSE,  ltheta = -120, shade = 0.75, border = NA, box = FALSE)
print(?)
readline()


##################
## EXAMPLE 2: Use a FOR loop to create a simulation to test the central limit theorem (CLT).

n.iter <- 1000                                # large number of hypothetical "repeat samples."
sample.size <- 30                             # Sample size of 30 from each repeat sample.
min <- 2                                       # True population minimum of 2.
max <- 6                                       # True population maximum of 6.
means <- numeric(n.iter)                      # Initialize empty vector to store the sample means.
for(i in 1:n.iter){                           # For each of the repeat samples...
    sample <- runif(sample.size,min=min,max=max)     # draw a random sample from the true population
    means[i] <- mean(sample)                # and store the sample mean.
}
hist(means)                                # Histogram of all the means.
abline(v = mean(means), col = 2, lwd = 4)          # The mean of the means is close to the true mean of 4.
plot(density(means), main = "")
abline(v = mean(means), col = 2, lwd = 4)
mean(means)                                # Close to true mean of 5



##############
##  Logistic population growth example (uses function and for loop)


## Logistic growth function: calculate population size using logistic growth model.
  # K = carrying capacity.
  # r = intrinsic growth rate
  # P0 = initial population size

logistic.growth <- function(r, P0, K){            
    dpdt <- r*P0*(1-P0/K)                   # implement logistic growth equation
    P0+dpdt                                   
}                                           
logistic.growth(r = .5, P0 = 10, K = 100)   # try out the new function!


## Logistic growth function within a for-loop

years <- 20                                   # How many years we want to calc population size.
pop.size <- numeric(years)                    # Empty vector to store population size.
pop.size[1] <- 5                              # Starting population size (P0).
for(i in 1:(years-1)){                     # Function within a FOR loop!
    pop.size[i+1] <- logistic.growth(r = 0.5, P0 = pop.size[i], K = 100)
}
plot(1:years, pop.size, type = 'l',
     xlab = "Years", ylab = "Population Size")


## A more complex function that outputs a plot.
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

